import { User } from "../domain/entities/User.js";
import { InMemoryUserRepository } from "../infrastructure/repositories/InMemoryUserRepository.js";
import { InMemoryOrderRepository } from "../infrastructure/repositories/InMemoryOrderRepository.js";
import { Sha256PasswordHasher } from "../infrastructure/security/Sha256PasswordHasher.js";
import { HmacTokenService } from "../infrastructure/security/HmacTokenService.js";
import { LoginUseCase } from "../application/usecases/LoginUseCase.js";
import { CreateOrderUseCase } from "../application/usecases/CreateOrderUseCase.js";
import { GetOrderUseCase } from "../application/usecases/GetOrderUseCase.js";
import { AuthController } from "../presentation/controllers/AuthController.js";
import { OrderController } from "../presentation/controllers/OrderController.js";

export async function createContainer() {
  const passwordHasher = new Sha256PasswordHasher();
  const userRepository = new InMemoryUserRepository([
    new User({
      id: "u-1",
      email: "anwar@example.com",
      name: "Anwar",
      passwordHash: await passwordHasher.hash("secret123")
    })
  ]);
  const orderRepository = new InMemoryOrderRepository();
  const tokenService = new HmacTokenService({
    secret: process.env.TOKEN_SECRET ?? "development-secret"
  });

  const loginUseCase = new LoginUseCase({
    userRepository,
    passwordHasher,
    tokenService
  });
  const createOrderUseCase = new CreateOrderUseCase({
    userRepository,
    orderRepository
  });
  const getOrderUseCase = new GetOrderUseCase({ orderRepository });

  return {
    repositories: { userRepository, orderRepository },
    services: { passwordHasher, tokenService },
    useCases: { loginUseCase, createOrderUseCase, getOrderUseCase },
    controllers: {
      authController: new AuthController({ loginUseCase }),
      orderController: new OrderController({
        createOrderUseCase,
        getOrderUseCase
      })
    }
  };
}
