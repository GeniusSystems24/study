import { UserRepository } from "../../domain/repositories/UserRepository.js";

export class InMemoryUserRepository extends UserRepository {
  constructor(initialUsers = []) {
    super();
    this.users = new Map(initialUsers.map((user) => [user.id, user]));
  }

  async findByEmail(email) {
    for (const user of this.users.values()) {
      if (user.email.equals(email)) {
        return user;
      }
    }
    return null;
  }

  async findById(id) {
    return this.users.get(String(id)) ?? null;
  }
}
