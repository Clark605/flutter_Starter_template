import 'dart:io';

/// VM / IO platform check for socket-level connection errors.
bool isSocketErrorImpl(Object error) {
  if (error is SocketException ||
      error is HandshakeException ||
      error is TlsException ||
      error is CertificateException) {
    return true;
  }
  if (error is HttpException) {
    final msg = error.message.toLowerCase();
    return msg.contains('connection refused') ||
        msg.contains('network is unreachable') ||
        msg.contains('broken pipe') ||
        msg.contains('connection closed');
  }
  return false;
}
