export class AuthRepository {
  async login(_credentials) {
    throw new Error('AuthRepository.login must be implemented');
  }
}
