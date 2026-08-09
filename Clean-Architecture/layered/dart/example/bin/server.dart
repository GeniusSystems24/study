import 'dart:io';

import 'package:dart_layered_clean_architecture_example/src/composition/app_container.dart';
import 'package:dart_layered_clean_architecture_example/src/composition/create_http_handler.dart';

Future<void> main() async {
  final container = await AppContainer.create();
  final handler = createHttpHandler(container);
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

  stdout.writeln(
    'Dart Layered Clean Architecture example listening on '
    'http://${server.address.host}:${server.port}',
  );

  await for (final request in server) {
    await handler(request);
  }
}
