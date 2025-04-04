const { app } = require('@azure/functions');

describe('HttpTrigger Tests', () => {
    let context;
    let request;

    beforeEach(() => {
        context = {
            log: jest.fn()
        };
        request = {
            query: new Map(),
            body: null
        };
    });

    test('should return 200 status code', async () => {
        const response = await app.http.get('HttpTrigger').invoke(request, context);
        expect(response.status).toBe(200);
    });

    test('should return default message when no name provided', async () => {
        const response = await app.http.get('HttpTrigger').invoke(request, context);
        expect(response.body).toContain('This is my Azure Function with CI/CD pipeline');
    });

    test('should return personalized message when name provided', async () => {
        request.query.set('name', 'John');
        const response = await app.http.get('HttpTrigger').invoke(request, context);
        expect(response.body).toContain('Hello, John!');
    });
}); 