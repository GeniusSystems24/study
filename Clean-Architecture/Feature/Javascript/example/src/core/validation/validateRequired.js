import { AppError } from '../errors/AppError.js';

export function validateRequired(input, fields) {
  const missing = fields.filter((field) => {
    const value = input?.[field];
    return value === undefined || value === null || String(value).trim() === '';
  });

  if (missing.length > 0) {
    throw new AppError('Validation failed', {
      statusCode: 400,
      code: 'VALIDATION_ERROR',
      details: { missing },
    });
  }
}
