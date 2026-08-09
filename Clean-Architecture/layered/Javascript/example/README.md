# JavaScript Layered Clean Architecture Example

A runnable Node.js example that demonstrates:

- Presentation, Application, Domain, and Infrastructure/Data layers.
- SOLID principles applied across layer boundaries.
- Login, order creation, and order retrieval use cases.
- Dependency injection through a composition root.
- Unit tests with the built-in `node:test` runner.
- A simple dependency-boundary checker.

## Requirements

- Node.js 20 or newer.

## Run

```bash
npm test
npm run check:boundaries
npm start
```

The server listens on `http://localhost:3000`.

## Demo credentials

- Email: `anwar@example.com`
- Password: `secret123`

## Example requests

```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H 'content-type: application/json' \
  -d '{"email":"anwar@example.com","password":"secret123"}'
```

```bash
curl -X POST http://localhost:3000/api/orders \
  -H 'content-type: application/json' \
  -d '{"userId":"u-1","currency":"USD","items":[{"productId":"p-1","name":"Keyboard","unitPrice":80,"quantity":2}]}'
```
