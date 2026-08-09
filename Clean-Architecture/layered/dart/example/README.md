# Dart Layered Clean Architecture Example

A small Dart HTTP API demonstrating:

- Presentation, Application, Domain, and Infrastructure/Data layers.
- SOLID principles and dependency inversion.
- Login, order creation, and order retrieval use cases.
- Dependency injection through a composition root.
- Unit tests.

## Requirements

- Dart SDK 3.3 or newer.

## Run

```bash
dart pub get
dart test
dart analyze
dart run bin/server.dart
```

The API listens on `http://localhost:8080`.

## Demo credentials

- Email: `anwar@example.com`
- Password: `secret123`
