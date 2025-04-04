const { main } = require('../FunctionApp/index');
const supertest = require('supertest');

describe('Azure Function Tests', () => {
    let context = { log: jest.fn() };

    // Test 1: Verify response status code is 200
    it('should return status code 200', async () => {
        const req = { method: 'GET' };
        await main(context, req);
        expect(context.res.status).toBe(200);
    });

    // Test 2: Verify response body is "Hello, World!"
    it('should return "Hello, World!"', async () => {
        const req = { method: 'GET' };
        await main(context, req);
        expect(context.res.body).toBe("Hello, World!");
    });

    // Test 3: Verify POST request works
    it('should handle POST requests', async () => {
        const req = { method: 'POST' };
        await main(context, req);
        expect(context.res.status).toBe(200);
    });
});