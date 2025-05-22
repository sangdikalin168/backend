import { Role } from '../enums/role.enum';

export type User = {
    id: number;
    email: string;
    name: string | null; // ✅ Allow null
    password: string;
    role: Role;
    createdAt: Date;
    updatedAt: Date;
};