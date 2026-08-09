import test from "node:test";
import assert from "node:assert/strict";
import { User } from "../../src/domain/entities/User.js";
import { InMemoryUserRepository } from "../../src/infrastructure/repositories/InMemoryUserRepository.js";
import { InMemoryOrderRepository } from "../../src/infrastructure/repositories/InMemoryOrderRepository.js";
import { CreateOrderUseCase } from "../../src/application/usecases/CreateOrderUseCase.js";
import { CreateOrderRequest } from "../../src/application/dto/CreateOrderRequest.js";

test("CreateOrderUseCase creates and persists an order", async () => {
  const userRepository = new InMemoryUserRepository([
    new User({
      id: "u-1",
      email: "anwar@example.com",
      name: "Anwar",
      passwordHash: "hash"
    })
  ]);
  const orderRepository = new InMemoryOrderRepository();
  const useCase = new CreateOrderUseCase({
    userRepository,
    orderRepository,
    clock: () => new Date("2026-01-01T00:00:00.000Z")
  });

  const order = await useCase.execute(
    new CreateOrderRequest({
      userId: "u-1",
      currency: "USD",
      items: [
        { productId: "p-1", name: "Keyboard", unitPrice: 80, quantity: 2 }
      ]
    })
  );

  assert.equal(order.total.amount, 160);
  assert.equal(order.status, "CREATED");
  assert.deepEqual(await orderRepository.findById(order.id).then((x) => x.toJSON()), order);
});
