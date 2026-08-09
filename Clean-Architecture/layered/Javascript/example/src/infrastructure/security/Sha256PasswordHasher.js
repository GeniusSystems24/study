import { createHash, timingSafeEqual } from "node:crypto";
import { PasswordHasher } from "../../application/ports/PasswordHasher.js";

export class Sha256PasswordHasher extends PasswordHasher {
  async hash(plainText) {
    return createHash("sha256").update(String(plainText)).digest("hex");
  }

  async verify(plainText, expectedHash) {
    const actualHash = await this.hash(plainText);
    const actual = Buffer.from(actualHash, "utf8");
    const expected = Buffer.from(String(expectedHash), "utf8");
    return actual.length === expected.length && timingSafeEqual(actual, expected);
  }
}
