import 'package:flutter_starter/core/network/token_provider.dart';
import 'package:flutter_starter/core/storage/secure_storage_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TokenProvider)
class AuthTokenProvider implements TokenProvider {
  final SecureStorageService _storage;

  AuthTokenProvider(this._storage);

  @override
  Future<String?> getAccessToken() => _storage.getAccessToken();

  @override
  Future<String?> getRefreshToken() => _storage.getRefreshToken();

  @override
  Future<bool> hasValidToken() => _storage.hasTokens();
}
