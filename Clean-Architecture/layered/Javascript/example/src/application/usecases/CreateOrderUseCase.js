import { Order, OrderItem } from "../../domain/entities/Order.js";
import { ApplicationError } from "../errors/ApplicationError.js";

export class CreateOrderUseCase {
  constructor({ userRepository, orderRepository, clock = () => new Date() }) {
    this.userRepository = userRepository;
    this.orderRepository = orderRepository;
    this.clock = clock;
  }

  async execute(request) {
    const user = await this.userRepository.findById(request.userId);
    if (!user) {
      throw new ApplicationError("USER_NOT_FOUND", "User was not found.", 404);
    }
    user.assertCanLogin();

    const items = request.items.map(
      (item) =>
        new OrderItem({
          productId: item.productId,
          name: item.name,
          unitPrice: item.unitPrice,
          quantity: item.quantity,
          currency: request.currency
        })
    );

    const order = new Order({
      id: await this.orderRepository.nextIdentity(),
      userId: user.id,
      items,
      createdAt: this.clock()
    });

    await this.orderRepository.save(order);
    return order.toJSON();
  }
}
