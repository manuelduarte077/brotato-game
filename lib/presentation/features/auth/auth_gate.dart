import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io' show Platform;

import '../../../infrastructure/services/local_auth_service.dart';

class AuthGate extends ConsumerStatefulWidget {
  final Widget child;

  const AuthGate({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate>
    with WidgetsBindingObserver {
  bool _authenticated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _authenticate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_authenticated) {
      _authenticate();
    }
  }

  Future<void> _authenticate() async {
    final localAuth = LocalAuthService();

    if (!await localAuth.isBiometricEnabled()) {
      setState(() => _authenticated = true);
      return;
    }

    final authenticated = await localAuth.authenticate();
    setState(() => _authenticated = authenticated);
  }

  @override
  Widget build(BuildContext context) {
    if (!_authenticated) {
      final isIOS = Platform.isIOS;

      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isIOS ? Icons.face_outlined : Icons.fingerprint,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                isIOS ? 'Face ID Required' : 'Touch ID Required',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isIOS
                    ? 'Please authenticate with Face ID to continue'
                    : 'Please authenticate with Touch ID to continue',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (isIOS)
                CupertinoButton.filled(
                  onPressed: _authenticate,
                  child: const Text('Authenticate with Face ID'),
                )
              else
                FilledButton.icon(
                  onPressed: _authenticate,
                  icon: isIOS
                      ? const Icon(Icons.face_outlined)
                      : const Icon(Icons.fingerprint),
                  label: const Text('Authenticate'),
                ),
            ],
          ),
        ),
      );
    }

    return widget.child;
  }
}
