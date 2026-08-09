export class PasswordHasher {
  async hash(_plainText) {
    throw new Error("PasswordHasher.hash must be implemented.");
  }

  async verify(_plainText, _hash) {
    throw new Error("PasswordHasher.verify must be implemented.");
  }
}
