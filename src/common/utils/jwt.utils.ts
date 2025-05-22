import * as jwt from 'jsonwebtoken';
import { config } from '../config';

export const generateAccessToken = (userId: number): string => {
    return jwt.sign({ userId }, config.JWT_SECRET, { expiresIn: '15m' });
};

export const generateRefreshToken = (userId: number): string => {
    return jwt.sign({ userId }, config.JWT_SECRET, { expiresIn: '7d' });
};

export const verifyToken = (token: string): { userId: number } => {
    return jwt.verify(token, config.JWT_SECRET) as { userId: number };
};