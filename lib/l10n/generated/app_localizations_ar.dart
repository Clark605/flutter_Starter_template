// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'قالب البداية لفلاتر';

  @override
  String get ok => 'حسناً';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get back => 'رجوع';

  @override
  String get next => 'التالي';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get done => 'تم';

  @override
  String get close => 'إغلاق';

  @override
  String get search => 'بحث';

  @override
  String get refresh => 'تحديث';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجاح';

  @override
  String get warning => 'تنبيه';

  @override
  String get info => 'معلومات';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get themeMode => 'المظهر';

  @override
  String get themeSystem => 'مظهر النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get appVersion => 'الإصدار';

  @override
  String get about => 'حول التطبيق';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get noInternetTitle => 'لا يوجد اتصال بالإنترنت';

  @override
  String get noInternetMessage =>
      'يرجى التحقق من اتصالك بالإنترنت والمحاولة مجدداً.';

  @override
  String get offlineBannerText =>
      'أنت غير متصل بالإنترنت حالياً. قد لا تتوفر بعض الميزات.';

  @override
  String get backOnlineText => 'تمت استعادة الاتصال بالإنترنت.';

  @override
  String get tryAgain => 'إعادة المحاولة';

  @override
  String get updateRequiredTitle => 'تحديث إلزامي';

  @override
  String get updateRequiredMessage =>
      'يتوفر إصدار جديد من التطبيق. يرجى التحديث للمتابعة.';

  @override
  String get updateNow => 'تحديث الآن';

  @override
  String get copyUpdateLink => 'نسخ رابط التحديث';

  @override
  String get linkCopied => 'تم نسخ الرابط إلى الحافظة.';

  @override
  String get maintenanceTitle => 'تحت الصيانة';

  @override
  String get maintenanceMessage =>
      'النظام يخضع للصيانة الدورية حالياً. يرجى المحاولة لاحقاً.';

  @override
  String get errorNetwork =>
      'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة والمحاولة مرة أخرى.';

  @override
  String get errorTimeout => 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.';

  @override
  String get errorUnauthorized =>
      'مطلوب تسجيل الدخول. يرجى تسجيل الدخول مجدداً.';

  @override
  String get errorForbidden => 'ليس لديك الصلاحية لتنفيذ هذا الإجراء.';

  @override
  String get errorNotFound => 'لم يتم العثور على العنصر المطلوب.';

  @override
  String get errorConflict =>
      'حدث تعارض مع الحالة الحالية للمورد. يرجى التحديث والمحاولة مرة أخرى.';

  @override
  String get errorValidation => 'البيانات المدخلة غير صالحة.';

  @override
  String get errorServer => 'حدث خطأ في الخادم. يرجى المحاولة في وقت لاحق.';

  @override
  String get errorDuplicate => 'هذا الإجراء قيد التنفيذ بالفعل. يرجى الانتظار.';

  @override
  String get errorCancelled => 'تم إلغاء العملية.';

  @override
  String get errorUnknown => 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';

  @override
  String get exampleTitle => 'العناصر المرجعية';

  @override
  String get exampleSubtitle => 'نموذج مرجعي للبنية المعمارية النظيفة';

  @override
  String get exampleEmptyTitle => 'لا توجد عناصر حتى الآن';

  @override
  String get exampleEmptyMessage =>
      'اسحب للأسفل للتحديث وتحميل العناصر من الخدمة.';

  @override
  String get exampleLoadMore => 'جارٍ تحميل المزيد...';

  @override
  String exampleItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصر',
      many: '$count عنصراً',
      few: '$count عناصر',
      two: 'عنصران',
      one: 'عنصر واحد',
      zero: 'لا توجد عناصر',
    );
    return '$_temp0';
  }

  @override
  String get exampleCreateTitle => 'عنصر جديد';

  @override
  String get exampleItemTitleLabel => 'العنوان';

  @override
  String get exampleItemBodyLabel => 'الوصف';

  @override
  String get exampleItemCreated => 'تم إنشاء العنصر بنجاح';

  @override
  String get notFoundRouteTitle => 'الصفحة غير موجودة';

  @override
  String get notFoundRouteMessage => 'الصفحة المطلوبة غير موجودة أو تم نقلها.';

  @override
  String get goToHome => 'العودة للرئيسية';

  @override
  String get onboardingTitle1 => 'قالب انطلاق بمعايير الإنتاج';

  @override
  String get onboardingDesc1 =>
      'مبني باستخدام Flutter BLoC و Freezed وبنية معمارية صارمة ورموز تصميم واضحة.';

  @override
  String get onboardingTitle2 => 'دعم كامل للغة العربية والإنجليزية';

  @override
  String get onboardingDesc2 =>
      'تجربة مستخدم كاملة من اليمين إلى اليسار مع خطوط IBM Plex Sans Arabic و Inter.';

  @override
  String get onboardingTitle3 => 'جاهز للإطلاق الفوري';

  @override
  String get onboardingDesc3 =>
      'بيئات متعددة، وإجراءات محمية، وخطوط بناء مؤتمتة بدون الحاجة لحسابات خارجية.';

  @override
  String get skip => 'تخطي';

  @override
  String get getStarted => 'ابدأ الآن';
}
