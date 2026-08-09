import { User } from '../../domain/entities/User.js';
import { AuthRepository } from '../../domain/repositories/AuthRepository.js';

export class AuthRepositoryImpl extends AuthRepository {
  constructor({ authDataSource }) {
    super();
    this.authDataSource = authDataSource;
  }

  async login(credentials) {
    const record = await this.authDataSource.findByCredentials(credentials);
    if (!record) return null;

    return {
      user: new User(record),
      token: `demo-token-${record.id}`,
    };
  }
}
