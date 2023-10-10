import 'package:dtpocketfm/pages/bottombar.dart';
import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/constant.dart';
import 'package:dtpocketfm/utils/sharedpre.dart';
import 'package:dtpocketfm/widget/myimage.dart';
import 'package:dtpocketfm/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  SharedPre sharedPre = SharedPre();
  Constant constant = Constant();
  PageController pageController = PageController();
  final currentPageNotifier = ValueNotifier<int>(0);
  int position = 0;

  List<String> introText = [
    "introtextone",
    "introtexttwo",
    "introtextthree",
  ];

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    var hi = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: colorPrimaryDark,
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
                  colorPrimaryDark.withOpacity(1),
                  colorPrimaryDark.withOpacity(0.2),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.3, 0.10],
              ),
            ),
            alignment: Alignment.center,
            child: MyImage(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
                imagePath: "ic_introbg.png"),
          ),
          Align(
            alignment: Alignment.center,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: constant.introImage.length,
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyImage(
                            imagePath: constant.introImage[index],
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.55,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                MyText(
                                    color: white,
                                    text: introText[position],
                                    textalign: TextAlign.center,
                                    fontsize: 20,
                                    multilanguage: true,
                                    inter: false,
                                    maxline: 2,
                                    fontwaight: FontWeight.w300,
                                    overflow: TextOverflow.ellipsis,
                                    fontstyle: FontStyle.normal),
                                SizedBox(height: hi * 0.02),
                                MyText(
                                    color: white,
                                    text: constant.introSmallText[position],
                                    textalign: TextAlign.center,
                                    fontsize: 12,
                                    inter: true,
                                    maxline: 6,
                                    fontwaight: FontWeight.w300,
                                    overflow: TextOverflow.ellipsis,
                                    fontstyle: FontStyle.normal),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onPageChanged: (index) {
                    position = index;
                    currentPageNotifier.value = index;
                    debugPrint("position :==> $position");
                    setState(() {});
                  },
                ),
                Positioned.fill(
                  bottom: 70,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      focusColor: colorAccent,
                      onTap: () async {
                        if (position == constant.introImage.length - 1) {
                          await sharedPre.save("seen", "1");
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const Bottombar();
                              },
                            ),
                          );
                        } else {
                          pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        }
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          decoration: BoxDecoration(
                            color: colorAccent,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: MyText(
                              color: white,
                              text: "getstart",
                              fontsize: 16,
                              multilanguage: true,
                              fontwaight: FontWeight.w500,
                              maxline: 1,
                              overflow: TextOverflow.ellipsis,
                              inter: true,
                              textalign: TextAlign.center,
                              fontstyle: FontStyle.normal)),
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 30,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () async {
                        await sharedPre.save("seen", "1");
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const Bottombar();
                            },
                          ),
                        );
                      },
                      child: MyText(
                          color: white,
                          text: position == constant.introImage.length - 1
                              ? "finish"
                              : "skip",
                          textalign: TextAlign.center,
                          fontsize: 14,
                          inter: false,
                          multilanguage: true,
                          fontwaight: FontWeight.w300,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 50,
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: constant.introImage.length,
                      effect: const ExpandingDotsEffect(
                        dotWidth: 7,
                        dotColor: white,
                        expansionFactor: 4,
                        offset: 1,
                        dotHeight: 7,
                        activeDotColor: yellow,
                        radius: 100,
                        strokeWidth: 1,
                        spacing: 5,
                      ),
                    ),
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
