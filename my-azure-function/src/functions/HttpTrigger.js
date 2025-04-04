const { app } = require('@azure/functions');

app.http('HttpTrigger', {
    methods: ['GET'],
    authLevel: 'function',
    handler: async (request, context) => {
        context.log('JavaScript HTTP trigger function processed a request.');

        const name = request.query.get('name') || (request.body && request.body.name);
        const responseMessage = name
            ? `Hello, ${name}! Welcome to my Azure Function with CI/CD pipeline.`
            : "Hello! This is my Azure Function with CI/CD pipeline. Pass a name in the query string for a personalized greeting.";
        
        return {
            status: 200,
            body: responseMessage
        };
    }
}); 