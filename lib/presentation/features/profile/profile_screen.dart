import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay_reminder/i18n/translations.g.dart';

import '../../../application/providers/auth_providers.dart';
import '../../../application/providers/sync_provider.dart';
import '../../../application/providers/language_provider.dart';
import 'package:intl/intl.dart';

import '../notifications/notifications_screen.dart';
import 'report_screen.dart';
import '../../../application/providers/local_auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    // final isDarkModeAsync = ref.watch(themeProvider); // disabled for now
    final currentLanguage = ref.watch(languageProvider);
    final profile = context.texts.app.profile;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(
            profile.perfil,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          floating: true,
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              SizedBox(height: 10),
              if (authState.isLoading)
                const Center(child: CircularProgressIndicator.adaptive()),
              if (authState.error != null)
                Text(
                  authState.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              if (!authState.isLoading)
                authState.user == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: FilledButton(
                          onPressed: () {
                            ref
                                .read(authStateProvider.notifier)
                                .signInWithGoogle();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.login),
                              SizedBox(width: 8),
                              Text(profile.signInWithGoogle),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                authState.user?.photoURL ??
                                    'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
                              ),
                            ),
                            title: Text(authState.user?.displayName ?? ''),
                            subtitle: Text(authState.user?.email ?? ''),
                          ),
                        ],
                      ),
              const SizedBox(height: 32),

              /// Theme Toggle (disabled for now)
              // ListTile(
              //   leading: const Icon(Icons.brightness_6_outlined),
              //   title: Text(profile.darkMode),
              //   trailing: Switch(
              //     value: isDarkModeAsync.valueOrNull ?? false,
              //     onChanged: (value) {
              //       ref.read(themeProvider.notifier).toggleTheme();
              //     },
              //   ),
              // ),

              // Language Selection
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: Text(
                  profile.language,
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Text(
                  currentLanguage == 'en' ? profile.english : profile.spanish,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                onTap: () =>
                    _showLanguageSelector(context, ref, currentLanguage),
              ),

              /// Habilitar Face ID (iOS), Touch ID (Android)
              if (Theme.of(context).platform == TargetPlatform.iOS ||
                  Theme.of(context).platform == TargetPlatform.android)
                const BiometricSettingTile(),

              /// Report
              ListTile(
                leading: const Icon(Icons.bar_chart_outlined),
                title: Text(
                  profile.report,
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportScreen(),
                    ),
                  );
                },
              ),

              /// Sync
              if (authState.user != null)
                ListTile(
                  leading: const Icon(Icons.sync_outlined),
                  title: Text(
                    profile.sync,
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(_getSyncStatusText(ref, context)),
                  trailing: _buildSyncIndicator(ref),
                  onTap: () {
                    ref.read(syncNotifierProvider.notifier).syncFromRemote();
                  },
                ),

              // Notifications Settings
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: Text(
                  profile.notifications,
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsScreen(),
                    ),
                  );
                },
              ),

              /// Cerrar sesión
              if (authState.user != null)
                ListTile(
                  leading: const Icon(Icons.logout_outlined),
                  title: Text(
                    profile.logout,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    ref.read(authStateProvider.notifier).signOut();
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _getSyncStatusText(WidgetRef ref, context) {
    final syncState = ref.watch(syncNotifierProvider);
    final profile = context.texts.profile;

    if (syncState.lastSyncTime != null) {
      final formatter = DateFormat('dd/MM/yyyy HH:mm');
      return '${profile.lastSync}: ${formatter.format(syncState.lastSyncTime!)}';
    }
    return syncState.message ?? profile.noSync;
  }

  Widget _buildSyncIndicator(WidgetRef ref) {
    final syncState = ref.watch(syncNotifierProvider);
    switch (syncState.status) {
      case SyncStatus.syncing:
        return const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case SyncStatus.success:
        return const Icon(Icons.check_circle, color: Colors.green);
      case SyncStatus.error:
        return const Icon(Icons.error, color: Colors.red);
      default:
        return const Icon(Icons.sync);
    }
  }

  void _showLanguageSelector(
      BuildContext context, WidgetRef ref, String currentLanguage) {
    final profile = context.texts.app.profile;

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: Text(profile.language),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                ref.read(languageProvider.notifier).updateLanguage('en');
                Navigator.pop(context);
              },
              isDefaultAction: currentLanguage == 'en',
              child: Text(profile.english),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                ref.read(languageProvider.notifier).updateLanguage('es');
                Navigator.pop(context);
              },
              isDefaultAction: currentLanguage == 'es',
              child: Text(profile.spanish),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: Text(profile.cancel),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(profile.english),
              leading: const Text('🇺🇸'),
              trailing: currentLanguage == 'en'
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                ref.read(languageProvider.notifier).updateLanguage('en');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(profile.spanish),
              leading: const Text('🇪🇸'),
              trailing: currentLanguage == 'es'
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                ref.read(languageProvider.notifier).updateLanguage('es');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }
}

class BiometricSettingTile extends ConsumerWidget {
  const BiometricSettingTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isIOS = Platform.isIOS;
    final biometricEnabled = ref.watch(biometricEnabledProvider);
    final profile = context.texts.app.profile;

    return ListTile(
      leading: Icon(
        isIOS ? Icons.face_outlined : Icons.fingerprint,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(isIOS ? profile.faceId : profile.fingerprint),
      subtitle: Text(
        isIOS
            ? profile.enableFaceIdAuthentication
            : profile.enableFingerprintAuthentication,
      ),
      trailing: Switch(
        value: biometricEnabled.valueOrNull ?? false,
        onChanged: (value) => _handleBiometricToggle(context, ref, value),
      ),
    );
  }

  Future<void> _handleBiometricToggle(
    BuildContext context,
    WidgetRef ref,
    bool value,
  ) async {
    final profile = context.texts.app.profile;

    try {
      if (value) {
        final canCheckBiometrics =
            await ref.read(localAuthServiceProvider).isBiometricAvailable();

        if (!canCheckBiometrics) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  Platform.isIOS
                      ? profile.faceIdNotAvailable
                      : profile.fingerprintNotAvailable,
                ),
              ),
            );
          }
          return;
        }
      }

      await ref.read(biometricEnabledProvider.notifier).toggleBiometric(value);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }
}
