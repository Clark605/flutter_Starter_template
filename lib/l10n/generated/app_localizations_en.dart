// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Starter';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get retry => 'Retry';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get continueLabel => 'Continue';

  @override
  String get done => 'Done';

  @override
  String get close => 'Close';

  @override
  String get search => 'Search';

  @override
  String get refresh => 'Refresh';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Info';

  @override
  String get loading => 'Loading...';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get themeSystem => 'System Default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get appVersion => 'Version';

  @override
  String get about => 'About';

  @override
  String get logout => 'Log Out';

  @override
  String get noInternetTitle => 'No Connection';

  @override
  String get noInternetMessage =>
      'Please check your internet connection and try again.';

  @override
  String get offlineBannerText =>
      'You are currently offline. Some features may be unavailable.';

  @override
  String get backOnlineText => 'Connection restored.';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get updateRequiredTitle => 'Update Required';

  @override
  String get updateRequiredMessage =>
      'A new version of the application is available. Please update to continue.';

  @override
  String get updateNow => 'Update Now';

  @override
  String get copyUpdateLink => 'Copy Update Link';

  @override
  String get linkCopied => 'Link copied to clipboard.';

  @override
  String get maintenanceTitle => 'Under Maintenance';

  @override
  String get maintenanceMessage =>
      'The system is temporarily under maintenance. Please check back shortly.';

  @override
  String get errorNetwork =>
      'No internet connection. Please check your network and try again.';

  @override
  String get errorTimeout => 'The connection timed out. Please try again.';

  @override
  String get errorUnauthorized =>
      'Authentication required. Please log in again.';

  @override
  String get errorForbidden =>
      'You do not have permission to perform this action.';

  @override
  String get errorNotFound => 'The requested resource was not found.';

  @override
  String get errorValidation => 'The provided information is invalid.';

  @override
  String get errorServer => 'A server error occurred. Please try again later.';

  @override
  String get errorCancelled => 'The operation was cancelled.';

  @override
  String get errorUnknown => 'An unexpected error occurred. Please try again.';

  @override
  String get exampleTitle => 'Reference Items';

  @override
  String get exampleSubtitle => 'Clean architecture reference implementation';

  @override
  String get exampleEmptyTitle => 'No items found';

  @override
  String get exampleEmptyMessage =>
      'Pull to refresh to load items from the remote service.';

  @override
  String get exampleLoadMore => 'Loading more...';

  @override
  String exampleItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String get exampleCreateTitle => 'New Item';

  @override
  String get exampleItemTitleLabel => 'Title';

  @override
  String get exampleItemBodyLabel => 'Description';

  @override
  String get exampleItemCreated => 'Item created successfully';

  @override
  String get notFoundRouteTitle => 'Page Not Found';

  @override
  String get notFoundRouteMessage =>
      'The requested route does not exist or has been moved.';

  @override
  String get goToHome => 'Go to Home';

  @override
  String get onboardingTitle1 => 'Production-Grade Starter';

  @override
  String get onboardingDesc1 =>
      'Engineered with Flutter BLoC, Freezed, strict feature architecture and design tokens.';

  @override
  String get onboardingTitle2 => 'Full English & Arabic RTL';

  @override
  String get onboardingDesc2 =>
      'Seamless locale switching with IBM Plex Sans Arabic and Inter typography.';

  @override
  String get onboardingTitle3 => 'Ready to Ship Out of Box';

  @override
  String get onboardingDesc3 =>
      'Multi-flavor environments, guarded actions, CI/CD pipelines, and zero third-party accounts.';

  @override
  String get skip => 'Skip';

  @override
  String get getStarted => 'Get Started';
}
