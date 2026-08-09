import { NotificationSender } from '../../domain/repositories/NotificationSender.js';

export class EmailNotificationSender extends NotificationSender {
  get channel() { return 'email'; }

  async send({ recipient, message }) {
    return {
      id: `email-${Date.now()}`,
      channel: this.channel,
      recipient,
      message,
      status: 'sent',
    };
  }
}
