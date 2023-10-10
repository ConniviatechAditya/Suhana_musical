import 'dart:developer';
import 'package:dtpocketfm/pages/intro.dart';
import 'package:dtpocketfm/pages/bottombar.dart';
import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/sharedpre.dart';
import 'package:dtpocketfm/widget/myimage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SharedPre sharedpre = SharedPre();
  String userid = "";

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      if (!mounted) return;
      isFirstCheck();
    });
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      backgroundColor: colorPrimary,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            foregroundDecoration: BoxDecoration(
              color: white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                colors: [
                  colorAccent.withOpacity(0.2),
                  colorAccent.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.01, 2],
              ),
            ),
            color: colorPrimary,
            child: MyImage(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
              imagePath: "ic_splashbg.png",
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: MyImage(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.30,
                  imagePath: "ic_appicon.png"),
            ),
          ),
        ],
      ),
    );
  }

  Future isFirstCheck() async {
    String? seen = await sharedpre.read("seen") ?? "";
    log("seen:---$seen");

    if (seen == "1") {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const Bottombar();
          },
        ),
      );
    } else {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const Intro();
          },
        ),
      );
    }
  }
}
