import DataLoader from 'dataloader';
import { PrismaClient } from '@prisma/client';
import { User } from '../../common/types/user.type';

interface UserBatchResponse {
    id: number;
}

// Batch function to load users by IDs
const batchUsers = async (prisma: PrismaClient, ids: readonly number[]) => {
    const users = await prisma.user.findMany({
        where: {
            id: {
                in: ids as number[],
            },
        },
    });

    const userMap = new Map(users.map((user) => [user.id, user]));

    return ids.map(id => userMap.get(id) || null);
};

export const createUserLoader = (prisma: PrismaClient) => {
    return new DataLoader<number, any>(async (keys) => {
        return batchUsers(prisma, keys as readonly number[]);
    });
};