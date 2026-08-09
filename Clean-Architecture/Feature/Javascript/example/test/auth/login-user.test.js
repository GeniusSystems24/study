import test from 'node:test';
import assert from 'node:assert/strict';
import { LoginUser } from '../../src/features/auth/domain/usecases/LoginUser.js';

class FakeAuthRepository {
  async login({ email, password }) {
    if (email === 'anwar@example.com' && password === 'password123') {
      return { user: { id: '1', email }, token: 'token' };
    }
    return null;
  }
}

test('LoginUser returns a user and token for valid credentials', async () => {
  const useCase = new LoginUser({ authRepository: new FakeAuthRepository() });
  const result = await useCase.execute({
    email: ' ANWAR@EXAMPLE.COM ',
    password: 'password123',
  });
  assert.equal(result.user.email, 'anwar@example.com');
  assert.equal(result.token, 'token');
});

test('LoginUser rejects invalid credentials', async () => {
  const useCase = new LoginUser({ authRepository: new FakeAuthRepository() });
  await assert.rejects(
    () => useCase.execute({ email: 'wrong@example.com', password: 'bad' }),
    (error) => error.code === 'INVALID_CREDENTIALS' && error.statusCode === 401,
  );
});
