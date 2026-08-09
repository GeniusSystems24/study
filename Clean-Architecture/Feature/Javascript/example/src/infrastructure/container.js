import { InMemoryAuthDataSource } from '../features/auth/data/datasources/InMemoryAuthDataSource.js';
import { AuthRepositoryImpl } from '../features/auth/data/repositories/AuthRepositoryImpl.js';
import { LoginUser } from '../features/auth/domain/usecases/LoginUser.js';
import { AuthController } from '../features/auth/presentation/controllers/AuthController.js';
import { EmailNotificationSender } from '../features/notifications/data/senders/EmailNotificationSender.js';
import { SmsNotificationSender } from '../features/notifications/data/senders/SmsNotificationSender.js';
import { PushNotificationSender } from '../features/notifications/data/senders/PushNotificationSender.js';
import { NotificationGatewayImpl } from '../features/notifications/data/repositories/NotificationGatewayImpl.js';
import { SendNotification } from '../features/notifications/domain/usecases/SendNotification.js';
import { NotificationController } from '../features/notifications/presentation/controllers/NotificationController.js';

export function createContainer() {
  const authDataSource = new InMemoryAuthDataSource();
  const authRepository = new AuthRepositoryImpl({ authDataSource });
  const loginUser = new LoginUser({ authRepository });
  const authController = new AuthController({ loginUser });

  const senders = [
    new EmailNotificationSender(),
    new SmsNotificationSender(),
    new PushNotificationSender(),
  ];
  const notificationGateway = new NotificationGatewayImpl({ senders });
  const sendNotification = new SendNotification({ notificationGateway });
  const notificationController = new NotificationController({ sendNotification });

  return Object.freeze({ authController, notificationController });
}
