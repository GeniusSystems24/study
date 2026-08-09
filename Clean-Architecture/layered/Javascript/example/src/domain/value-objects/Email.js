import { DomainError } from "../errors/DomainError.js";

const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export class Email {
  constructor(value) {
    const normalized = String(value ?? "").trim().toLowerCase();
    if (!EMAIL_PATTERN.test(normalized)) {
      throw new DomainError("INVALID_EMAIL", "A valid email address is required.");
    }
    this.value = normalized;
    Object.freeze(this);
  }

  equals(other) {
    return other instanceof Email && other.value === this.value;
  }

  toString() {
    return this.value;
  }
}
