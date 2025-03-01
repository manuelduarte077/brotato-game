import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pay_reminder/i18n/translations.g.dart';
import '../../application/providers/onboarding_provider.dart';

class OnboardingBottomSheet extends ConsumerWidget {
  const OnboardingBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final texts = context.texts.onboarding;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      minChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    texts.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _buildFeatureItem(
                    context,
                    Icons.notifications_active,
                    texts.features.smart_reminders.title,
                    texts.features.smart_reminders.description,
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    context,
                    Icons.calendar_today,
                    texts.features.calendar_view.title,
                    texts.features.calendar_view.description,
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    context,
                    Icons.bar_chart,
                    texts.features.reports_and_statistics.title,
                    texts.features.reports_and_statistics.description,
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    context,
                    Icons.sync,
                    texts.features.cloud_sync.title,
                    texts.features.cloud_sync.description,
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      ref
                          .read(onboardingProvider.notifier)
                          .markOnboardingAsSeen();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      texts.button,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
