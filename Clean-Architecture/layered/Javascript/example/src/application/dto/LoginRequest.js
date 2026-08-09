import { ApplicationError } from "../errors/ApplicationError.js";

export class LoginRequest {
  constructor({ email, password }) {
    if (!email || !password) {
      throw new ApplicationError(
        "INVALID_LOGIN_REQUEST",
        "Email and password are required.",
        422
      );
    }
    this.email = String(email).trim().toLowerCase();
    this.password = String(password);
    Object.freeze(this);
  }
}
