import 'package:dtpocketfm/pages/musicdetails.dart';
import 'package:dtpocketfm/pages/splash.dart';
import 'package:dtpocketfm/provider/audiobycategoryprovider.dart';
import 'package:dtpocketfm/provider/audiobylanguageprovider.dart';
import 'package:dtpocketfm/provider/continuewatchingseeallprovider.dart';
import 'package:dtpocketfm/provider/detailprovider.dart';
import 'package:dtpocketfm/provider/generalprovider.dart';
import 'package:dtpocketfm/provider/homeprovider.dart';
import 'package:dtpocketfm/provider/libraryprovider.dart';
import 'package:dtpocketfm/provider/notificationprovider.dart';
import 'package:dtpocketfm/provider/paymentprovider.dart';
import 'package:dtpocketfm/provider/playprovider.dart';
import 'package:dtpocketfm/provider/premiumaudioprovider.dart';
import 'package:dtpocketfm/provider/premiumprovider.dart';
import 'package:dtpocketfm/provider/searchprovider.dart';
import 'package:dtpocketfm/provider/sidedrawerprovider.dart';
import 'package:dtpocketfm/provider/updateprofileprovider.dart';
import 'package:dtpocketfm/utils/constant.dart';
import 'package:dtpocketfm/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: Constant.appPackageName,
    androidNotificationChannelName: Constant.appName ?? "",
    androidNotificationOngoing: true,
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Locales.init(['en', 'ar', 'hi']);

  if (!kIsWeb) {
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId(Constant.oneSignalAppId);
    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt.
    // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      debugPrint("Accepted permission: ===> $accepted");
    });
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GeneralProvider()),
          ChangeNotifierProvider(create: (_) => SidedrawerProvider()),
          ChangeNotifierProvider(create: (_) => UpdateProfileProvider()),
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => SearchProvider()),
          ChangeNotifierProvider(create: (_) => PremiumProvider()),
          ChangeNotifierProvider(create: (_) => DetailProvider()),
          ChangeNotifierProvider(create: (_) => AudiobyCategoryProvider()),
          ChangeNotifierProvider(create: (_) => LibraryProvider()),
          ChangeNotifierProvider(create: (_) => PaymentProvider()),
          ChangeNotifierProvider(create: (_) => PremiumaudioProvider()),
          ChangeNotifierProvider(create: (_) => AudiobyLanguageProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ChangeNotifierProvider(
              create: (_) => ContinuewatchingSeeallProvider()),
          ChangeNotifierProvider(create: (_) => PlayProvider()),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    if (!kIsWeb) Utils.enableScreenCapture();
    _getPackage();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("didChangeAppLifecycleState state =========> $state");
    switch (state) {
      case AppLifecycleState.detached:
        audioPlayer.stop();
        audioPlayer.dispose();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (locale) => MaterialApp(
        localizationsDelegates: Locales.delegates,
        supportedLocales: Locales.supportedLocales,
        locale: locale,
        debugShowCheckedModeBanner: false,
        home: const Splash(),
      ),
    );
  }

  _getPackage() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    String appVersion = packageInfo.version;
    String appBuildNumber = packageInfo.buildNumber;

    Constant.appPackageName = packageName;
    Constant.appVersion = appVersion;
    Constant.appBuildNumber = appBuildNumber;
    debugPrint(
        "App Package Name : $packageName, App Version : $appVersion, App build Number : $appBuildNumber");
  }
}
