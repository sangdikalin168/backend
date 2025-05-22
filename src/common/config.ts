import dotenv from 'dotenv';

dotenv.config();

export const config = {
    JWT_SECRET: process.env.JWT_SECRET || 'fallback-secret-key',
    PORT: parseInt(process.env.PORT || '4000'),
    REDIS_HOST: process.env.REDIS_HOST || 'localhost',
    REDIS_PORT: parseInt(process.env.REDIS_PORT || '6379'),
};