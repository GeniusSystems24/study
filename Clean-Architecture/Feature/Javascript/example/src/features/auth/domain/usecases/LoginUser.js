import { AppError } from '../../../../core/errors/AppError.js';

export class LoginUser {
  constructor({ authRepository }) {
    this.authRepository = authRepository;
  }

  async execute({ email, password }) {
    const normalizedEmail = email.trim().toLowerCase();
    const result = await this.authRepository.login({
      email: normalizedEmail,
      password,
    });

    if (!result) {
      throw new AppError('Invalid email or password', {
        statusCode: 401,
        code: 'INVALID_CREDENTIALS',
      });
    }

    return result;
  }
}
