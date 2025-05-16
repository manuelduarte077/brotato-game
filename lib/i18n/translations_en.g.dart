///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element

class Translations implements BaseTranslations<AppLocale, Translations> {
  /// Returns the current translations of the given [context].
  ///
  /// Usage:
  /// final texts = Translations.of(context);
  static Translations of(BuildContext context) =>
      InheritedLocaleData.of<AppLocale, Translations>(context).translations;

  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  /// [AppLocaleUtils.buildWithOverrides] is recommended for overriding.
  Translations(
      {Map<String, Node>? overrides,
      PluralResolver? cardinalResolver,
      PluralResolver? ordinalResolver})
      : $meta = TranslationMetadata(
          locale: AppLocale.en,
          overrides: overrides ?? {},
          cardinalResolver: cardinalResolver,
          ordinalResolver: ordinalResolver,
        ) {
    $meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <en>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  dynamic operator [](String key) => $meta.getTranslation(key);

  late final Translations _root = this; // ignore: unused_field

  // Translations
  late final TranslationsAppEn app = TranslationsAppEn._(_root);
  late final TranslationsOnboardingEn onboarding =
      TranslationsOnboardingEn._(_root);
}

// Path: app
class TranslationsAppEn {
  TranslationsAppEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title =>
      TranslationOverrides.string(_root.$meta, 'app.title', {}) ??
      'Never Forgett';
  String get description =>
      TranslationOverrides.string(_root.$meta, 'app.description', {}) ??
      'Never Forgett - Payment Reminder App';
  String get list =>
      TranslationOverrides.string(_root.$meta, 'app.list', {}) ?? 'List';
  late final TranslationsAppErrorEn error = TranslationsAppErrorEn._(_root);
  late final TranslationsAppHomeEn home = TranslationsAppHomeEn._(_root);
  late final TranslationsAppProfileEn profile =
      TranslationsAppProfileEn._(_root);
  late final TranslationsAppReportEn report = TranslationsAppReportEn._(_root);
  late final TranslationsAppNotificationsEn notifications =
      TranslationsAppNotificationsEn._(_root);
  late final TranslationsAppRemindersEn reminders =
      TranslationsAppRemindersEn._(_root);
  late final TranslationsAppCalendarEn calendar =
      TranslationsAppCalendarEn._(_root);
}

// Path: onboarding
class TranslationsOnboardingEn {
  TranslationsOnboardingEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title =>
      TranslationOverrides.string(_root.$meta, 'onboarding.title', {}) ??
      'Welcome to Never Forgett!';
  String get button =>
      TranslationOverrides.string(_root.$meta, 'onboarding.button', {}) ??
      'Get Started';
  late final TranslationsOnboardingFeaturesEn features =
      TranslationsOnboardingFeaturesEn._(_root);
}

// Path: app.error
class TranslationsAppErrorEn {
  TranslationsAppErrorEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get generalError =>
      TranslationOverrides.string(_root.$meta, 'app.error.generalError', {}) ??
      'An error occurred';
}

// Path: app.home
class TranslationsAppHomeEn {
  TranslationsAppHomeEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get reminders =>
      TranslationOverrides.string(_root.$meta, 'app.home.reminders', {}) ??
      'Reminders';
  String get search =>
      TranslationOverrides.string(_root.$meta, 'app.home.search', {}) ??
      'Search reminders...';
  String get createReminder =>
      TranslationOverrides.string(_root.$meta, 'app.home.createReminder', {}) ??
      'Create Reminder';
  String get paymentDetails =>
      TranslationOverrides.string(_root.$meta, 'app.home.paymentDetails', {}) ??
      'Payment Details';
}

// Path: app.profile
class TranslationsAppProfileEn {
  TranslationsAppProfileEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get perfil =>
      TranslationOverrides.string(_root.$meta, 'app.profile.perfil', {}) ??
      'Profile';
  String get signInWithGoogle =>
      TranslationOverrides.string(
          _root.$meta, 'app.profile.signInWithGoogle', {}) ??
      'Sign in with Google';
  String get darkMode =>
      TranslationOverrides.string(_root.$meta, 'app.profile.darkMode', {}) ??
      'Dark Mode';
  String get language =>
      TranslationOverrides.string(_root.$meta, 'app.profile.language', {}) ??
      'Language';
  String get report =>
      TranslationOverrides.string(_root.$meta, 'app.profile.report', {}) ??
      'Report';
  String get sync =>
      TranslationOverrides.string(_root.$meta, 'app.profile.sync', {}) ??
      'Sync';
  String get notifications =>
      TranslationOverrides.string(
          _root.$meta, 'app.profile.notifications', {}) ??
      'Notifications';
  String get logout =>
      TranslationOverrides.string(_root.$meta, 'app.profile.logout', {}) ??
      'Logout';
  String get noSync =>
      TranslationOverrides.string(_root.$meta, 'app.profile.noSync', {}) ??
      'No sync';
  String get lastSync =>
      TranslationOverrides.string(_root.$meta, 'app.profile.lastSync', {}) ??
      'Last sync';
  String get english =>
      TranslationOverrides.string(_root.$meta, 'app.profile.english', {}) ??
      'English';
  String get spanish =>
      TranslationOverrides.string(_root.$meta, 'app.profile.spanish', {}) ??
      'Spanish';
  String get faceId =>
      TranslationOverrides.string(_root.$meta, 'app.profile.faceId', {}) ??
      'Face ID';
  String get fingerprint =>
      TranslationOverrides.string(_root.$meta, 'app.profile.fingerprint', {}) ??
      'Fingerprint';
  String get enableFaceIdAuthentication =>
      TranslationOverrides.string(
          _root.$meta, 'app.profile.enableFaceIdAuthentication', {}) ??
      'Enable Face ID Authentication';
  String get enableFingerprintAuthentication =>
      TranslationOverrides.string(
          _root.$meta, 'app.profile.enableFingerprintAuthentication', {}) ??
      'Enable Fingerprint Authentication';
  String get faceIdNotAvailable =>
      TranslationOverrides.string(
          _root.$meta, 'app.profile.faceIdNotAvailable', {}) ??
      'Face ID is not available';
  String get fingerprintNotAvailable =>
      TranslationOverrides.string(
          _root.$meta, 'app.profile.fingerprintNotAvailable', {}) ??
      'Fingerprint is not available';
  String get cancel =>
      TranslationOverrides.string(_root.$meta, 'app.profile.cancel', {}) ??
      'Cancel';
}

// Path: app.report
class TranslationsAppReportEn {
  TranslationsAppReportEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title =>
      TranslationOverrides.string(_root.$meta, 'app.report.title', {}) ??
      'Reports';
  String get lastMonth =>
      TranslationOverrides.string(_root.$meta, 'app.report.lastMonth', {}) ??
      'Last Month';
  String get last3Months =>
      TranslationOverrides.string(_root.$meta, 'app.report.last3Months', {}) ??
      'Last 3 Months';
  String get last6Months =>
      TranslationOverrides.string(_root.$meta, 'app.report.last6Months', {}) ??
      'Last 6 Months';
  String get noPaymentDataAvailable =>
      TranslationOverrides.string(
          _root.$meta, 'app.report.noPaymentDataAvailable', {}) ??
      'No payment data available';
  String get paymentTrends =>
      TranslationOverrides.string(
          _root.$meta, 'app.report.paymentTrends', {}) ??
      'Payment Trends';
  String get highestPayments =>
      TranslationOverrides.string(
          _root.$meta, 'app.report.highestPayments', {}) ??
      'Highest Payments';
  String get categoryDistribution =>
      TranslationOverrides.string(
          _root.$meta, 'app.report.categoryDistribution', {}) ??
      'Category Distribution';
}

// Path: app.notifications
class TranslationsAppNotificationsEn {
  TranslationsAppNotificationsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title =>
      TranslationOverrides.string(_root.$meta, 'app.notifications.title', {}) ??
      'Notifications';
  String get unread =>
      TranslationOverrides.string(
          _root.$meta, 'app.notifications.unread', {}) ??
      'Unread';
  String get recent =>
      TranslationOverrides.string(
          _root.$meta, 'app.notifications.recent', {}) ??
      'Recent';
  String get read =>
      TranslationOverrides.string(_root.$meta, 'app.notifications.read', {}) ??
      'Read';
  String get noUnreadNotifications =>
      TranslationOverrides.string(
          _root.$meta, 'app.notifications.noUnreadNotifications', {}) ??
      'No unread notifications';
  String get noRecentNotifications =>
      TranslationOverrides.string(
          _root.$meta, 'app.notifications.noRecentNotifications', {}) ??
      'No recent notifications';
  String get noReadNotifications =>
      TranslationOverrides.string(
          _root.$meta, 'app.notifications.noReadNotifications', {}) ??
      'No read notifications';
  String get notificationSettings =>
      TranslationOverrides.string(
          _root.$meta, 'app.notifications.notificationSettings', {}) ??
      'Notification Settings';
  String get enableNotifications =>
      TranslationOverrides.string(
          _root.$meta, 'app.notifications.enableNotifications', {}) ??
      'Enable Notifications';
  String get receivePaymentReminders =>
      TranslationOverrides.string(
          _root.$meta, 'app.notifications.receivePaymentReminders', {}) ??
      'Receive payment reminders';
  String get pleaseEnableNotificationsInSettings =>
      TranslationOverrides.string(_root.$meta,
          'app.notifications.pleaseEnableNotificationsInSettings', {}) ??
      'Please enable notifications in settings';
  String get notifyMeBeforeDueDate =>
      TranslationOverrides.string(
          _root.$meta, 'app.notifications.notifyMeBeforeDueDate', {}) ??
      'Notify me before due date:';
  String get clearReadNotifications =>
      TranslationOverrides.string(
          _root.$meta, 'app.notifications.clearReadNotifications', {}) ??
      'Clear read notifications';
  String get justNow =>
      TranslationOverrides.string(
          _root.$meta, 'app.notifications.justNow', {}) ??
      'Just now';
  String daysAgo({required Object count}) =>
      TranslationOverrides.string(
          _root.$meta, 'app.notifications.daysAgo', {'count': count}) ??
      '${count}d ago';
  String hoursAgo({required Object count}) =>
      TranslationOverrides.string(
          _root.$meta, 'app.notifications.hoursAgo', {'count': count}) ??
      '${count}h ago';
  String minutesAgo({required Object count}) =>
      TranslationOverrides.string(
          _root.$meta, 'app.notifications.minutesAgo', {'count': count}) ??
      '${count}m ago';
  String get close =>
      TranslationOverrides.string(_root.$meta, 'app.notifications.close', {}) ??
      'Close';
  String received({required Object timestamp}) =>
      TranslationOverrides.string(_root.$meta, 'app.notifications.received',
          {'timestamp': timestamp}) ??
      'Received: ${timestamp}';
  String daysBefore({required Object count}) =>
      TranslationOverrides.string(
          _root.$meta, 'app.notifications.daysBefore', {'count': count}) ??
      '${count} days before';
}

// Path: app.reminders
class TranslationsAppRemindersEn {
  TranslationsAppRemindersEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get createReminder =>
      TranslationOverrides.string(
          _root.$meta, 'app.reminders.createReminder', {}) ??
      'What payment do you want to remember?';
  String get title =>
      TranslationOverrides.string(_root.$meta, 'app.reminders.title', {}) ??
      'Title';
  String get titleRequired =>
      TranslationOverrides.string(
          _root.$meta, 'app.reminders.titleRequired', {}) ??
      'Title is required';
  String get description =>
      TranslationOverrides.string(
          _root.$meta, 'app.reminders.description', {}) ??
      'Description (optional)';
  String get amount =>
      TranslationOverrides.string(_root.$meta, 'app.reminders.amount', {}) ??
      'Amount';
  String get amountRequired =>
      TranslationOverrides.string(
          _root.$meta, 'app.reminders.amountRequired', {}) ??
      'Amount is required';
  String get amountInvalid =>
      TranslationOverrides.string(
          _root.$meta, 'app.reminders.amountInvalid', {}) ??
      'Amount is invalid';
  String get category =>
      TranslationOverrides.string(_root.$meta, 'app.reminders.category', {}) ??
      'Category';
  String get dueDate =>
      TranslationOverrides.string(_root.$meta, 'app.reminders.dueDate', {}) ??
      'Due date';
  String get recurringPayment =>
      TranslationOverrides.string(
          _root.$meta, 'app.reminders.recurringPayment', {}) ??
      'Recurring payment';
  String get recurrenceType =>
      TranslationOverrides.string(
          _root.$meta, 'app.reminders.recurrenceType', {}) ??
      'Recurrence type';
  String get recurrenceInterval =>
      TranslationOverrides.string(
          _root.$meta, 'app.reminders.recurrenceInterval', {}) ??
      'Recurrence interval';
  String get save =>
      TranslationOverrides.string(_root.$meta, 'app.reminders.save', {}) ??
      'Save';
  String get daily =>
      TranslationOverrides.string(_root.$meta, 'app.reminders.daily', {}) ??
      'Daily';
  String get weekly =>
      TranslationOverrides.string(_root.$meta, 'app.reminders.weekly', {}) ??
      'Weekly';
  String get monthly =>
      TranslationOverrides.string(_root.$meta, 'app.reminders.monthly', {}) ??
      'Monthly';
  String get yearly =>
      TranslationOverrides.string(_root.$meta, 'app.reminders.yearly', {}) ??
      'Yearly';
  String get searchCategory =>
      TranslationOverrides.string(
          _root.$meta, 'app.reminders.searchCategory', {}) ??
      'Search category...';
  String get days =>
      TranslationOverrides.string(_root.$meta, 'app.reminders.days', {}) ??
      'days';
  String get weeks =>
      TranslationOverrides.string(_root.$meta, 'app.reminders.weeks', {}) ??
      'weeks';
  String get months =>
      TranslationOverrides.string(_root.$meta, 'app.reminders.months', {}) ??
      'months';
  String get years =>
      TranslationOverrides.string(_root.$meta, 'app.reminders.years', {}) ??
      'years';
}

// Path: app.calendar
class TranslationsAppCalendarEn {
  TranslationsAppCalendarEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get calendar =>
      TranslationOverrides.string(_root.$meta, 'app.calendar.calendar', {}) ??
      'Calendar';
  String get upcomingReminders =>
      TranslationOverrides.string(
          _root.$meta, 'app.calendar.upcomingReminders', {}) ??
      'Upcoming Reminders';
  String get close =>
      TranslationOverrides.string(_root.$meta, 'app.calendar.close', {}) ??
      'Close';
  String get amount =>
      TranslationOverrides.string(_root.$meta, 'app.calendar.amount', {}) ??
      'Amount';
  String get due =>
      TranslationOverrides.string(_root.$meta, 'app.calendar.due', {}) ?? 'Due';
  String get remindersFor =>
      TranslationOverrides.string(
          _root.$meta, 'app.calendar.remindersFor', {}) ??
      'Reminders for';
}

// Path: onboarding.features
class TranslationsOnboardingFeaturesEn {
  TranslationsOnboardingFeaturesEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsOnboardingFeaturesSmartRemindersEn smart_reminders =
      TranslationsOnboardingFeaturesSmartRemindersEn._(_root);
  late final TranslationsOnboardingFeaturesCalendarViewEn calendar_view =
      TranslationsOnboardingFeaturesCalendarViewEn._(_root);
  late final TranslationsOnboardingFeaturesReportsAndStatisticsEn
      reports_and_statistics =
      TranslationsOnboardingFeaturesReportsAndStatisticsEn._(_root);
  late final TranslationsOnboardingFeaturesCloudSyncEn cloud_sync =
      TranslationsOnboardingFeaturesCloudSyncEn._(_root);
}

// Path: onboarding.features.smart_reminders
class TranslationsOnboardingFeaturesSmartRemindersEn {
  TranslationsOnboardingFeaturesSmartRemindersEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title =>
      TranslationOverrides.string(
          _root.$meta, 'onboarding.features.smart_reminders.title', {}) ??
      'Smart Reminders';
  String get description =>
      TranslationOverrides.string(
          _root.$meta, 'onboarding.features.smart_reminders.description', {}) ??
      'Never forget a important payment with our customizable reminders';
}

// Path: onboarding.features.calendar_view
class TranslationsOnboardingFeaturesCalendarViewEn {
  TranslationsOnboardingFeaturesCalendarViewEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title =>
      TranslationOverrides.string(
          _root.$meta, 'onboarding.features.calendar_view.title', {}) ??
      'Calendar View';
  String get description =>
      TranslationOverrides.string(
          _root.$meta, 'onboarding.features.calendar_view.description', {}) ??
      'Visualize all your payments in an intuitive calendar';
}

// Path: onboarding.features.reports_and_statistics
class TranslationsOnboardingFeaturesReportsAndStatisticsEn {
  TranslationsOnboardingFeaturesReportsAndStatisticsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title =>
      TranslationOverrides.string(_root.$meta,
          'onboarding.features.reports_and_statistics.title', {}) ??
      'Reports and Statistics';
  String get description =>
      TranslationOverrides.string(_root.$meta,
          'onboarding.features.reports_and_statistics.description', {}) ??
      'Analyze your expenses and keep control of your finances';
}

// Path: onboarding.features.cloud_sync
class TranslationsOnboardingFeaturesCloudSyncEn {
  TranslationsOnboardingFeaturesCloudSyncEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title =>
      TranslationOverrides.string(
          _root.$meta, 'onboarding.features.cloud_sync.title', {}) ??
      'Cloud Sync';
  String get description =>
      TranslationOverrides.string(
          _root.$meta, 'onboarding.features.cloud_sync.description', {}) ??
      'Keep your data secure and synced across all your devices';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
  dynamic _flatMapFunction(String path) {
    switch (path) {
      case 'app.title':
        return TranslationOverrides.string(_root.$meta, 'app.title', {}) ??
            'Never Forgett';
      case 'app.description':
        return TranslationOverrides.string(
                _root.$meta, 'app.description', {}) ??
            'Never Forgett - Payment Reminder App';
      case 'app.list':
        return TranslationOverrides.string(_root.$meta, 'app.list', {}) ??
            'List';
      case 'app.error.generalError':
        return TranslationOverrides.string(
                _root.$meta, 'app.error.generalError', {}) ??
            'An error occurred';
      case 'app.home.reminders':
        return TranslationOverrides.string(
                _root.$meta, 'app.home.reminders', {}) ??
            'Reminders';
      case 'app.home.search':
        return TranslationOverrides.string(
                _root.$meta, 'app.home.search', {}) ??
            'Search reminders...';
      case 'app.home.createReminder':
        return TranslationOverrides.string(
                _root.$meta, 'app.home.createReminder', {}) ??
            'Create Reminder';
      case 'app.home.paymentDetails':
        return TranslationOverrides.string(
                _root.$meta, 'app.home.paymentDetails', {}) ??
            'Payment Details';
      case 'app.profile.perfil':
        return TranslationOverrides.string(
                _root.$meta, 'app.profile.perfil', {}) ??
            'Profile';
      case 'app.profile.signInWithGoogle':
        return TranslationOverrides.string(
                _root.$meta, 'app.profile.signInWithGoogle', {}) ??
            'Sign in with Google';
      case 'app.profile.darkMode':
        return TranslationOverrides.string(
                _root.$meta, 'app.profile.darkMode', {}) ??
            'Dark Mode';
      case 'app.profile.language':
        return TranslationOverrides.string(
                _root.$meta, 'app.profile.language', {}) ??
            'Language';
      case 'app.profile.report':
        return TranslationOverrides.string(
                _root.$meta, 'app.profile.report', {}) ??
            'Report';
      case 'app.profile.sync':
        return TranslationOverrides.string(
                _root.$meta, 'app.profile.sync', {}) ??
            'Sync';
      case 'app.profile.notifications':
        return TranslationOverrides.string(
                _root.$meta, 'app.profile.notifications', {}) ??
            'Notifications';
      case 'app.profile.logout':
        return TranslationOverrides.string(
                _root.$meta, 'app.profile.logout', {}) ??
            'Logout';
      case 'app.profile.noSync':
        return TranslationOverrides.string(
                _root.$meta, 'app.profile.noSync', {}) ??
            'No sync';
      case 'app.profile.lastSync':
        return TranslationOverrides.string(
                _root.$meta, 'app.profile.lastSync', {}) ??
            'Last sync';
      case 'app.profile.english':
        return TranslationOverrides.string(
                _root.$meta, 'app.profile.english', {}) ??
            'English';
      case 'app.profile.spanish':
        return TranslationOverrides.string(
                _root.$meta, 'app.profile.spanish', {}) ??
            'Spanish';
      case 'app.profile.faceId':
        return TranslationOverrides.string(
                _root.$meta, 'app.profile.faceId', {}) ??
            'Face ID';
      case 'app.profile.fingerprint':
        return TranslationOverrides.string(
                _root.$meta, 'app.profile.fingerprint', {}) ??
            'Fingerprint';
      case 'app.profile.enableFaceIdAuthentication':
        return TranslationOverrides.string(
                _root.$meta, 'app.profile.enableFaceIdAuthentication', {}) ??
            'Enable Face ID Authentication';
      case 'app.profile.enableFingerprintAuthentication':
        return TranslationOverrides.string(_root.$meta,
                'app.profile.enableFingerprintAuthentication', {}) ??
            'Enable Fingerprint Authentication';
      case 'app.profile.faceIdNotAvailable':
        return TranslationOverrides.string(
                _root.$meta, 'app.profile.faceIdNotAvailable', {}) ??
            'Face ID is not available';
      case 'app.profile.fingerprintNotAvailable':
        return TranslationOverrides.string(
                _root.$meta, 'app.profile.fingerprintNotAvailable', {}) ??
            'Fingerprint is not available';
      case 'app.profile.cancel':
        return TranslationOverrides.string(
                _root.$meta, 'app.profile.cancel', {}) ??
            'Cancel';
      case 'app.report.title':
        return TranslationOverrides.string(
                _root.$meta, 'app.report.title', {}) ??
            'Reports';
      case 'app.report.lastMonth':
        return TranslationOverrides.string(
                _root.$meta, 'app.report.lastMonth', {}) ??
            'Last Month';
      case 'app.report.last3Months':
        return TranslationOverrides.string(
                _root.$meta, 'app.report.last3Months', {}) ??
            'Last 3 Months';
      case 'app.report.last6Months':
        return TranslationOverrides.string(
                _root.$meta, 'app.report.last6Months', {}) ??
            'Last 6 Months';
      case 'app.report.noPaymentDataAvailable':
        return TranslationOverrides.string(
                _root.$meta, 'app.report.noPaymentDataAvailable', {}) ??
            'No payment data available';
      case 'app.report.paymentTrends':
        return TranslationOverrides.string(
                _root.$meta, 'app.report.paymentTrends', {}) ??
            'Payment Trends';
      case 'app.report.highestPayments':
        return TranslationOverrides.string(
                _root.$meta, 'app.report.highestPayments', {}) ??
            'Highest Payments';
      case 'app.report.categoryDistribution':
        return TranslationOverrides.string(
                _root.$meta, 'app.report.categoryDistribution', {}) ??
            'Category Distribution';
      case 'app.notifications.title':
        return TranslationOverrides.string(
                _root.$meta, 'app.notifications.title', {}) ??
            'Notifications';
      case 'app.notifications.unread':
        return TranslationOverrides.string(
                _root.$meta, 'app.notifications.unread', {}) ??
            'Unread';
      case 'app.notifications.recent':
        return TranslationOverrides.string(
                _root.$meta, 'app.notifications.recent', {}) ??
            'Recent';
      case 'app.notifications.read':
        return TranslationOverrides.string(
                _root.$meta, 'app.notifications.read', {}) ??
            'Read';
      case 'app.notifications.noUnreadNotifications':
        return TranslationOverrides.string(
                _root.$meta, 'app.notifications.noUnreadNotifications', {}) ??
            'No unread notifications';
      case 'app.notifications.noRecentNotifications':
        return TranslationOverrides.string(
                _root.$meta, 'app.notifications.noRecentNotifications', {}) ??
            'No recent notifications';
      case 'app.notifications.noReadNotifications':
        return TranslationOverrides.string(
                _root.$meta, 'app.notifications.noReadNotifications', {}) ??
            'No read notifications';
      case 'app.notifications.notificationSettings':
        return TranslationOverrides.string(
                _root.$meta, 'app.notifications.notificationSettings', {}) ??
            'Notification Settings';
      case 'app.notifications.enableNotifications':
        return TranslationOverrides.string(
                _root.$meta, 'app.notifications.enableNotifications', {}) ??
            'Enable Notifications';
      case 'app.notifications.receivePaymentReminders':
        return TranslationOverrides.string(
                _root.$meta, 'app.notifications.receivePaymentReminders', {}) ??
            'Receive payment reminders';
      case 'app.notifications.pleaseEnableNotificationsInSettings':
        return TranslationOverrides.string(_root.$meta,
                'app.notifications.pleaseEnableNotificationsInSettings', {}) ??
            'Please enable notifications in settings';
      case 'app.notifications.notifyMeBeforeDueDate':
        return TranslationOverrides.string(
                _root.$meta, 'app.notifications.notifyMeBeforeDueDate', {}) ??
            'Notify me before due date:';
      case 'app.notifications.clearReadNotifications':
        return TranslationOverrides.string(
                _root.$meta, 'app.notifications.clearReadNotifications', {}) ??
            'Clear read notifications';
      case 'app.notifications.justNow':
        return TranslationOverrides.string(
                _root.$meta, 'app.notifications.justNow', {}) ??
            'Just now';
      case 'app.notifications.daysAgo':
        return ({required Object count}) =>
            TranslationOverrides.string(
                _root.$meta, 'app.notifications.daysAgo', {'count': count}) ??
            '${count}d ago';
      case 'app.notifications.hoursAgo':
        return ({required Object count}) =>
            TranslationOverrides.string(
                _root.$meta, 'app.notifications.hoursAgo', {'count': count}) ??
            '${count}h ago';
      case 'app.notifications.minutesAgo':
        return ({required Object count}) =>
            TranslationOverrides.string(_root.$meta,
                'app.notifications.minutesAgo', {'count': count}) ??
            '${count}m ago';
      case 'app.notifications.close':
        return TranslationOverrides.string(
                _root.$meta, 'app.notifications.close', {}) ??
            'Close';
      case 'app.notifications.received':
        return ({required Object timestamp}) =>
            TranslationOverrides.string(_root.$meta,
                'app.notifications.received', {'timestamp': timestamp}) ??
            'Received: ${timestamp}';
      case 'app.notifications.daysBefore':
        return ({required Object count}) =>
            TranslationOverrides.string(_root.$meta,
                'app.notifications.daysBefore', {'count': count}) ??
            '${count} days before';
      case 'app.reminders.createReminder':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.createReminder', {}) ??
            'What payment do you want to remember?';
      case 'app.reminders.title':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.title', {}) ??
            'Title';
      case 'app.reminders.titleRequired':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.titleRequired', {}) ??
            'Title is required';
      case 'app.reminders.description':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.description', {}) ??
            'Description (optional)';
      case 'app.reminders.amount':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.amount', {}) ??
            'Amount';
      case 'app.reminders.amountRequired':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.amountRequired', {}) ??
            'Amount is required';
      case 'app.reminders.amountInvalid':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.amountInvalid', {}) ??
            'Amount is invalid';
      case 'app.reminders.category':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.category', {}) ??
            'Category';
      case 'app.reminders.dueDate':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.dueDate', {}) ??
            'Due date';
      case 'app.reminders.recurringPayment':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.recurringPayment', {}) ??
            'Recurring payment';
      case 'app.reminders.recurrenceType':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.recurrenceType', {}) ??
            'Recurrence type';
      case 'app.reminders.recurrenceInterval':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.recurrenceInterval', {}) ??
            'Recurrence interval';
      case 'app.reminders.save':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.save', {}) ??
            'Save';
      case 'app.reminders.daily':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.daily', {}) ??
            'Daily';
      case 'app.reminders.weekly':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.weekly', {}) ??
            'Weekly';
      case 'app.reminders.monthly':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.monthly', {}) ??
            'Monthly';
      case 'app.reminders.yearly':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.yearly', {}) ??
            'Yearly';
      case 'app.reminders.searchCategory':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.searchCategory', {}) ??
            'Search category...';
      case 'app.reminders.days':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.days', {}) ??
            'days';
      case 'app.reminders.weeks':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.weeks', {}) ??
            'weeks';
      case 'app.reminders.months':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.months', {}) ??
            'months';
      case 'app.reminders.years':
        return TranslationOverrides.string(
                _root.$meta, 'app.reminders.years', {}) ??
            'years';
      case 'app.calendar.calendar':
        return TranslationOverrides.string(
                _root.$meta, 'app.calendar.calendar', {}) ??
            'Calendar';
      case 'app.calendar.upcomingReminders':
        return TranslationOverrides.string(
                _root.$meta, 'app.calendar.upcomingReminders', {}) ??
            'Upcoming Reminders';
      case 'app.calendar.close':
        return TranslationOverrides.string(
                _root.$meta, 'app.calendar.close', {}) ??
            'Close';
      case 'app.calendar.amount':
        return TranslationOverrides.string(
                _root.$meta, 'app.calendar.amount', {}) ??
            'Amount';
      case 'app.calendar.due':
        return TranslationOverrides.string(
                _root.$meta, 'app.calendar.due', {}) ??
            'Due';
      case 'app.calendar.remindersFor':
        return TranslationOverrides.string(
                _root.$meta, 'app.calendar.remindersFor', {}) ??
            'Reminders for';
      case 'onboarding.title':
        return TranslationOverrides.string(
                _root.$meta, 'onboarding.title', {}) ??
            'Welcome to Never Forgett!';
      case 'onboarding.button':
        return TranslationOverrides.string(
                _root.$meta, 'onboarding.button', {}) ??
            'Get Started';
      case 'onboarding.features.smart_reminders.title':
        return TranslationOverrides.string(
                _root.$meta, 'onboarding.features.smart_reminders.title', {}) ??
            'Smart Reminders';
      case 'onboarding.features.smart_reminders.description':
        return TranslationOverrides.string(_root.$meta,
                'onboarding.features.smart_reminders.description', {}) ??
            'Never forget a important payment with our customizable reminders';
      case 'onboarding.features.calendar_view.title':
        return TranslationOverrides.string(
                _root.$meta, 'onboarding.features.calendar_view.title', {}) ??
            'Calendar View';
      case 'onboarding.features.calendar_view.description':
        return TranslationOverrides.string(_root.$meta,
                'onboarding.features.calendar_view.description', {}) ??
            'Visualize all your payments in an intuitive calendar';
      case 'onboarding.features.reports_and_statistics.title':
        return TranslationOverrides.string(_root.$meta,
                'onboarding.features.reports_and_statistics.title', {}) ??
            'Reports and Statistics';
      case 'onboarding.features.reports_and_statistics.description':
        return TranslationOverrides.string(_root.$meta,
                'onboarding.features.reports_and_statistics.description', {}) ??
            'Analyze your expenses and keep control of your finances';
      case 'onboarding.features.cloud_sync.title':
        return TranslationOverrides.string(
                _root.$meta, 'onboarding.features.cloud_sync.title', {}) ??
            'Cloud Sync';
      case 'onboarding.features.cloud_sync.description':
        return TranslationOverrides.string(_root.$meta,
                'onboarding.features.cloud_sync.description', {}) ??
            'Keep your data secure and synced across all your devices';
      default:
        return null;
    }
  }
}
