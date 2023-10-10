import 'package:flutter/material.dart';

class Constant {
  final String baseurl = "";

  // App Data
  static String? appName = "DTPocketFM";
  static String? appPackageName = "com.divinetechs.dtpocketfm";
  static String? appleAppId = "6449582782";
  static String? appVersion = "1";
  static String? appBuildNumber = "1.0.0";
  static String currency = "";
  static String currencySymbol = "";

  // One Signal App Id
  static String oneSignalAppId = "";

  static String androidAppShareUrlDesc =
      "Let me recommend you this application\n\n$androidAppUrl";
  static String iosAppShareUrlDesc =
      "Let me recommend you this application\n\n$iosAppUrl";

  static String androidAppUrl =
      "https://play.google.com/store/apps/details?id=${Constant.appPackageName}";
  static String iosAppUrl =
      "https://itunes.apple.com/us/app/yourapp/id${Constant.appleAppId}";
  static String facebookUrl = "https://www.facebook.com/divinetechs";
  static String instagramUrl = "https://www.instagram.com/divinetechs/";

  static int fixFourDigit = 1317;
  static int fixSixDigit = 161613;
  static int bannerDuration = 10000; // in milliseconds
  static int animationDuration = 800; // in milliseconds

  // Intro Screen Image
  List introImage = [
    "ic_intro1.png",
    "ic_intro2.png",
    "ic_intro3.png",
  ];

  // Intro Screen Text
  List introSmallText = [
    "Lörem ipsum lasam ode devölig. Exojäsm travyheten för att sunade, bena ire samt deception ghosta bins. Der epiren och petöv, fast syras, ner, dore. Pressade ovis. Fasade soprelig. Autoligt mikrologi. Neliga hemin. Anapren mikrocism nyv samt den sehura är egofosamma.",
    "Lörem ipsum lasam ode devölig. Exojäsm travyheten för att sunade, bena ire samt deception ghosta bins. Der epiren och petöv, fast syras, ner, dore. Pressade ovis. Fasade soprelig. Autoligt mikrologi. Neliga hemin. Anapren mikrocism nyv samt den sehura är egofosamma.",
    "Lörem ipsum lasam ode devölig. Exojäsm travyheten för att sunade, bena ire samt deception ghosta bins. Der epiren och petöv, fast syras, ner, dore. Pressade ovis. Fasade soprelig. Autoligt mikrologi. Neliga hemin. Anapren mikrocism nyv samt den sehura är egofosamma.",
  ];

  // Home Screen Static Tab Start
  List<String> tabmenuList = [
    "foryou",
    "stories",
    "course",
    "fullbook",
  ];

  // Detail Page Tab Text Start
  final List<Tab> myTabs = const <Tab>[
    Tab(
      text: "Episodes",
    ),
    Tab(
      text: "Details",
    ),
  ];

  // Library Page Tab
  final List<Tab> mylibraryTabs = const <Tab>[
    Tab(
      text: "My Library",
    ),
    // Tab(
    //   text: "Downloads",
    // ),
  ];

  //  Audio By Category And Language Tab
  final List<Tab> searchItemTab = const <Tab>[
    Tab(
      text: "Stories",
    ),
    Tab(
      text: "Course",
    ),
    Tab(
      text: "Full Books",
    ),
  ];
}
