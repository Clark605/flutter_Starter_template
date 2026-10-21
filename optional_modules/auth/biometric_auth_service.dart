// Requires adding `local_auth: ^2.3.0` to pubspec.yaml
// Uncomment and import when local_auth is installed:
// import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  // final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isBiometricsAvailable() async {
    // try {
    //   final canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    //   final isDeviceSupported = await _auth.isDeviceSupported();
    //   return canAuthenticateWithBiometrics || isDeviceSupported;
    // } catch (_) {
    //   return false;
    // }
    return false;
  }

  Future<bool> authenticate({
    String reason = 'Please authenticate to continue',
  }) async {
    // try {
    //   return await _auth.authenticate(
    //     localizedReason: reason,
    //     options: const AuthenticationOptions(
    //       stickyAuth: true,
    //       biometricOnly: true,
    //     ),
    //   );
    // } catch (_) {
    //   return false;
    // }
    return false;
  }
}
