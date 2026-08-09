import { ApplicationError } from "../errors/ApplicationError.js";

export class CreateOrderRequest {
  constructor({ userId, currency, items }) {
    if (!userId || !currency || !Array.isArray(items) || items.length === 0) {
      throw new ApplicationError(
        "INVALID_ORDER_REQUEST",
        "userId, currency, and at least one item are required.",
        422
      );
    }
    this.userId = String(userId);
    this.currency = String(currency).toUpperCase();
    this.items = items.map((item) => ({ ...item }));
    Object.freeze(this);
  }
}
