import { Resolvers } from '../../generated/graphql';
import bcrypt from 'bcryptjs';
import { generateAccessToken, verifyToken, generateRefreshToken } from '../../common/utils/jwt.utils';
import { PrismaClient } from '@prisma/client';
import { registerSchema, loginSchema } from '../../common/validations/auth.validation';
import { redisClient } from '../../common/utils/redis.utils';
import { Role } from '../../common/enums/role.enum';


const prisma = new PrismaClient();

export const resolvers: Resolvers = {
    Mutation: {
        register: async (_parent, args) => {

            // Validate input
            const parsed = registerSchema.parse(args);
            const { email, name, password } = parsed;

            // Check if user already exists
            const existingUser = await prisma.user.findUnique({
                where: { email },
            });

            if (existingUser) {
                throw new Error('Email already in use');
            }

            // Hash password
            const hashedPassword = await bcrypt.hash(password, 10);

            // Create user
            const user = await prisma.user.create({
                data: {
                    email,
                    name,
                    password: hashedPassword,
                    role: Role.USER, // default role
                },
            });

            // Generate token
            const accessToken = generateAccessToken(user.id);
            const refreshToken = generateRefreshToken(user.id);

            // Set refresh token in Redis
            await redisClient.setex(refreshToken, 60 * 60 * 24 * 7, `${user.id}`);

            return {
                user: {
                    ...user,
                    id: user.id.toString(), // cast to string to match GraphQL type
                    role: user.role as Role, // cast to string to match GraphQL type
                },
                token: accessToken,
                refreshToken,
            };
        },
        login: async (_parent, args, context) => {
            // Validate input
            const parsed = loginSchema.parse(args);
            const { email, password } = parsed;

            // Find user
            const user = await prisma.user.findUnique({
                where: { email },
            });

            if (!user) {
                throw new Error('Invalid credentials');
            }

            // Check password
            const isValid = await bcrypt.compare(password, user.password);

            if (!isValid) {
                throw new Error('Invalid credentials');
            }

            // Generate token
            const accessToken = generateAccessToken(user.id);
            const refreshToken = generateRefreshToken(user.id);

            // Save refresh token in Redis (7 days)
            await redisClient.setex(refreshToken, 7 * 24 * 60 * 60, `${user.id}`);


            // Set refresh token in HttpOnly cookie
            context.res.cookie('refresh_token', refreshToken, {
                httpOnly: true,
                secure: process.env.NODE_ENV === 'production',
                sameSite: 'strict',
                maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days
            });

            return {
                user,
                token: accessToken,
            };
        },
        logout: async (_, { refreshToken }) => {
            await redisClient.del(refreshToken);
            return true;
        },
        refreshToken: async (_, { refreshToken }) => {

            let payload;
            try {
                payload = verifyToken(refreshToken);
            } catch (err) {
                throw new Error('Invalid refresh token');
            }

            const userId = payload.userId;

            // Check if refresh token is valid in Redis
            const storedUserId = await redisClient.get(refreshToken);

            if (!storedUserId || parseInt(storedUserId) !== userId) {
                throw new Error('Invalid or expired refresh token');
            }

            // Generate new access token
            const token = generateAccessToken(userId);

            return {
                token,
            };
        }
    },

    Query: {
        me: (_parent, _args, context) => {
            if (!context.user) {
                throw new Error('Not authenticated');
            }
            return context.user;
        },
        adminOnly: (_parent, _args, context) => {
            if (!context.user) {
                throw new Error('Not authenticated');
            }

            if (context.user.role !== Role.ADMIN) {
                throw new Error('Forbidden: Admins only');
            }

            return 'Secret admin data';
        },
    },
}


