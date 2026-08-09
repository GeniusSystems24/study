import 'dart:io';

typedef RouteHandler = Future<void> Function(
  HttpRequest request,
  Map<String, String> params,
);

final class _Route {
  const _Route({
    required this.method,
    required this.pattern,
    required this.handler,
  });

  final String method;
  final String pattern;
  final RouteHandler handler;
}

final class Router {
  final List<_Route> _routes = [];

  void register(String method, String pattern, RouteHandler handler) {
    _routes.add(_Route(
      method: method.toUpperCase(),
      pattern: pattern,
      handler: handler,
    ));
  }

  ({RouteHandler handler, Map<String, String> params})? match(
    String method,
    String path,
  ) {
    final requestSegments = Uri(path: path).pathSegments;

    for (final route in _routes) {
      if (route.method != method.toUpperCase()) continue;
      final patternSegments = Uri(path: route.pattern).pathSegments;
      if (patternSegments.length != requestSegments.length) continue;

      final params = <String, String>{};
      var matches = true;
      for (var index = 0; index < patternSegments.length; index++) {
        final expected = patternSegments[index];
        final actual = requestSegments[index];
        if (expected.startsWith(':')) {
          params[expected.substring(1)] = actual;
        } else if (expected != actual) {
          matches = false;
          break;
        }
      }
      if (matches) return (handler: route.handler, params: params);
    }
    return null;
  }
}
