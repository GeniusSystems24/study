import { Email } from "../../domain/value-objects/Email.js";
import { ApplicationError } from "../errors/ApplicationError.js";
import { LoginResponse } from "../dto/LoginResponse.js";

export class LoginUseCase {
  constructor({ userRepository, passwordHasher, tokenService }) {
    this.userRepository = userRepository;
    this.passwordHasher = passwordHasher;
    this.tokenService = tokenService;
  }

  async execute(request) {
    const email = new Email(request.email);
    const user = await this.userRepository.findByEmail(email);

    if (!user) {
      throw new ApplicationError("INVALID_CREDENTIALS", "Invalid credentials.", 401);
    }

    user.assertCanLogin();

    const passwordMatches = await this.passwordHasher.verify(
      request.password,
      user.passwordHash
    );

    if (!passwordMatches) {
      throw new ApplicationError("INVALID_CREDENTIALS", "Invalid credentials.", 401);
    }

    const token = await this.tokenService.issue({
      sub: user.id,
      email: user.email.toString()
    });

    return new LoginResponse({
      token,
      user: user.toPublicObject()
    });
  }
}
