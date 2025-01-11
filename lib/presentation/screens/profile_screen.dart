import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/firebase_providers.dart';
import '../../application/providers/theme_provider.dart';
import '../../application/providers/language_provider.dart';
import 'notifications_screen.dart';
import '../widgets/category_management_dialog.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final isDarkModeAsync = ref.watch(themeProvider);
    final currentLanguage = ref.watch(languageProvider);

    print('isDarkModeAsync: $isDarkModeAsync');

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // User Profile Section
        if (user != null) ...[
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.photoURL ?? ''),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.displayName ?? 'User',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            user.email ?? '',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],

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

        const SizedBox(height: 32),

        // Authentication Button
        if (user == null)
          ElevatedButton(
            onPressed: () {
              // ref.read(authControllerProvider).signInWithGoogle();
            },
            child: const Text('Sign in with Google'),
          )
        else
          ElevatedButton(
            onPressed: () {
              // ref.read(authControllerProvider).signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
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
