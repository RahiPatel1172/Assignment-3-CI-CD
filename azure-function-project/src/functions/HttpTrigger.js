const { app } = require('@azure/functions');

app.http('HttpTrigger', {
    methods: ['GET'],
    authLevel: 'function',
    handler: async (request, context) => {
        context.log('JavaScript HTTP trigger function processed a request.');

        const name = request.query.get('name') || (request.body && request.body.name);
        const responseMessage = name
            ? "Hello, " + name + "! This HTTP triggered function executed successfully."
            : "Hello, World! This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response.";
        
        return {
            status: 200,
            body: responseMessage
        };
    }
});
