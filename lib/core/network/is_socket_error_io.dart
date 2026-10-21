import 'dart:io';

/// VM / IO platform check for socket-level connection errors.
bool isSocketErrorImpl(Object error) {
  if (error is SocketException) return true;
  if (error is HttpException) {
    final msg = error.message.toLowerCase();
    return msg.contains('connection refused') ||
        msg.contains('network is unreachable') ||
        msg.contains('broken pipe');
  }
  return false;
}
