import '../../../../core/network/api_client.dart';
import '../../domain/entities/notification_request.dart';

abstract interface class NotificationRemoteDataSource {
  Future<SentNotification> send(NotificationRequest request);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  const NotificationRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<SentNotification> send(NotificationRequest request) async {
    final json = await _apiClient.post('/api/notifications/send', {
      'channel': request.channel,
      'recipient': request.recipient,
      'message': request.message,
    });
    final data = json['data'] as Map<String, dynamic>;
    return SentNotification(
      id: data['id'] as String,
      channel: data['channel'] as String,
      status: data['status'] as String,
    );
  }
}
