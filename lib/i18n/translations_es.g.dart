///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'package:slang/overrides.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsEs implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	/// [AppLocaleUtils.buildWithOverrides] is recommended for overriding.
	TranslationsEs({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: $meta = TranslationMetadata(
		    locale: AppLocale.es,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <es>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsEs _root = this; // ignore: unused_field

	// Translations
	@override late final _TranslationsAppEs app = _TranslationsAppEs._(_root);
	@override late final _TranslationsOnboardingEs onboarding = _TranslationsOnboardingEs._(_root);
}

// Path: app
class _TranslationsAppEs implements TranslationsAppEn {
	_TranslationsAppEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => TranslationOverrides.string(_root.$meta, 'app.title', {}) ?? 'Never Forgett';
	@override String get description => TranslationOverrides.string(_root.$meta, 'app.description', {}) ?? 'Never Forgett - Aplicación de recordatorios de pagos';
	@override String get list => TranslationOverrides.string(_root.$meta, 'app.list', {}) ?? 'Lista';
	@override late final _TranslationsAppErrorEs error = _TranslationsAppErrorEs._(_root);
	@override late final _TranslationsAppHomeEs home = _TranslationsAppHomeEs._(_root);
	@override late final _TranslationsAppProfileEs profile = _TranslationsAppProfileEs._(_root);
	@override late final _TranslationsAppReportEs report = _TranslationsAppReportEs._(_root);
	@override late final _TranslationsAppNotificationsEs notifications = _TranslationsAppNotificationsEs._(_root);
	@override late final _TranslationsAppRemindersEs reminders = _TranslationsAppRemindersEs._(_root);
	@override late final _TranslationsAppCalendarEs calendar = _TranslationsAppCalendarEs._(_root);
}

// Path: onboarding
class _TranslationsOnboardingEs implements TranslationsOnboardingEn {
	_TranslationsOnboardingEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => TranslationOverrides.string(_root.$meta, 'onboarding.title', {}) ?? '¡Bienvenido a Never Forgett!';
	@override String get button => TranslationOverrides.string(_root.$meta, 'onboarding.button', {}) ?? '¡Empezar!';
	@override late final _TranslationsOnboardingFeaturesEs features = _TranslationsOnboardingFeaturesEs._(_root);
}

// Path: app.error
class _TranslationsAppErrorEs implements TranslationsAppErrorEn {
	_TranslationsAppErrorEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get generalError => TranslationOverrides.string(_root.$meta, 'app.error.generalError', {}) ?? 'Ocurrió un error';
}

// Path: app.home
class _TranslationsAppHomeEs implements TranslationsAppHomeEn {
	_TranslationsAppHomeEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get reminders => TranslationOverrides.string(_root.$meta, 'app.home.reminders', {}) ?? 'Recordatorios';
	@override String get search => TranslationOverrides.string(_root.$meta, 'app.home.search', {}) ?? 'Buscar recordatorios...';
	@override String get createReminder => TranslationOverrides.string(_root.$meta, 'app.home.createReminder', {}) ?? 'Crear recordatorio';
	@override String get paymentDetails => TranslationOverrides.string(_root.$meta, 'app.home.paymentDetails', {}) ?? 'Detalles del pago';
}

// Path: app.profile
class _TranslationsAppProfileEs implements TranslationsAppProfileEn {
	_TranslationsAppProfileEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get perfil => TranslationOverrides.string(_root.$meta, 'app.profile.perfil', {}) ?? 'Perfil';
	@override String get signInWithGoogle => TranslationOverrides.string(_root.$meta, 'app.profile.signInWithGoogle', {}) ?? 'Iniciar sesión con Google';
	@override String get darkMode => TranslationOverrides.string(_root.$meta, 'app.profile.darkMode', {}) ?? 'Modo oscuro';
	@override String get language => TranslationOverrides.string(_root.$meta, 'app.profile.language', {}) ?? 'Idioma';
	@override String get report => TranslationOverrides.string(_root.$meta, 'app.profile.report', {}) ?? 'Reportes';
	@override String get sync => TranslationOverrides.string(_root.$meta, 'app.profile.sync', {}) ?? 'Sincronizar';
	@override String get notifications => TranslationOverrides.string(_root.$meta, 'app.profile.notifications', {}) ?? 'Notificaciones';
	@override String get logout => TranslationOverrides.string(_root.$meta, 'app.profile.logout', {}) ?? 'Cerrar sesión';
	@override String get noSync => TranslationOverrides.string(_root.$meta, 'app.profile.noSync', {}) ?? 'No sincronizado';
	@override String get lastSync => TranslationOverrides.string(_root.$meta, 'app.profile.lastSync', {}) ?? 'Última sincronización';
	@override String get english => TranslationOverrides.string(_root.$meta, 'app.profile.english', {}) ?? 'Inglés';
	@override String get spanish => TranslationOverrides.string(_root.$meta, 'app.profile.spanish', {}) ?? 'Español';
	@override String get faceId => TranslationOverrides.string(_root.$meta, 'app.profile.faceId', {}) ?? 'Face ID';
	@override String get fingerprint => TranslationOverrides.string(_root.$meta, 'app.profile.fingerprint', {}) ?? 'Huella dactilar';
	@override String get enableFaceIdAuthentication => TranslationOverrides.string(_root.$meta, 'app.profile.enableFaceIdAuthentication', {}) ?? 'Habilitar autenticación de Face ID';
	@override String get enableFingerprintAuthentication => TranslationOverrides.string(_root.$meta, 'app.profile.enableFingerprintAuthentication', {}) ?? 'Habilitar autenticación de huella dactilar';
	@override String get faceIdNotAvailable => TranslationOverrides.string(_root.$meta, 'app.profile.faceIdNotAvailable', {}) ?? 'Face ID no disponible';
	@override String get fingerprintNotAvailable => TranslationOverrides.string(_root.$meta, 'app.profile.fingerprintNotAvailable', {}) ?? 'Huella dactilar no disponible';
	@override String get cancel => TranslationOverrides.string(_root.$meta, 'app.profile.cancel', {}) ?? 'Cancelar';
}

// Path: app.report
class _TranslationsAppReportEs implements TranslationsAppReportEn {
	_TranslationsAppReportEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => TranslationOverrides.string(_root.$meta, 'app.report.title', {}) ?? 'Reportes';
	@override String get lastMonth => TranslationOverrides.string(_root.$meta, 'app.report.lastMonth', {}) ?? 'Último mes';
	@override String get last3Months => TranslationOverrides.string(_root.$meta, 'app.report.last3Months', {}) ?? 'Últimos 3 meses';
	@override String get last6Months => TranslationOverrides.string(_root.$meta, 'app.report.last6Months', {}) ?? 'Últimos 6 meses';
	@override String get noPaymentDataAvailable => TranslationOverrides.string(_root.$meta, 'app.report.noPaymentDataAvailable', {}) ?? 'No hay datos de pagos disponibles';
	@override String get paymentTrends => TranslationOverrides.string(_root.$meta, 'app.report.paymentTrends', {}) ?? 'Tendencias de pagos';
	@override String get highestPayments => TranslationOverrides.string(_root.$meta, 'app.report.highestPayments', {}) ?? 'Pagos más altos';
	@override String get categoryDistribution => TranslationOverrides.string(_root.$meta, 'app.report.categoryDistribution', {}) ?? 'Distribución de categorías';
}

// Path: app.notifications
class _TranslationsAppNotificationsEs implements TranslationsAppNotificationsEn {
	_TranslationsAppNotificationsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => TranslationOverrides.string(_root.$meta, 'app.notifications.title', {}) ?? 'Notificaciones';
	@override String get unread => TranslationOverrides.string(_root.$meta, 'app.notifications.unread', {}) ?? 'No leídas';
	@override String get recent => TranslationOverrides.string(_root.$meta, 'app.notifications.recent', {}) ?? 'Recientes';
	@override String get read => TranslationOverrides.string(_root.$meta, 'app.notifications.read', {}) ?? 'Leídas';
	@override String get noUnreadNotifications => TranslationOverrides.string(_root.$meta, 'app.notifications.noUnreadNotifications', {}) ?? 'No hay notificaciones no leídas';
	@override String get noRecentNotifications => TranslationOverrides.string(_root.$meta, 'app.notifications.noRecentNotifications', {}) ?? 'No hay notificaciones recientes';
	@override String get noReadNotifications => TranslationOverrides.string(_root.$meta, 'app.notifications.noReadNotifications', {}) ?? 'No hay notificaciones leídas';
	@override String get notificationSettings => TranslationOverrides.string(_root.$meta, 'app.notifications.notificationSettings', {}) ?? 'Configuración de notificaciones';
	@override String get enableNotifications => TranslationOverrides.string(_root.$meta, 'app.notifications.enableNotifications', {}) ?? 'Habilitar notificaciones';
	@override String get receivePaymentReminders => TranslationOverrides.string(_root.$meta, 'app.notifications.receivePaymentReminders', {}) ?? 'Recibir recordatorios de pagos';
	@override String get pleaseEnableNotificationsInSettings => TranslationOverrides.string(_root.$meta, 'app.notifications.pleaseEnableNotificationsInSettings', {}) ?? 'Por favor, habilite las notificaciones en la configuración';
	@override String get notifyMeBeforeDueDate => TranslationOverrides.string(_root.$meta, 'app.notifications.notifyMeBeforeDueDate', {}) ?? 'Notificarme antes de la fecha de vencimiento:';
	@override String get clearReadNotifications => TranslationOverrides.string(_root.$meta, 'app.notifications.clearReadNotifications', {}) ?? 'Limpiar notificaciones leídas';
	@override String get justNow => TranslationOverrides.string(_root.$meta, 'app.notifications.justNow', {}) ?? 'Ahora';
	@override String daysAgo({required Object count}) => TranslationOverrides.string(_root.$meta, 'app.notifications.daysAgo', {'count': count}) ?? '${count}d atrás';
	@override String hoursAgo({required Object count}) => TranslationOverrides.string(_root.$meta, 'app.notifications.hoursAgo', {'count': count}) ?? '${count}h atrás';
	@override String minutesAgo({required Object count}) => TranslationOverrides.string(_root.$meta, 'app.notifications.minutesAgo', {'count': count}) ?? '${count}m atrás';
	@override String get close => TranslationOverrides.string(_root.$meta, 'app.notifications.close', {}) ?? 'Cerrar';
	@override String received({required Object timestamp}) => TranslationOverrides.string(_root.$meta, 'app.notifications.received', {'timestamp': timestamp}) ?? 'Recibido: ${timestamp}';
	@override String daysBefore({required Object count}) => TranslationOverrides.string(_root.$meta, 'app.notifications.daysBefore', {'count': count}) ?? '${count} días antes';
}

// Path: app.reminders
class _TranslationsAppRemindersEs implements TranslationsAppRemindersEn {
	_TranslationsAppRemindersEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get createReminder => TranslationOverrides.string(_root.$meta, 'app.reminders.createReminder', {}) ?? '¿Qué pago quieres recordar?';
	@override String get title => TranslationOverrides.string(_root.$meta, 'app.reminders.title', {}) ?? 'Título';
	@override String get titleRequired => TranslationOverrides.string(_root.$meta, 'app.reminders.titleRequired', {}) ?? 'El título es requerido';
	@override String get description => TranslationOverrides.string(_root.$meta, 'app.reminders.description', {}) ?? 'Descripción (opcional)';
	@override String get amount => TranslationOverrides.string(_root.$meta, 'app.reminders.amount', {}) ?? 'Cantidad';
	@override String get amountRequired => TranslationOverrides.string(_root.$meta, 'app.reminders.amountRequired', {}) ?? 'La cantidad es requerida';
	@override String get amountInvalid => TranslationOverrides.string(_root.$meta, 'app.reminders.amountInvalid', {}) ?? 'La cantidad es inválida';
	@override String get category => TranslationOverrides.string(_root.$meta, 'app.reminders.category', {}) ?? 'Categoría';
	@override String get dueDate => TranslationOverrides.string(_root.$meta, 'app.reminders.dueDate', {}) ?? 'Fecha de vencimiento';
	@override String get recurringPayment => TranslationOverrides.string(_root.$meta, 'app.reminders.recurringPayment', {}) ?? 'Pago recurrente';
	@override String get recurrenceType => TranslationOverrides.string(_root.$meta, 'app.reminders.recurrenceType', {}) ?? 'Tipo de repetición';
	@override String get recurrenceInterval => TranslationOverrides.string(_root.$meta, 'app.reminders.recurrenceInterval', {}) ?? 'Intervalo de repetición';
	@override String get save => TranslationOverrides.string(_root.$meta, 'app.reminders.save', {}) ?? 'Guardar';
	@override String get daily => TranslationOverrides.string(_root.$meta, 'app.reminders.daily', {}) ?? 'Diario';
	@override String get weekly => TranslationOverrides.string(_root.$meta, 'app.reminders.weekly', {}) ?? 'Semanal';
	@override String get monthly => TranslationOverrides.string(_root.$meta, 'app.reminders.monthly', {}) ?? 'Mensual';
	@override String get yearly => TranslationOverrides.string(_root.$meta, 'app.reminders.yearly', {}) ?? 'Anual';
	@override String get searchCategory => TranslationOverrides.string(_root.$meta, 'app.reminders.searchCategory', {}) ?? 'Buscar categoría...';
	@override String get days => TranslationOverrides.string(_root.$meta, 'app.reminders.days', {}) ?? 'días';
	@override String get weeks => TranslationOverrides.string(_root.$meta, 'app.reminders.weeks', {}) ?? 'semanas';
	@override String get months => TranslationOverrides.string(_root.$meta, 'app.reminders.months', {}) ?? 'meses';
	@override String get years => TranslationOverrides.string(_root.$meta, 'app.reminders.years', {}) ?? 'años';
}

// Path: app.calendar
class _TranslationsAppCalendarEs implements TranslationsAppCalendarEn {
	_TranslationsAppCalendarEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get calendar => TranslationOverrides.string(_root.$meta, 'app.calendar.calendar', {}) ?? 'Calendario';
	@override String get upcomingReminders => TranslationOverrides.string(_root.$meta, 'app.calendar.upcomingReminders', {}) ?? 'Recordatorios próximos';
	@override String get close => TranslationOverrides.string(_root.$meta, 'app.calendar.close', {}) ?? 'Cerrar';
	@override String get amount => TranslationOverrides.string(_root.$meta, 'app.calendar.amount', {}) ?? 'Cantidad';
	@override String get due => TranslationOverrides.string(_root.$meta, 'app.calendar.due', {}) ?? 'Vencimiento';
	@override String get remindersFor => TranslationOverrides.string(_root.$meta, 'app.calendar.remindersFor', {}) ?? 'Recordatorios para';
}

// Path: onboarding.features
class _TranslationsOnboardingFeaturesEs implements TranslationsOnboardingFeaturesEn {
	_TranslationsOnboardingFeaturesEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsOnboardingFeaturesSmartRemindersEs smart_reminders = _TranslationsOnboardingFeaturesSmartRemindersEs._(_root);
	@override late final _TranslationsOnboardingFeaturesCalendarViewEs calendar_view = _TranslationsOnboardingFeaturesCalendarViewEs._(_root);
	@override late final _TranslationsOnboardingFeaturesReportsAndStatisticsEs reports_and_statistics = _TranslationsOnboardingFeaturesReportsAndStatisticsEs._(_root);
	@override late final _TranslationsOnboardingFeaturesCloudSyncEs cloud_sync = _TranslationsOnboardingFeaturesCloudSyncEs._(_root);
}

// Path: onboarding.features.smart_reminders
class _TranslationsOnboardingFeaturesSmartRemindersEs implements TranslationsOnboardingFeaturesSmartRemindersEn {
	_TranslationsOnboardingFeaturesSmartRemindersEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => TranslationOverrides.string(_root.$meta, 'onboarding.features.smart_reminders.title', {}) ?? 'Recordatorios Inteligentes';
	@override String get description => TranslationOverrides.string(_root.$meta, 'onboarding.features.smart_reminders.description', {}) ?? 'Nunca olvides un pago importante con nuestros recordatorios personalizables';
}

// Path: onboarding.features.calendar_view
class _TranslationsOnboardingFeaturesCalendarViewEs implements TranslationsOnboardingFeaturesCalendarViewEn {
	_TranslationsOnboardingFeaturesCalendarViewEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => TranslationOverrides.string(_root.$meta, 'onboarding.features.calendar_view.title', {}) ?? 'Vista de Calendario';
	@override String get description => TranslationOverrides.string(_root.$meta, 'onboarding.features.calendar_view.description', {}) ?? 'Visualiza todos tus pagos en un calendario intuitivo';
}

// Path: onboarding.features.reports_and_statistics
class _TranslationsOnboardingFeaturesReportsAndStatisticsEs implements TranslationsOnboardingFeaturesReportsAndStatisticsEn {
	_TranslationsOnboardingFeaturesReportsAndStatisticsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => TranslationOverrides.string(_root.$meta, 'onboarding.features.reports_and_statistics.title', {}) ?? 'Reportes y Estadísticas';
	@override String get description => TranslationOverrides.string(_root.$meta, 'onboarding.features.reports_and_statistics.description', {}) ?? 'Analiza tus gastos y mantén un control de tus finanzas';
}

// Path: onboarding.features.cloud_sync
class _TranslationsOnboardingFeaturesCloudSyncEs implements TranslationsOnboardingFeaturesCloudSyncEn {
	_TranslationsOnboardingFeaturesCloudSyncEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => TranslationOverrides.string(_root.$meta, 'onboarding.features.cloud_sync.title', {}) ?? 'Sincronización en la Nube';
	@override String get description => TranslationOverrides.string(_root.$meta, 'onboarding.features.cloud_sync.description', {}) ?? 'Mantén tus datos seguros y sincronizados en todos tus dispositivos';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsEs {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'app.title': return TranslationOverrides.string(_root.$meta, 'app.title', {}) ?? 'Never Forgett';
			case 'app.description': return TranslationOverrides.string(_root.$meta, 'app.description', {}) ?? 'Never Forgett - Aplicación de recordatorios de pagos';
			case 'app.list': return TranslationOverrides.string(_root.$meta, 'app.list', {}) ?? 'Lista';
			case 'app.error.generalError': return TranslationOverrides.string(_root.$meta, 'app.error.generalError', {}) ?? 'Ocurrió un error';
			case 'app.home.reminders': return TranslationOverrides.string(_root.$meta, 'app.home.reminders', {}) ?? 'Recordatorios';
			case 'app.home.search': return TranslationOverrides.string(_root.$meta, 'app.home.search', {}) ?? 'Buscar recordatorios...';
			case 'app.home.createReminder': return TranslationOverrides.string(_root.$meta, 'app.home.createReminder', {}) ?? 'Crear recordatorio';
			case 'app.home.paymentDetails': return TranslationOverrides.string(_root.$meta, 'app.home.paymentDetails', {}) ?? 'Detalles del pago';
			case 'app.profile.perfil': return TranslationOverrides.string(_root.$meta, 'app.profile.perfil', {}) ?? 'Perfil';
			case 'app.profile.signInWithGoogle': return TranslationOverrides.string(_root.$meta, 'app.profile.signInWithGoogle', {}) ?? 'Iniciar sesión con Google';
			case 'app.profile.darkMode': return TranslationOverrides.string(_root.$meta, 'app.profile.darkMode', {}) ?? 'Modo oscuro';
			case 'app.profile.language': return TranslationOverrides.string(_root.$meta, 'app.profile.language', {}) ?? 'Idioma';
			case 'app.profile.report': return TranslationOverrides.string(_root.$meta, 'app.profile.report', {}) ?? 'Reportes';
			case 'app.profile.sync': return TranslationOverrides.string(_root.$meta, 'app.profile.sync', {}) ?? 'Sincronizar';
			case 'app.profile.notifications': return TranslationOverrides.string(_root.$meta, 'app.profile.notifications', {}) ?? 'Notificaciones';
			case 'app.profile.logout': return TranslationOverrides.string(_root.$meta, 'app.profile.logout', {}) ?? 'Cerrar sesión';
			case 'app.profile.noSync': return TranslationOverrides.string(_root.$meta, 'app.profile.noSync', {}) ?? 'No sincronizado';
			case 'app.profile.lastSync': return TranslationOverrides.string(_root.$meta, 'app.profile.lastSync', {}) ?? 'Última sincronización';
			case 'app.profile.english': return TranslationOverrides.string(_root.$meta, 'app.profile.english', {}) ?? 'Inglés';
			case 'app.profile.spanish': return TranslationOverrides.string(_root.$meta, 'app.profile.spanish', {}) ?? 'Español';
			case 'app.profile.faceId': return TranslationOverrides.string(_root.$meta, 'app.profile.faceId', {}) ?? 'Face ID';
			case 'app.profile.fingerprint': return TranslationOverrides.string(_root.$meta, 'app.profile.fingerprint', {}) ?? 'Huella dactilar';
			case 'app.profile.enableFaceIdAuthentication': return TranslationOverrides.string(_root.$meta, 'app.profile.enableFaceIdAuthentication', {}) ?? 'Habilitar autenticación de Face ID';
			case 'app.profile.enableFingerprintAuthentication': return TranslationOverrides.string(_root.$meta, 'app.profile.enableFingerprintAuthentication', {}) ?? 'Habilitar autenticación de huella dactilar';
			case 'app.profile.faceIdNotAvailable': return TranslationOverrides.string(_root.$meta, 'app.profile.faceIdNotAvailable', {}) ?? 'Face ID no disponible';
			case 'app.profile.fingerprintNotAvailable': return TranslationOverrides.string(_root.$meta, 'app.profile.fingerprintNotAvailable', {}) ?? 'Huella dactilar no disponible';
			case 'app.profile.cancel': return TranslationOverrides.string(_root.$meta, 'app.profile.cancel', {}) ?? 'Cancelar';
			case 'app.report.title': return TranslationOverrides.string(_root.$meta, 'app.report.title', {}) ?? 'Reportes';
			case 'app.report.lastMonth': return TranslationOverrides.string(_root.$meta, 'app.report.lastMonth', {}) ?? 'Último mes';
			case 'app.report.last3Months': return TranslationOverrides.string(_root.$meta, 'app.report.last3Months', {}) ?? 'Últimos 3 meses';
			case 'app.report.last6Months': return TranslationOverrides.string(_root.$meta, 'app.report.last6Months', {}) ?? 'Últimos 6 meses';
			case 'app.report.noPaymentDataAvailable': return TranslationOverrides.string(_root.$meta, 'app.report.noPaymentDataAvailable', {}) ?? 'No hay datos de pagos disponibles';
			case 'app.report.paymentTrends': return TranslationOverrides.string(_root.$meta, 'app.report.paymentTrends', {}) ?? 'Tendencias de pagos';
			case 'app.report.highestPayments': return TranslationOverrides.string(_root.$meta, 'app.report.highestPayments', {}) ?? 'Pagos más altos';
			case 'app.report.categoryDistribution': return TranslationOverrides.string(_root.$meta, 'app.report.categoryDistribution', {}) ?? 'Distribución de categorías';
			case 'app.notifications.title': return TranslationOverrides.string(_root.$meta, 'app.notifications.title', {}) ?? 'Notificaciones';
			case 'app.notifications.unread': return TranslationOverrides.string(_root.$meta, 'app.notifications.unread', {}) ?? 'No leídas';
			case 'app.notifications.recent': return TranslationOverrides.string(_root.$meta, 'app.notifications.recent', {}) ?? 'Recientes';
			case 'app.notifications.read': return TranslationOverrides.string(_root.$meta, 'app.notifications.read', {}) ?? 'Leídas';
			case 'app.notifications.noUnreadNotifications': return TranslationOverrides.string(_root.$meta, 'app.notifications.noUnreadNotifications', {}) ?? 'No hay notificaciones no leídas';
			case 'app.notifications.noRecentNotifications': return TranslationOverrides.string(_root.$meta, 'app.notifications.noRecentNotifications', {}) ?? 'No hay notificaciones recientes';
			case 'app.notifications.noReadNotifications': return TranslationOverrides.string(_root.$meta, 'app.notifications.noReadNotifications', {}) ?? 'No hay notificaciones leídas';
			case 'app.notifications.notificationSettings': return TranslationOverrides.string(_root.$meta, 'app.notifications.notificationSettings', {}) ?? 'Configuración de notificaciones';
			case 'app.notifications.enableNotifications': return TranslationOverrides.string(_root.$meta, 'app.notifications.enableNotifications', {}) ?? 'Habilitar notificaciones';
			case 'app.notifications.receivePaymentReminders': return TranslationOverrides.string(_root.$meta, 'app.notifications.receivePaymentReminders', {}) ?? 'Recibir recordatorios de pagos';
			case 'app.notifications.pleaseEnableNotificationsInSettings': return TranslationOverrides.string(_root.$meta, 'app.notifications.pleaseEnableNotificationsInSettings', {}) ?? 'Por favor, habilite las notificaciones en la configuración';
			case 'app.notifications.notifyMeBeforeDueDate': return TranslationOverrides.string(_root.$meta, 'app.notifications.notifyMeBeforeDueDate', {}) ?? 'Notificarme antes de la fecha de vencimiento:';
			case 'app.notifications.clearReadNotifications': return TranslationOverrides.string(_root.$meta, 'app.notifications.clearReadNotifications', {}) ?? 'Limpiar notificaciones leídas';
			case 'app.notifications.justNow': return TranslationOverrides.string(_root.$meta, 'app.notifications.justNow', {}) ?? 'Ahora';
			case 'app.notifications.daysAgo': return ({required Object count}) => TranslationOverrides.string(_root.$meta, 'app.notifications.daysAgo', {'count': count}) ?? '${count}d atrás';
			case 'app.notifications.hoursAgo': return ({required Object count}) => TranslationOverrides.string(_root.$meta, 'app.notifications.hoursAgo', {'count': count}) ?? '${count}h atrás';
			case 'app.notifications.minutesAgo': return ({required Object count}) => TranslationOverrides.string(_root.$meta, 'app.notifications.minutesAgo', {'count': count}) ?? '${count}m atrás';
			case 'app.notifications.close': return TranslationOverrides.string(_root.$meta, 'app.notifications.close', {}) ?? 'Cerrar';
			case 'app.notifications.received': return ({required Object timestamp}) => TranslationOverrides.string(_root.$meta, 'app.notifications.received', {'timestamp': timestamp}) ?? 'Recibido: ${timestamp}';
			case 'app.notifications.daysBefore': return ({required Object count}) => TranslationOverrides.string(_root.$meta, 'app.notifications.daysBefore', {'count': count}) ?? '${count} días antes';
			case 'app.reminders.createReminder': return TranslationOverrides.string(_root.$meta, 'app.reminders.createReminder', {}) ?? '¿Qué pago quieres recordar?';
			case 'app.reminders.title': return TranslationOverrides.string(_root.$meta, 'app.reminders.title', {}) ?? 'Título';
			case 'app.reminders.titleRequired': return TranslationOverrides.string(_root.$meta, 'app.reminders.titleRequired', {}) ?? 'El título es requerido';
			case 'app.reminders.description': return TranslationOverrides.string(_root.$meta, 'app.reminders.description', {}) ?? 'Descripción (opcional)';
			case 'app.reminders.amount': return TranslationOverrides.string(_root.$meta, 'app.reminders.amount', {}) ?? 'Cantidad';
			case 'app.reminders.amountRequired': return TranslationOverrides.string(_root.$meta, 'app.reminders.amountRequired', {}) ?? 'La cantidad es requerida';
			case 'app.reminders.amountInvalid': return TranslationOverrides.string(_root.$meta, 'app.reminders.amountInvalid', {}) ?? 'La cantidad es inválida';
			case 'app.reminders.category': return TranslationOverrides.string(_root.$meta, 'app.reminders.category', {}) ?? 'Categoría';
			case 'app.reminders.dueDate': return TranslationOverrides.string(_root.$meta, 'app.reminders.dueDate', {}) ?? 'Fecha de vencimiento';
			case 'app.reminders.recurringPayment': return TranslationOverrides.string(_root.$meta, 'app.reminders.recurringPayment', {}) ?? 'Pago recurrente';
			case 'app.reminders.recurrenceType': return TranslationOverrides.string(_root.$meta, 'app.reminders.recurrenceType', {}) ?? 'Tipo de repetición';
			case 'app.reminders.recurrenceInterval': return TranslationOverrides.string(_root.$meta, 'app.reminders.recurrenceInterval', {}) ?? 'Intervalo de repetición';
			case 'app.reminders.save': return TranslationOverrides.string(_root.$meta, 'app.reminders.save', {}) ?? 'Guardar';
			case 'app.reminders.daily': return TranslationOverrides.string(_root.$meta, 'app.reminders.daily', {}) ?? 'Diario';
			case 'app.reminders.weekly': return TranslationOverrides.string(_root.$meta, 'app.reminders.weekly', {}) ?? 'Semanal';
			case 'app.reminders.monthly': return TranslationOverrides.string(_root.$meta, 'app.reminders.monthly', {}) ?? 'Mensual';
			case 'app.reminders.yearly': return TranslationOverrides.string(_root.$meta, 'app.reminders.yearly', {}) ?? 'Anual';
			case 'app.reminders.searchCategory': return TranslationOverrides.string(_root.$meta, 'app.reminders.searchCategory', {}) ?? 'Buscar categoría...';
			case 'app.reminders.days': return TranslationOverrides.string(_root.$meta, 'app.reminders.days', {}) ?? 'días';
			case 'app.reminders.weeks': return TranslationOverrides.string(_root.$meta, 'app.reminders.weeks', {}) ?? 'semanas';
			case 'app.reminders.months': return TranslationOverrides.string(_root.$meta, 'app.reminders.months', {}) ?? 'meses';
			case 'app.reminders.years': return TranslationOverrides.string(_root.$meta, 'app.reminders.years', {}) ?? 'años';
			case 'app.calendar.calendar': return TranslationOverrides.string(_root.$meta, 'app.calendar.calendar', {}) ?? 'Calendario';
			case 'app.calendar.upcomingReminders': return TranslationOverrides.string(_root.$meta, 'app.calendar.upcomingReminders', {}) ?? 'Recordatorios próximos';
			case 'app.calendar.close': return TranslationOverrides.string(_root.$meta, 'app.calendar.close', {}) ?? 'Cerrar';
			case 'app.calendar.amount': return TranslationOverrides.string(_root.$meta, 'app.calendar.amount', {}) ?? 'Cantidad';
			case 'app.calendar.due': return TranslationOverrides.string(_root.$meta, 'app.calendar.due', {}) ?? 'Vencimiento';
			case 'app.calendar.remindersFor': return TranslationOverrides.string(_root.$meta, 'app.calendar.remindersFor', {}) ?? 'Recordatorios para';
			case 'onboarding.title': return TranslationOverrides.string(_root.$meta, 'onboarding.title', {}) ?? '¡Bienvenido a Never Forgett!';
			case 'onboarding.button': return TranslationOverrides.string(_root.$meta, 'onboarding.button', {}) ?? '¡Empezar!';
			case 'onboarding.features.smart_reminders.title': return TranslationOverrides.string(_root.$meta, 'onboarding.features.smart_reminders.title', {}) ?? 'Recordatorios Inteligentes';
			case 'onboarding.features.smart_reminders.description': return TranslationOverrides.string(_root.$meta, 'onboarding.features.smart_reminders.description', {}) ?? 'Nunca olvides un pago importante con nuestros recordatorios personalizables';
			case 'onboarding.features.calendar_view.title': return TranslationOverrides.string(_root.$meta, 'onboarding.features.calendar_view.title', {}) ?? 'Vista de Calendario';
			case 'onboarding.features.calendar_view.description': return TranslationOverrides.string(_root.$meta, 'onboarding.features.calendar_view.description', {}) ?? 'Visualiza todos tus pagos en un calendario intuitivo';
			case 'onboarding.features.reports_and_statistics.title': return TranslationOverrides.string(_root.$meta, 'onboarding.features.reports_and_statistics.title', {}) ?? 'Reportes y Estadísticas';
			case 'onboarding.features.reports_and_statistics.description': return TranslationOverrides.string(_root.$meta, 'onboarding.features.reports_and_statistics.description', {}) ?? 'Analiza tus gastos y mantén un control de tus finanzas';
			case 'onboarding.features.cloud_sync.title': return TranslationOverrides.string(_root.$meta, 'onboarding.features.cloud_sync.title', {}) ?? 'Sincronización en la Nube';
			case 'onboarding.features.cloud_sync.description': return TranslationOverrides.string(_root.$meta, 'onboarding.features.cloud_sync.description', {}) ?? 'Mantén tus datos seguros y sincronizados en todos tus dispositivos';
			default: return null;
		}
	}
}

