//home/hp/JERE/pension-frontend/lib/core/utils/web_auth_stub.dart
// Stub for web platform where local_auth is not available
class LocalAuthentication {
  Future<bool> canCheckBiometrics() async => false;
  Future<bool> isDeviceSupported() async => false;
  Future<bool> authenticate({
    required String localizedReason,
    AuthenticationOptions? options,
  }) async => false;
}

class AuthenticationOptions {
  final bool stickyAuth;
  final bool biometricOnly;
  
  const AuthenticationOptions({
    this.stickyAuth = false,
    this.biometricOnly = false,
  });
}