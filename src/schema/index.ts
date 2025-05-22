import path from 'path';
import { loadFilesSync } from '@graphql-tools/load-files';
import { mergeTypeDefs, mergeResolvers } from '@graphql-tools/merge';

export async function loadGraphQLModules() {
    const MODULES_ROOT = path.join(__dirname, '../modules');
    const isProd = process.env.NODE_ENV === 'production';
    const extension = isProd ? 'js' : 'ts';

    // Load schema files
    const schemaFiles = loadFilesSync(path.join(MODULES_ROOT, '**/*.graphql'));
    console.log('✅ Schema files found:', schemaFiles.length);
    const typeDefs = mergeTypeDefs(schemaFiles);

    // Load resolver files
    console.log('🔍 Loading resolvers from:', path.join(MODULES_ROOT, `**/*.resolver.${extension}`));
    const resolverFiles = loadFilesSync(
        path.join(MODULES_ROOT, `**/*.resolver.${isProd ? 'js' : 'ts'}`),
        {
            useRequire: true,
            requireMethod: (path: string) => path
        }
    );

    console.log('🎯 Resolver files matched:', resolverFiles.length);

    const resolverModules = resolverFiles.map((file) => {
        const mod = require(file); // <-- Fix here
        return mod.resolvers ?? {};
    });


    const resolvers = mergeResolvers(resolverModules);

    return { typeDefs, resolvers };
}
