import { validateRequired } from '../../../../core/validation/validateRequired.js';

export class NotificationController {
  constructor({ sendNotification }) {
    this.sendNotification = sendNotification;
  }

  send = async (req, res) => {
    validateRequired(req.body, ['channel', 'recipient', 'message']);
    const notification = await this.sendNotification.execute(req.body);
    res.status(201).json({ data: notification });
  };
}
