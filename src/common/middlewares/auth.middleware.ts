import { Request, Response } from 'express';
import { verifyToken } from '../utils/jwt.utils';
import { PrismaClient } from '@prisma/client';
import { User } from '../types/user.type';
import { createUserLoader } from '../utils/data-loader.utils';
import { Context } from '../types/context.type';
import { Role } from '../enums/role.enum';

const prisma = new PrismaClient();

export const authenticate = async ({
    req,
    res,
}: {
    req: Request;
    res: Response;
}): Promise<Context> => {
    let user: User | null = null;

    const token = req.cookies.token || req.headers.authorization?.replace('Bearer ', '');

    if (token) {
        try {
            const { userId } = verifyToken(token);
            const dbUser = await prisma.user.findUnique({ where: { id: userId } });

            if (!dbUser) throw new Error('User not found');

            const userRecord: User = {
                id: dbUser.id,
                email: dbUser.email,
                name: dbUser.name ?? 'Anonymous', // ✅ Handle null case
                password: dbUser.password,
                role: Role[dbUser.role as keyof typeof Role],
                createdAt: dbUser.createdAt,
                updatedAt: dbUser.updatedAt,
            };

            user = userRecord;
        } catch (error) {
            console.error('Authentication failed:', error instanceof Error ? error.message : String(error));
        }
    }

    const userLoader = createUserLoader(prisma);

    return {
        req,
        res,
        user,
        userLoader,
        prisma,
    };
};