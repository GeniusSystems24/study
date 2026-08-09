import test from 'node:test';
import assert from 'node:assert/strict';
import { SendNotification } from '../../src/features/notifications/domain/usecases/SendNotification.js';

class FakeNotificationGateway {
  requests = [];
  async send(request) {
    this.requests.push(request);
    return { ...request, id: 'n-1', status: 'sent' };
  }
}

test('SendNotification delegates normalized data to the gateway', async () => {
  const gateway = new FakeNotificationGateway();
  const useCase = new SendNotification({ notificationGateway: gateway });
  const result = await useCase.execute({
    channel: ' EMAIL ',
    recipient: ' student@example.com ',
    message: ' Welcome ',
  });
  assert.equal(result.channel, 'email');
  assert.equal(result.recipient, 'student@example.com');
  assert.equal(result.message, 'Welcome');
  assert.equal(gateway.requests.length, 1);
});
