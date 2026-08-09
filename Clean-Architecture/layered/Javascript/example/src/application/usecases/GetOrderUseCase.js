import { ApplicationError } from "../errors/ApplicationError.js";

export class GetOrderUseCase {
  constructor({ orderRepository }) {
    this.orderRepository = orderRepository;
  }

  async execute({ id }) {
    const order = await this.orderRepository.findById(String(id));
    if (!order) {
      throw new ApplicationError("ORDER_NOT_FOUND", "Order was not found.", 404);
    }
    return order.toJSON();
  }
}
