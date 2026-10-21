import 'package:flutter_starter/core/network/is_socket_error_stub.dart'
    if (dart.library.io) 'package:flutter_starter/core/network/is_socket_error_io.dart';

/// Platform-agnostic check if an error is a network socket failure.
bool isSocketError(Object error) => isSocketErrorImpl(error);
