import 'dart:io';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthService {
  static final LocalAuthService _instance = LocalAuthService._internal();
  factory LocalAuthService() => _instance;
  LocalAuthService._internal();

  final LocalAuthentication _auth = LocalAuthentication();
  final String _biometricEnabledKey = 'biometric_enabled';

  Future<bool> isBiometricAvailable() async {
    try {
      if (!await _auth.canCheckBiometrics || !await _auth.isDeviceSupported()) {
        return false;
      }

      final biometrics = await getAvailableBiometrics();
      if (Platform.isIOS) {
        return biometrics.contains(BiometricType.face);
      } else {
        return biometrics.contains(BiometricType.fingerprint);
      }
    } on PlatformException catch (_) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      final biometrics = await _auth.getAvailableBiometrics();
      if (Platform.isAndroid) {
        return biometrics.where((b) => b == BiometricType.fingerprint).toList();
      }
      return biometrics;
    } on PlatformException catch (_) {
      return [];
    }
  }

  Future<bool> authenticate() async {
    if (!await isBiometricEnabled()) return true;
    if (!await isBiometricAvailable()) return false;

    try {
      final isIOS = Platform.isIOS;
      final reason = isIOS
          ? 'Authenticate with Face ID to access the app'
          : 'Authenticate with your fingerprint to access the app';

      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (_) {
      return false;
    }
  }

  Future<bool> isBiometricSupported() async {
    if (Platform.isIOS) {
      final biometrics = await getAvailableBiometrics();
      return biometrics.contains(BiometricType.face);
    } else {
      final biometrics = await getAvailableBiometrics();
      return biometrics.contains(BiometricType.fingerprint);
    }
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    if (enabled && !await isBiometricAvailable()) {
      throw PlatformException(
        code: 'NO_BIOMETRICS',
        message: Platform.isIOS
            ? 'Face ID is not available on this device'
            : 'Fingerprint authentication is not available on this device',
      );
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, enabled);
  }

  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_biometricEnabledKey) ?? false;
  }
}
