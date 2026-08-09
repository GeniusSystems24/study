import { Router } from 'express';
import { asyncHandler } from '../../../../core/http/asyncHandler.js';

export function createNotificationRouter({ notificationController }) {
  const router = Router();
  router.post('/send', asyncHandler(notificationController.send));
  return router;
}
