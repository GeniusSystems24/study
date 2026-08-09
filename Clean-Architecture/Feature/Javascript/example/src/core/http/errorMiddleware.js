import { AppError } from '../errors/AppError.js';

export function notFoundMiddleware(req, _res, next) {
  next(new AppError(`Route not found: ${req.method} ${req.originalUrl}`, {
    statusCode: 404,
    code: 'ROUTE_NOT_FOUND',
  }));
}

export function errorMiddleware(error, _req, res, _next) {
  const isKnown = error instanceof AppError;
  const statusCode = isKnown ? error.statusCode : 500;

  if (!isKnown) {
    console.error(error);
  }

  res.status(statusCode).json({
    error: {
      code: isKnown ? error.code : 'INTERNAL_ERROR',
      message: isKnown ? error.message : 'Unexpected server error',
      ...(isKnown && error.details ? { details: error.details } : {}),
    },
  });
}
