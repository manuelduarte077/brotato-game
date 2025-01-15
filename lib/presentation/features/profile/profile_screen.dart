import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';

import '../../../application/providers/auth_providers.dart';
import '../../../application/providers/sync_provider.dart';
import '../../../application/providers/theme_provider.dart';
import '../../../application/providers/language_provider.dart';
import 'package:intl/intl.dart';

import '../notifications/notifications_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    final isDarkModeAsync = ref.watch(themeProvider);
    final currentLanguage = ref.watch(languageProvider);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(
            "Profile",
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
                            horizontal: 16, vertical: 8),
                        child: FilledButton(
                          onPressed: () {
                            ref
                                .read(authStateProvider.notifier)
                                .signInWithGoogle();
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.login),
                              SizedBox(width: 8),
                              Text('Sign in with Google'),
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

              // Theme Toggle
              ListTile(
                leading: const Icon(Icons.brightness_6_outlined),
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: isDarkModeAsync.valueOrNull ?? false,
                  onChanged: (value) {
                    ref.read(themeProvider.notifier).toggleTheme();
                  },
                ),
              ),

              // Language Selection
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: const Text(
                  'Language',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Text(
                  currentLanguage == 'en' ? 'English' : 'Español',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                onTap: () =>
                    _showLanguageSelector(context, ref, currentLanguage),
              ),

              /// Report
              ListTile(
                leading: const Icon(Icons.bar_chart_outlined),
                title: const Text(
                  'Report',
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
                  title: const Text(
                    'Sincronizar',
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(_getSyncStatusText(ref)),
                  trailing: _buildSyncIndicator(ref),
                  onTap: () {
                    ref.read(syncNotifierProvider.notifier).syncFromRemote();
                  },
                ),

              // Notifications Settings
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text(
                  'Notifications',
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
                  title: const Text(
                    'Cerrar sesión',
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

  String _getSyncStatusText(WidgetRef ref) {
    final syncState = ref.watch(syncNotifierProvider);
    if (syncState.lastSyncTime != null) {
      final formatter = DateFormat('dd/MM/yyyy HH:mm');
      return 'Última sincronización: ${formatter.format(syncState.lastSyncTime!)}';
    }
    return syncState.message ?? 'No sincronizado';
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
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Select Language'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                ref.read(languageProvider.notifier).updateLanguage('en');
                Navigator.pop(context);
              },
              isDefaultAction: currentLanguage == 'en',
              child: const Text('English'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                ref.read(languageProvider.notifier).updateLanguage('es');
                Navigator.pop(context);
              },
              isDefaultAction: currentLanguage == 'es',
              child: const Text('Español'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (BuildContext context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
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
              title: const Text('Español'),
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

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
      ),
      body: Center(
        child: Text('Report'),
      ),
    );
  }
}
