import { AppError } from '../../../../core/errors/AppError.js';

export class SendNotification {
  constructor({ notificationGateway }) {
    this.notificationGateway = notificationGateway;
  }

  async execute({ channel, recipient, message }) {
    const normalizedChannel = channel.trim().toLowerCase();
    if (message.trim().length < 3) {
      throw new AppError('Message must contain at least 3 characters', {
        statusCode: 400,
        code: 'MESSAGE_TOO_SHORT',
      });
    }

    return this.notificationGateway.send({
      channel: normalizedChannel,
      recipient: recipient.trim(),
      message: message.trim(),
    });
  }
}
