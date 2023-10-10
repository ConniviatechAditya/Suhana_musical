import 'dart:io';

import 'package:dtpocketfm/pages/home.dart';
import 'package:dtpocketfm/pages/musicdetails.dart';
import 'package:dtpocketfm/pages/mylibrary.dart';
import 'package:dtpocketfm/pages/premiumaudio.dart';
import 'package:dtpocketfm/pages/search.dart';
import 'package:dtpocketfm/utils/adhelper.dart';
import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/sharedpre.dart';
import 'package:dtpocketfm/widget/myimage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

ValueNotifier<AudioPlayer?> currentlyPlaying = ValueNotifier(null);

const double playerMinHeight = 70;
const miniplayerPercentageDeclaration = 0.7;

class Bottombar extends StatefulWidget {
  const Bottombar({super.key});

  @override
  State<Bottombar> createState() => BottombarState();
}

class BottombarState extends State<Bottombar> {
  SharedPre sharedpre = SharedPre();
  int selectedIndex = 0;
  String userid = "";

  @override
  initState() {
    super.initState();
    MobileAds.instance.initialize();
    AdHelper.getAds(context);
    _getdata();
  }

  _getdata() async {
    userid = await sharedpre.read("userid") ?? "";
    debugPrint("userid ===============> $userid");
    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  List<Widget> _children() => [
        const Home(),
        Search(
          userid: userid.toString(),
        ),
        PrimiumAudio(
          userid: userid.toString(),
        ),
        MyLibrary(
          userid: userid.toString(),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = _children();
    return Scaffold(
      backgroundColor: colorPrimary,
      body: Stack(
        children: [
          Center(
            child: children[selectedIndex],
          ),
          _buildMusicPanel(context),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AdHelper().bannerAd(),
          SizedBox(
            height: Platform.isAndroid ? 75 : 95,
            child: BottomNavigationBar(
              backgroundColor: colorPrimary,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              selectedIconTheme: const IconThemeData(color: colorAccent),
              unselectedIconTheme: const IconThemeData(color: darkgray),
              elevation: 5,
              unselectedLabelStyle:
                  GoogleFonts.inter(fontSize: 12, color: darkgray),
              currentIndex: selectedIndex,
              unselectedItemColor: darkgray,
              selectedItemColor: colorAccent,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  backgroundColor: colorPrimary,
                  label: "Home",
                  activeIcon: MyImage(
                    imagePath: "ic_home.png",
                    width: 20,
                    height: 20,
                    color: colorAccent,
                  ),
                  icon: Align(
                    alignment: Alignment.center,
                    child: MyImage(
                      imagePath: "ic_home.png",
                      width: 20,
                      height: 20,
                      color: darkgray,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Search",
                  backgroundColor: colorPrimary,
                  activeIcon: MyImage(
                    imagePath: "ic_search.png",
                    width: 20,
                    height: 20,
                    color: colorAccent,
                  ),
                  icon: Align(
                    alignment: Alignment.center,
                    child: MyImage(
                      imagePath: "ic_search.png",
                      width: 20,
                      height: 20,
                      color: darkgray,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Premium",
                  backgroundColor: colorPrimary,
                  activeIcon: Container(
                    padding: const EdgeInsets.all(0),
                    child: MyImage(
                      imagePath: "ic_primium.png",
                      width: 20,
                      height: 20,
                      color: colorAccent,
                    ),
                  ),
                  icon: Container(
                    padding: const EdgeInsets.all(0),
                    child: MyImage(
                      width: 20,
                      height: 20,
                      color: darkgray,
                      imagePath: "ic_primium.png",
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  backgroundColor: colorPrimary,
                  label: "My Library",
                  activeIcon: MyImage(
                    imagePath: "ic_mylibrary.png",
                    width: 20,
                    height: 20,
                    color: colorAccent,
                  ),
                  icon: Align(
                    alignment: Alignment.center,
                    child: MyImage(
                      width: 20,
                      height: 20,
                      color: darkgray,
                      imagePath: "ic_mylibrary.png",
                    ),
                  ),
                ),
              ],
              onTap: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget _buildMusicPanel(context) {
    return ValueListenableBuilder(
      valueListenable: currentlyPlaying,
      builder: (BuildContext context, AudioPlayer? audioObject, Widget? child) {
        if (audioObject?.audioSource != null) {
          return MusicDetails(
            ishomepage: true,
            stoptime: audioPlayer.position.toString(),
            audioid:
                ((audioPlayer.sequenceState?.currentSource?.tag as MediaItem?)
                        ?.id)
                    .toString(),
            episodeid: "",
            userid: userid.toString(),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
