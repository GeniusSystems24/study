import { DomainError } from "../errors/DomainError.js";

export class Money {
  constructor(amount, currency) {
    if (!Number.isFinite(amount) || amount < 0) {
      throw new DomainError("INVALID_MONEY", "Money amount must be a non-negative number.");
    }
    const normalizedCurrency = String(currency ?? "").trim().toUpperCase();
    if (!/^[A-Z]{3}$/.test(normalizedCurrency)) {
      throw new DomainError("INVALID_CURRENCY", "Currency must be a three-letter ISO-like code.");
    }
    this.amount = Number(amount.toFixed(2));
    this.currency = normalizedCurrency;
    Object.freeze(this);
  }

  add(other) {
    this.#assertSameCurrency(other);
    return new Money(this.amount + other.amount, this.currency);
  }

  multiply(multiplier) {
    if (!Number.isInteger(multiplier) || multiplier < 0) {
      throw new DomainError("INVALID_MULTIPLIER", "Multiplier must be a non-negative integer.");
    }
    return new Money(this.amount * multiplier, this.currency);
  }

  #assertSameCurrency(other) {
    if (!(other instanceof Money) || other.currency !== this.currency) {
      throw new DomainError("CURRENCY_MISMATCH", "Money values must use the same currency.");
    }
  }

  toJSON() {
    return { amount: this.amount, currency: this.currency };
  }
}
