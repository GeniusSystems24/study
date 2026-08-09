import { NotificationSender } from '../../domain/repositories/NotificationSender.js';

export class SmsNotificationSender extends NotificationSender {
  get channel() { return 'sms'; }

  async send({ recipient, message }) {
    return {
      id: `sms-${Date.now()}`,
      channel: this.channel,
      recipient,
      message,
      status: 'sent',
    };
  }
}
