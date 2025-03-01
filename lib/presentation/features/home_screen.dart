import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pay_reminder/i18n/translations.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'calendar/calendar_screen.dart';
import 'profile/profile_screen.dart';

import 'reminders/reminder_list_screen.dart';
import '../../infrastructure/services/quick_actions_service.dart';
import '../widgets/onboarding_bottom_sheet.dart';
import '../../application/providers/onboarding_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ReminderListScreen(),
    const CalendarScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _initQuickActions();
    _checkOnboarding();
  }

  Future<void> _initQuickActions() async {
    await QuickActionsService().init(context);
  }

  Future<void> _checkOnboarding() async {
    // Delay to ensure the screen is built
    await Future.delayed(Duration.zero);
    if (!mounted) return;

    final hasSeenOnboarding = ref.read(onboardingProvider);
    if (!hasSeenOnboarding) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        showDragHandle: false,
        builder: (context) => const OnboardingBottomSheet(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts.app;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: texts.list,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar),
            label: texts.calendar.calendar,
          ),
          BottomNavigationBarItem(
            key: const Key('profile_button'),
            icon: Icon(CupertinoIcons.person),
            label: texts.profile.perfil,
          ),
        ],
      ),
    );
  }
}
