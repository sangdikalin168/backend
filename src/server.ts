import http from 'http';
import { ApolloServer } from '@apollo/server';
import { expressMiddleware } from '@apollo/server/express4';
import { createApp } from './app';
import { loadGraphQLModules } from './schema';
import { authenticate } from './common/middlewares/auth.middleware';
import { Request, Response, NextFunction } from 'express';
import { Context } from './common/types/context.type';
import { ExpressContextFunctionArgument } from '@apollo/server/express4';
import { ApolloServerPluginLandingPageGraphQLPlayground } from '@apollo/server-plugin-landing-page-graphql-playground';


async function startServer() {
    const app = createApp();
    const { typeDefs, resolvers } = await loadGraphQLModules();

    const server = new ApolloServer<Context>({
        typeDefs,
        resolvers,
        introspection: true,
        plugins: [ApolloServerPluginLandingPageGraphQLPlayground()],
    });

    await server.start();

    app.use(
        '/graphql',
        expressMiddleware(server, {
            context: async ({ req, res }: ExpressContextFunctionArgument): Promise<Context> => {
                return authenticate({ req, res });
            },
        })
    );

    app.get('/', (req: Request, res: Response, next: NextFunction) => {
        res.status(200).json({ status: 'OK' });
    });
    
    const PORT = process.env.PORT ? parseInt(process.env.PORT) : 4000;
    const httpServer = http.createServer(app);

    await new Promise<void>((resolve) =>
        httpServer.listen({ port: PORT }, resolve)
    );

    console.log(`🚀 Server ready at http://localhost:${PORT}/graphql`);
}

startServer();
