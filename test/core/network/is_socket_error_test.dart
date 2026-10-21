import 'dart:io';
import 'package:flutter_starter/core/network/is_socket_error.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isSocketError', () {
    test('identifies SocketException as socket error', () {
      expect(isSocketError(const SocketException('failed')), isTrue);
    });

    test('identifies HandshakeException as socket error', () {
      expect(
        isSocketError(
          const HandshakeException('Connection terminated during handshake'),
        ),
        isTrue,
      );
    });

    test('identifies TlsException as socket error', () {
      expect(isSocketError(const TlsException('TLS error')), isTrue);
    });

    test('identifies CertificateException as socket error', () {
      expect(isSocketError(const CertificateException('Cert error')), isTrue);
    });

    test('identifies connection closed HttpException as socket error', () {
      expect(
        isSocketError(
          const HttpException(
            'Connection closed before full header was received',
          ),
        ),
        isTrue,
      );
    });

    test('returns false for generic FormatException', () {
      expect(isSocketError(const FormatException('bad format')), isFalse);
    });
  });
}
