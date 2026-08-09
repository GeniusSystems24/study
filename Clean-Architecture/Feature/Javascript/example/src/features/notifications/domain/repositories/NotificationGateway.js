export class NotificationGateway {
  async send(_request) {
    throw new Error('NotificationGateway.send must be implemented');
  }
}
