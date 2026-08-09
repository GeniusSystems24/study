import express from 'express';
import { createAuthRouter } from './features/auth/presentation/routes/authRoutes.js';
import { createNotificationRouter } from './features/notifications/presentation/routes/notificationRoutes.js';
import { errorMiddleware, notFoundMiddleware } from './core/http/errorMiddleware.js';
import { createContainer } from './infrastructure/container.js';

export function createApp() {
  const app = express();
  const container = createContainer();

  app.use((req, res, next) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    if (req.method === 'OPTIONS') return res.sendStatus(204);
    next();
  });
  app.use(express.json({ limit: '100kb' }));

  app.get('/health', (_req, res) => res.json({ status: 'ok' }));
  app.use('/api/auth', createAuthRouter(container));
  app.use('/api/notifications', createNotificationRouter(container));
  app.use(notFoundMiddleware);
  app.use(errorMiddleware);

  return app;
}
