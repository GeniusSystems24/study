export class TokenService {
  async issue(_claims) {
    throw new Error("TokenService.issue must be implemented.");
  }
}
