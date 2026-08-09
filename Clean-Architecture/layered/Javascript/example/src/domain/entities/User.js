import { DomainError } from "../errors/DomainError.js";
import { Email } from "../value-objects/Email.js";

export class User {
  constructor({ id, email, name, passwordHash, active = true }) {
    if (!id || !name || !passwordHash) {
      throw new DomainError("INVALID_USER", "User id, name, and password hash are required.");
    }
    this.id = String(id);
    this.email = email instanceof Email ? email : new Email(email);
    this.name = String(name).trim();
    this.passwordHash = String(passwordHash);
    this.active = Boolean(active);
  }

  deactivate() {
    this.active = false;
  }

  assertCanLogin() {
    if (!this.active) {
      throw new DomainError("USER_INACTIVE", "Inactive users cannot sign in.");
    }
  }

  toPublicObject() {
    return {
      id: this.id,
      email: this.email.toString(),
      name: this.name,
      active: this.active
    };
  }
}
