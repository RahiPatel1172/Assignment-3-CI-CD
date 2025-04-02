const { execSync } = require('child_process');
const http = require('http');

describe('Azure Function Tests', () => {
    let functionUrl;

    beforeAll(() => {
        // In a real scenario, this would be your deployed function URL
        functionUrl = process.env.FUNCTION_URL || 'http://localhost:7071/api/HttpTrigger';
    });

    test('should return 200 status code', async () => {
        const response = await new Promise((resolve) => {
            http.get(functionUrl, (res) => {
                resolve(res);
            });
        });
        expect(response.statusCode).toBe(200);
    });

    test('should return Hello World message', async () => {
        const response = await new Promise((resolve) => {
            http.get(functionUrl, (res) => {
                let data = '';
                res.on('data', (chunk) => {
                    data += chunk;
                });
                res.on('end', () => {
                    resolve(data);
                });
            });
        });
        expect(response).toContain('Hello, World!');
    });

    test('should handle name parameter', async () => {
        const name = 'TestUser';
        const response = await new Promise((resolve) => {
            http.get(`${functionUrl}?name=${name}`, (res) => {
                let data = '';
                res.on('data', (chunk) => {
                    data += chunk;
                });
                res.on('end', () => {
                    resolve(data);
                });
            });
        });
        expect(response).toContain(`Hello, ${name}!`);
    });
}); 