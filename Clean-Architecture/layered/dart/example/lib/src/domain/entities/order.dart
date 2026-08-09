import '../errors/domain_exception.dart';
import '../value_objects/money.dart';

final class OrderItem {
  OrderItem({
    required this.productId,
    required this.name,
    required Money unitPrice,
    required this.quantity,
  }) : unitPrice = unitPrice {
    if (productId.trim().isEmpty || name.trim().isEmpty) {
      throw const DomainException(
        'INVALID_ORDER_ITEM',
        'Product id and name are required.',
      );
    }
    if (quantity <= 0) {
      throw const DomainException(
        'INVALID_QUANTITY',
        'Quantity must be a positive integer.',
      );
    }
  }

  final String productId;
  final String name;
  final Money unitPrice;
  final int quantity;

  Money subtotal() => unitPrice.multiply(quantity);

  Map<String, Object> toJson() => {
        'productId': productId,
        'name': name,
        'unitPrice': unitPrice.toJson(),
        'quantity': quantity,
        'subtotal': subtotal().toJson(),
      };
}

final class Order {
  Order({
    required this.id,
    required this.userId,
    required List<OrderItem> items,
    this.status = 'CREATED',
    DateTime? createdAt,
  })  : items = List.unmodifiable(items),
        createdAt = createdAt ?? DateTime.now().toUtc() {
    if (id.trim().isEmpty || userId.trim().isEmpty) {
      throw const DomainException(
        'INVALID_ORDER',
        'Order id and user id are required.',
      );
    }
    if (items.isEmpty) {
      throw const DomainException(
        'EMPTY_ORDER',
        'An order must contain at least one item.',
      );
    }
  }

  final String id;
  final String userId;
  final List<OrderItem> items;
  String status;
  final DateTime createdAt;

  Money total() {
    final first = items.first.subtotal();
    return items.skip(1).fold(first, (sum, item) => sum.add(item.subtotal()));
  }

  void confirm() {
    if (status != 'CREATED') {
      throw const DomainException(
        'INVALID_ORDER_STATE',
        'Only created orders can be confirmed.',
      );
    }
    status = 'CONFIRMED';
  }

  Map<String, Object> toJson() => {
        'id': id,
        'userId': userId,
        'items': items.map((item) => item.toJson()).toList(),
        'total': total().toJson(),
        'status': status,
        'createdAt': createdAt.toIso8601String(),
      };
}
