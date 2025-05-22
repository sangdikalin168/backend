import express, { Express } from 'express';
import cookieParser from 'cookie-parser';
import cors from 'cors';
import helmet from 'helmet';

export const createApp = (): Express => {
    const app = express();

    // Middleware
    app.use(express.json());
    app.use(cookieParser());
    app.use(helmet());

    // CORS configuration
    // Allow Apollo Studio to connect
    const allowedOrigins = [
        'http://localhost:3000',
        'https://studio.apollographql.com',
    ];
    app.use(
        cors({
            origin: allowedOrigins,
            credentials: true,
            methods: ['GET', 'POST', 'PUT', 'DELETE'],
        })
    );

    // Basic health check route
    app.get('/health', (req, res) => {
        res.status(200).json({ status: 'OK' });
    });

    return app;
};