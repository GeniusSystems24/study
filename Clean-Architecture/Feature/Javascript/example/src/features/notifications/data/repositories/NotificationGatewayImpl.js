import { AppError } from '../../../../core/errors/AppError.js';
import { NotificationGateway } from '../../domain/repositories/NotificationGateway.js';

export class NotificationGatewayImpl extends NotificationGateway {
  constructor({ senders }) {
    super();
    this.senders = new Map(senders.map((sender) => [sender.channel, sender]));
  }

  async send(request) {
    const sender = this.senders.get(request.channel);
    if (!sender) {
      throw new AppError(`Unsupported notification channel: ${request.channel}`, {
        statusCode: 400,
        code: 'UNSUPPORTED_CHANNEL',
        details: { supported: [...this.senders.keys()] },
      });
    }
    return sender.send(request);
  }
}
