export class UserRepository {
  async findByEmail(_email) {
    throw new Error("UserRepository.findByEmail must be implemented.");
  }

  async findById(_id) {
    throw new Error("UserRepository.findById must be implemented.");
  }
}
