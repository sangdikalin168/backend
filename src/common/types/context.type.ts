//context.type.ts
import { Request, Response } from 'express';
import DataLoader from 'dataloader';
import { User } from './user.type';
import { PrismaClient } from '@prisma/client';

export type Context = {
    req: Request;
    res: Response;
    user: User | null;  // required, but can be null when unauthenticated
    userLoader: DataLoader<number, any>;
    prisma: PrismaClient;
};