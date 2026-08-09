import test from "node:test";
import assert from "node:assert/strict";
import { User } from "../../src/domain/entities/User.js";
import { InMemoryUserRepository } from "../../src/infrastructure/repositories/InMemoryUserRepository.js";
import { Sha256PasswordHasher } from "../../src/infrastructure/security/Sha256PasswordHasher.js";
import { LoginUseCase } from "../../src/application/usecases/LoginUseCase.js";
import { LoginRequest } from "../../src/application/dto/LoginRequest.js";

test("LoginUseCase returns a token and public user data", async () => {
  const passwordHasher = new Sha256PasswordHasher();
  const user = new User({
    id: "u-1",
    email: "anwar@example.com",
    name: "Anwar",
    passwordHash: await passwordHasher.hash("secret123")
  });
  const userRepository = new InMemoryUserRepository([user]);
  const tokenService = { issue: async () => "token-1" };
  const useCase = new LoginUseCase({ userRepository, passwordHasher, tokenService });

  const result = await useCase.execute(
    new LoginRequest({ email: "anwar@example.com", password: "secret123" })
  );

  assert.equal(result.token, "token-1");
  assert.equal(result.user.email, "anwar@example.com");
  assert.equal(result.user.passwordHash, undefined);
});

test("LoginUseCase rejects an invalid password", async () => {
  const passwordHasher = new Sha256PasswordHasher();
  const user = new User({
    id: "u-1",
    email: "anwar@example.com",
    name: "Anwar",
    passwordHash: await passwordHasher.hash("secret123")
  });
  const useCase = new LoginUseCase({
    userRepository: new InMemoryUserRepository([user]),
    passwordHasher,
    tokenService: { issue: async () => "unused" }
  });

  await assert.rejects(
    () =>
      useCase.execute(
        new LoginRequest({ email: "anwar@example.com", password: "wrong" })
      ),
    (error) => error.code === "INVALID_CREDENTIALS"
  );
});
