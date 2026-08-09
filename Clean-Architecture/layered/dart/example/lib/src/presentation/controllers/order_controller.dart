import 'dart:io';

import '../../application/dto/create_order_request.dart';
import '../../application/usecases/create_order_use_case.dart';
import '../../application/usecases/get_order_use_case.dart';
import '../http/json_io.dart';

final class OrderController {
  const OrderController({
    required this.createOrderUseCase,
    required this.getOrderUseCase,
  });

  final CreateOrderUseCase createOrderUseCase;
  final GetOrderUseCase getOrderUseCase;

  Future<void> create(
    HttpRequest request,
    Map<String, String> _params,
  ) async {
    final body = await readJsonBody(request);
    final result = await createOrderUseCase.execute(
      CreateOrderRequest.fromJson(body),
    );
    await sendJson(request.response, HttpStatus.created, result);
  }

  Future<void> getById(
    HttpRequest request,
    Map<String, String> params,
  ) async {
    final result = await getOrderUseCase.execute(params['id'] ?? '');
    await sendJson(request.response, HttpStatus.ok, result);
  }
}
