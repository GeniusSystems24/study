import test from "node:test";
import assert from "node:assert/strict";
import { Money } from "../../src/domain/value-objects/Money.js";

test("Money adds values with the same currency", () => {
  const total = new Money(10, "USD").add(new Money(5.5, "USD"));
  assert.deepEqual(total.toJSON(), { amount: 15.5, currency: "USD" });
});

test("Money rejects mismatched currencies", () => {
  assert.throws(
    () => new Money(10, "USD").add(new Money(10, "EUR")),
    /same currency/
  );
});
