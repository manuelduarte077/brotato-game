import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pay_reminder/application/providers/firebase_providers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pay_reminder/application/providers/sync_provider.dart';

class AuthState {
  final bool isLoading;
  final User? user;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    User? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

// StateNotifier para manejar la autenticación
class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final Ref _ref;
  late StreamSubscription<User?> _authStateSubscription;

  AuthNotifier({
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
    required Ref ref,
  })  : _auth = auth,
        _googleSignIn = googleSignIn,
        _ref = ref,
        super(AuthState(user: auth.currentUser)) {
    _authStateSubscription = _auth.authStateChanges().listen((user) {
      state = state.copyWith(user: user);
    });
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  // Método para verificar si hay una sesión activa
  Future<void> checkAuthState() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await currentUser.reload();
      state = state.copyWith(user: _auth.currentUser);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw 'Sign in aborted by user';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      if (kIsWeb) {
        await _auth.setPersistence(Persistence.LOCAL);
      }

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await _ref.read(syncNotifierProvider.notifier).syncFromRemote();
      }

      print('Usuario autenticado: ${userCredential.user?.uid}');
      state = state.copyWith(
        isLoading: false,
        user: userCredential.user,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      print('Error al iniciar sesión con Google: $e');
    }
  }

  Future<void> signOut() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);

      state = state.copyWith(
        isLoading: false,
        user: null,
      );
      print('Sesión eliminada del almacenamiento local');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      print('Error al cerrar sesión: $e');
    }
  }
}

// Providers
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    auth: ref.watch(firebaseAuthProvider),
    googleSignIn: ref.watch(googleSignInProvider),
    ref: ref,
  );
});

final authInitializationProvider = FutureProvider<void>((ref) async {
  final authNotifier = ref.read(authStateProvider.notifier);
  await authNotifier.checkAuthState();
});
