import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/theme_provider.dart';
import '../../application/providers/language_provider.dart';
import 'notifications_screen.dart';
import '../widgets/category_management_dialog.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    final isDarkModeAsync = ref.watch(themeProvider);
    final currentLanguage = ref.watch(languageProvider);

    print('isDarkModeAsync: $isDarkModeAsync');

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        if (authState.isLoading)
          const Center(child: CircularProgressIndicator()),
        if (authState.error != null)
          Text(
            authState.error!,
            style: const TextStyle(color: Colors.red),
          ),
        if (!authState.isLoading)
          authState.user == null
              ? ElevatedButton(
                  onPressed: () {
                    ref.read(authStateProvider.notifier).signInWithGoogle();
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.login),
                      SizedBox(width: 8),
                      Text('Sign in with Google'),
                    ],
                  ),
                )
              : Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          authState.user!.photoURL ?? '',
                        ),
                      ),
                      title: Text(authState.user!.displayName ?? ''),
                      subtitle: Text(authState.user!.email ?? ''),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(authStateProvider.notifier).signOut();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
        const SizedBox(height: 32),

        // Theme Toggle
        ListTile(
          leading: const Icon(Icons.brightness_6),
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
          leading: const Icon(Icons.language),
          title: const Text(
            'Language',
            style: TextStyle(fontSize: 16),
          ),
          trailing: DropdownButton<String>(
            value: currentLanguage,
            items: const [
              DropdownMenuItem(
                value: 'en',
                child: Text(
                  'English',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              DropdownMenuItem(
                value: 'es',
                child: Text(
                  'Español',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                ref.read(languageProvider.notifier).updateLanguage(value);
              }
            },
          ),
        ),

        // Categories Management
        ListTile(
          leading: const Icon(Icons.category),
          title: const Text('Manage Categories'),
          onTap: () {
            _showCategoriesDialog(context, ref);
          },
        ),

        // Notifications Settings
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showCategoriesDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const CategoryManagementDialog(),
    );
  }
}
