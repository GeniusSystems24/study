import { OrderRepository } from "../../domain/repositories/OrderRepository.js";

export class InMemoryOrderRepository extends OrderRepository {
  constructor(initialOrders = []) {
    super();
    this.orders = new Map(initialOrders.map((order) => [order.id, order]));
    this.sequence = initialOrders.length;
  }

  async nextIdentity() {
    this.sequence += 1;
    return `o-${this.sequence}`;
  }

  async save(order) {
    this.orders.set(order.id, order);
  }

  async findById(id) {
    return this.orders.get(String(id)) ?? null;
  }
}
