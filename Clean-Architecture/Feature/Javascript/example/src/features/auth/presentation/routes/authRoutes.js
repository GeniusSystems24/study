import { Router } from 'express';
import { asyncHandler } from '../../../../core/http/asyncHandler.js';

export function createAuthRouter({ authController }) {
  const router = Router();
  router.post('/login', asyncHandler(authController.login));
  return router;
}
