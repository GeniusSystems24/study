export class InMemoryAuthDataSource {
  constructor() {
    this.users = [
      {
        id: 'user-1',
        name: 'Anwar Al-Sayari',
        email: 'anwar@example.com',
        password: 'password123',
      },
    ];
  }

  async findByCredentials({ email, password }) {
    return this.users.find(
      (user) => user.email === email && user.password === password,
    ) ?? null;
  }
}
