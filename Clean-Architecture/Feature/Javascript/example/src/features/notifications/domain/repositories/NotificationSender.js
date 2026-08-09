export class NotificationSender {
  get channel() {
    throw new Error('NotificationSender.channel must be implemented');
  }

  async send(_request) {
    throw new Error('NotificationSender.send must be implemented');
  }
}
