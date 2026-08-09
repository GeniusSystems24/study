import { NotificationSender } from '../../domain/repositories/NotificationSender.js';

export class PushNotificationSender extends NotificationSender {
  get channel() { return 'push'; }

  async send({ recipient, message }) {
    return {
      id: `push-${Date.now()}`,
      channel: this.channel,
      recipient,
      message,
      status: 'sent',
    };
  }
}
