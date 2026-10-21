import 'package:injectable/injectable.dart';

abstract interface class TokenProvider {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<bool> hasValidToken();
}

@LazySingleton(as: TokenProvider)
class NoOpTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> getRefreshToken() async => null;

  @override
  Future<bool> hasValidToken() async => false;
}
