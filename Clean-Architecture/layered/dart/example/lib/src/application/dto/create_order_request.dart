import '../errors/application_exception.dart';

final class CreateOrderItemRequest {
  const CreateOrderItemRequest({
    required this.productId,
    required this.name,
    required this.unitPrice,
    required this.quantity,
  });

  factory CreateOrderItemRequest.fromJson(Map<String, Object?> json) {
    return CreateOrderItemRequest(
      productId: json['productId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      unitPrice: (json['unitPrice'] as num?) ?? -1,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    );
  }

  final String productId;
  final String name;
  final num unitPrice;
  final int quantity;
}

final class CreateOrderRequest {
  CreateOrderRequest({
    required this.userId,
    required this.currency,
    required List<CreateOrderItemRequest> items,
  }) : items = List.unmodifiable(items) {
    if (userId.trim().isEmpty || currency.trim().isEmpty || items.isEmpty) {
      throw const ApplicationException(
        'INVALID_ORDER_REQUEST',
        'userId, currency, and at least one item are required.',
        status: 422,
      );
    }
  }

  factory CreateOrderRequest.fromJson(Map<String, Object?> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map>()
            .map((item) => CreateOrderItemRequest.fromJson(
                  item.map((key, value) => MapEntry(key.toString(), value)),
                ))
            .toList()
        : <CreateOrderItemRequest>[];

    return CreateOrderRequest(
      userId: json['userId']?.toString() ?? '',
      currency: json['currency']?.toString().toUpperCase() ?? '',
      items: items,
    );
  }

  final String userId;
  final String currency;
  final List<CreateOrderItemRequest> items;
}
