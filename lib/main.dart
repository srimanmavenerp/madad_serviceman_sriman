import 'package:demandium_serviceman/utils/core_export.dart';
import 'package:get/get.dart';
import 'feature/booking_request/controller/new_booking_list_controller.dart';
import 'feature/booking_request/view/new_booking_list_screen.dart';
import 'helper/get_di.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  //
  // // Register GetX controllers
  // // Get.put(DashboardController(dashboardRepository: ''));
  // // Get.put(BookingController());
  // // Get.put(LocalizationController(sharedPrefereler(: null, apiClient: null), sharedPrefeull)es: null, apiClient: null);
  // // Get.put(ConversationController(conversationRepo: ''));
  // // Get.put(AuthController(authRepo: ''));

  if (ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = MyHttpOverrides();
  }
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);

  // if(defaultTargetPlatform == TargetPlatform.android) {
  //   await FirebaseMessaging.instance.requestPermission();
  // }

  Map<String, Map<String, String>> languages = await di.init();
  NotificationBody? body;

  try {
    await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    if (GetPlatform.isMobile) {
      final RemoteMessage? remoteMessage = await FirebaseMessaging.instance
          .getInitialMessage();
      if (remoteMessage != null) {
        body = NotificationHelper.convertNotification(remoteMessage.data);
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print("");
    }
  }

  runApp(MyApp(languages: languages, body: body));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBody? body;
  const MyApp({super.key, required this.languages, required this.body});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetBuilder<LocalizationController>(
          builder: (localizeController) {
            return GetMaterialApp(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              navigatorKey: Get.key,
              theme: themeController.darkTheme ? dark : light,
              locale: localizeController.locale,
              translations: Messages(languages: languages),
              fallbackLocale: Locale(
                AppConstants.languages[0].languageCode!,
                AppConstants.languages[0].countryCode,
              ),
              initialRoute: RouteHelper.getSplashRoute(body: body),
              getPages: RouteHelper.routes,
              defaultTransition: Transition.topLevel,
              transitionDuration: const Duration(milliseconds: 500),
              builder: (context, widget) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1)),
                child: Material(
                  child: SafeArea(
                    top: false,
                    bottom: GetPlatform.isAndroid,
                    child: Stack(children: [widget!]),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
