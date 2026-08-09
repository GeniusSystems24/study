import { DomainError } from "../errors/DomainError.js";
import { Money } from "../value-objects/Money.js";

export class OrderItem {
  constructor({ productId, name, unitPrice, quantity, currency }) {
    if (!productId || !name) {
      throw new DomainError("INVALID_ORDER_ITEM", "Product id and name are required.");
    }
    if (!Number.isInteger(quantity) || quantity <= 0) {
      throw new DomainError("INVALID_QUANTITY", "Quantity must be a positive integer.");
    }
    this.productId = String(productId);
    this.name = String(name).trim();
    this.unitPrice = unitPrice instanceof Money ? unitPrice : new Money(unitPrice, currency);
    this.quantity = quantity;
    Object.freeze(this);
  }

  subtotal() {
    return this.unitPrice.multiply(this.quantity);
  }

  toJSON() {
    return {
      productId: this.productId,
      name: this.name,
      unitPrice: this.unitPrice.toJSON(),
      quantity: this.quantity,
      subtotal: this.subtotal().toJSON()
    };
  }
}

export class Order {
  constructor({ id, userId, items, status = "CREATED", createdAt = new Date() }) {
    if (!id || !userId) {
      throw new DomainError("INVALID_ORDER", "Order id and user id are required.");
    }
    if (!Array.isArray(items) || items.length === 0) {
      throw new DomainError("EMPTY_ORDER", "An order must contain at least one item.");
    }
    this.id = String(id);
    this.userId = String(userId);
    this.items = [...items];
    this.status = status;
    this.createdAt = new Date(createdAt);
  }

  total() {
    const [first, ...rest] = this.items;
    return rest.reduce((sum, item) => sum.add(item.subtotal()), first.subtotal());
  }

  confirm() {
    if (this.status !== "CREATED") {
      throw new DomainError("INVALID_ORDER_STATE", "Only created orders can be confirmed.");
    }
    this.status = "CONFIRMED";
  }

  toJSON() {
    return {
      id: this.id,
      userId: this.userId,
      items: this.items.map((item) => item.toJSON()),
      total: this.total().toJSON(),
      status: this.status,
      createdAt: this.createdAt.toISOString()
    };
  }
}
