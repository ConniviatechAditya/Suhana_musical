import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dtpocketfm/pages/audiobycategory.dart';
import 'package:dtpocketfm/pages/bottombar.dart';
import 'package:dtpocketfm/pages/categoryseeall.dart';
import 'package:dtpocketfm/pages/commonpage.dart';
import 'package:dtpocketfm/pages/detail.dart';
import 'package:dtpocketfm/pages/continuewatchingseeall.dart';
import 'package:dtpocketfm/pages/editprofile.dart';
import 'package:dtpocketfm/pages/gridlistseeall.dart';
import 'package:dtpocketfm/pages/landscapseeall.dart';
import 'package:dtpocketfm/pages/notification.dart';
import 'package:dtpocketfm/provider/generalprovider.dart';
import 'package:dtpocketfm/provider/homeprovider.dart';
import 'package:dtpocketfm/provider/sidedrawerprovider.dart';
import 'package:dtpocketfm/utils/adhelper.dart';
import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/constant.dart';
import 'package:dtpocketfm/utils/customwidget.dart';
import 'package:dtpocketfm/utils/musicmanager.dart';
import 'package:dtpocketfm/utils/utils.dart';
import 'package:dtpocketfm/widget/myimage.dart';
import 'package:dtpocketfm/widget/mynetworkimg.dart';
import 'package:dtpocketfm/widget/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:just_audio/just_audio.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../utils/sharedpre.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final MusicManager musicManager = MusicManager();
  SharedPre sharedpre = SharedPre();
  late HomeProvider homeprovider;
  final numberController = TextEditingController();
  PageController pageController = PageController();
  var scollController = ScrollController();
  var scrollController = ScrollController();
  int currentIndex = 0, pagePosition = 0, bannerPosition = 0;
  String userid = "";
  String? aboutUsUrl, privacyUrl, termsConditionUrl, refundPolicyUrl;
  CarouselController controller = CarouselController();

  @override
  void initState() {
    super.initState();
    homeprovider = Provider.of<HomeProvider>(context, listen: false);
    MobileAds.instance.initialize();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getApi("1", "1");
    });
  }

  getApi(String ishomepage, String type) async {
    final generalProvider =
        Provider.of<GeneralProvider>(context, listen: false);

    // Get Userid
    userid = await sharedpre.read("userid") ?? "";
    debugPrint("userid ===============> $userid");
    await homeprovider.valueUpdate(userid);
    await homeprovider.setLoading(true);

    await generalProvider.getPages();
    if (!generalProvider.loading) {
      if (generalProvider.pagesModel.status == 200) {
        if (generalProvider.pagesModel.result != null &&
            (generalProvider.pagesModel.result?.length ?? 0) > 0) {
          for (var i = 0;
              i < (generalProvider.pagesModel.result?.length ?? 0);
              i++) {
            if (generalProvider.pagesModel.result?[i].pageName == "about-us") {
              aboutUsUrl = generalProvider.pagesModel.result?[i].url ?? "";
            }
            if (generalProvider.pagesModel.result?[i].pageName ==
                "privacy-policy") {
              privacyUrl = generalProvider.pagesModel.result?[i].url ?? "";
            }
            if (generalProvider.pagesModel.result?[i].pageName ==
                "terms-and-conditions") {
              termsConditionUrl =
                  generalProvider.pagesModel.result?[i].url ?? "";
            }
            if (generalProvider.pagesModel.result?[i].pageName ==
                "refund-policy") {
              refundPolicyUrl = generalProvider.pagesModel.result?[i].url ?? "";
            }
          }
        }
      }
    }
    if (userid.isNotEmpty || userid != "") {
      await homeprovider.getProfile(userid.toString());
      await homeprovider.getContinueWatching(userid, "1");
    }

    await homeprovider.getBanner(ishomepage, type, userid);
    await homeprovider.getCategory("1");
    await homeprovider.getTopPlay(ishomepage, type, "1");
    await homeprovider.getNewRelease(ishomepage, type, "1");
    AdHelper.createInterstitialAd();
    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
    generalProvider.getGeneralsetting();
  }

  @override
  void dispose() {
    super.dispose();
    homeprovider.clearProvider();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return WillPopScope(
      onWillPop: () => exitDilog(context),
      child: Scaffold(
        drawerEnableOpenDragGesture: true,
        drawer: homeDrawer(),
        backgroundColor: colorPrimaryDark,
        appBar: isSmallScreen
            ? PreferredSize(
                preferredSize: const Size.fromHeight(45),
                child: Consumer<SidedrawerProvider>(
                  builder: (context, profileprovider, child) {
                    return AppBar(
                      backgroundColor: colorPrimaryDark,
                      centerTitle: true,
                      systemOverlayStyle: const SystemUiOverlayStyle(
                        statusBarColor: colorPrimaryDark,
                      ),
                      elevation: 0,
                      leadingWidth: 70,
                      leading: InkWell(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: white, width: 1)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: profileprovider.uid.isNotEmpty ||
                                          profileprovider.uid != ""
                                      ? MyNetworkImage(
                                          imgWidth: 30,
                                          imgHeight: 30,
                                          imageUrl: profileprovider
                                                  .profileModel.result?[0].image
                                                  .toString() ??
                                              "",
                                          fit: BoxFit.cover,
                                        )
                                      : MyImage(
                                          width: 30,
                                          height: 30,
                                          imagePath: "ic_userprofile.png"),
                                ),
                              ),
                              Positioned.fill(
                                  child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: colorAccent.withOpacity(0.70),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: MyImage(
                                    width: 10,
                                    height: 10,
                                    imagePath: "ic_menu.png",
                                    color: white,
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                      title: MyText(
                        color: white,
                        text: "dtpocketfm",
                        textalign: TextAlign.left,
                        multilanguage: true,
                        fontsize: 18,
                        inter: true,
                        maxline: 1,
                        fontwaight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal,
                      ),
                      actions: [
                        profileprovider.uid.isNotEmpty ||
                                profileprovider.uid != ""
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return NotificationPage(userid: userid);
                                      },
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  child: MyImage(
                                    width: 20,
                                    height: 20,
                                    imagePath: "ic_notification.png",
                                    color: white,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    );
                  },
                ),
              )
            : null,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TabList
            Container(
              height: MediaQuery.of(context).size.height * 0.07,
              color: colorPrimaryDark,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: Constant().tabmenuList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      focusColor: colorPrimaryDark,
                      highlightColor: colorPrimaryDark,
                      hoverColor: colorPrimaryDark,
                      onTap: () async {
                        pagePosition = index;
                        debugPrint("index = > $pagePosition");
                        final homeprovider =
                            Provider.of<HomeProvider>(context, listen: false);
                        await homeprovider.getchangeTab(index);
                        if (index == 0) {
                          getApi("1", "1");
                        } else {
                          getApi("4", index.toString());
                        }
                        setState(() {});
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer<HomeProvider>(
                              builder: (context, homeprovider, child) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: index == homeprovider.pageindex
                                    ? const LinearGradient(
                                        colors: [
                                          yellow,
                                          colorAccent,
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      )
                                    : const LinearGradient(
                                        colors: [
                                          colorPrimaryDark,
                                          colorPrimaryDark,
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                              child: MyText(
                                  color: white,
                                  text: Constant().tabmenuList[index],
                                  textalign: TextAlign.center,
                                  fontsize: 14,
                                  inter: true,
                                  multilanguage: true,
                                  maxline: 1,
                                  fontwaight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal),
                            );
                          }),
                        ],
                      ),
                    );
                  }),
            ),
            // TabList Item
            Expanded(child: tabMenuItem(pagePosition)),
            // Audio Player Visible Space
            ValueListenableBuilder(
              valueListenable: currentlyPlaying,
              builder: (BuildContext context, AudioPlayer? audioObject,
                  Widget? child) {
                if (audioObject?.audioSource != null) {
                  return const SizedBox(height: 75);
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget homeDrawer() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Drawer(
        backgroundColor: colorPrimary,
        elevation: 0,
        width: MediaQuery.of(context).size.width * 0.70,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Consumer<HomeProvider>(
              builder: (context, homeProvider, child) {
                if (homeProvider.loadingProfile) {
                  if (userid.isEmpty || userid == "") {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: MyImage(
                            width: 80,
                            height: 80,
                            imagePath: "ic_user.png",
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: MyText(
                            color: white,
                            text: "guestuser",
                            multilanguage: true,
                            textalign: TextAlign.center,
                            fontsize: 18,
                            inter: true,
                            maxline: 2,
                            fontwaight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                            fontstyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return profileShimmer();
                  }
                } else {
                  if (homeProvider.profileModel.status == 200) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: (homeProvider.profileModel.status == 200 &&
                                  ((homeProvider.profileModel.result?[0].image
                                              ?.length ??
                                          0) !=
                                      0))
                              ? MyNetworkImage(
                                  imgWidth: 80,
                                  imgHeight: 80,
                                  fit: BoxFit.cover,
                                  imageUrl: homeProvider
                                          .profileModel.result?[0].image
                                          .toString() ??
                                      "",
                                )
                              : MyImage(
                                  width: 45,
                                  height: 45,
                                  imagePath: "ic_user.png"),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: MyText(
                              color: white,
                              text: (homeProvider.profileModel.status == 200 &&
                                      (homeProvider.profileModel.result?[0]
                                                  .fullName
                                                  .toString() ??
                                              "")
                                          .isEmpty)
                                  ? (homeProvider.profileModel.result?[0].email
                                          .toString() ??
                                      "Guest User")
                                  : homeProvider.profileModel.status == 200
                                      ? (homeProvider
                                              .profileModel.result?[0].fullName
                                              .toString() ??
                                          "Guest User")
                                      : "",
                              textalign: TextAlign.center,
                              fontsize: 18,
                              inter: true,
                              maxline: 2,
                              fontwaight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                              fontstyle: FontStyle.normal),
                        ),
                        InkWell(
                          focusColor: gray.withOpacity(0.40),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return EditProfile(
                                    userid: userid.toString(),
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: MyText(
                                color: red,
                                text: "taptoedit",
                                multilanguage: true,
                                textalign: TextAlign.center,
                                fontsize: 14,
                                inter: true,
                                maxline: 1,
                                fontwaight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: MyImage(
                              width: 80, height: 80, imagePath: "ic_user.png"),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: MyText(
                              color: white,
                              text: "guestuser",
                              multilanguage: true,
                              textalign: TextAlign.center,
                              fontsize: 18,
                              inter: true,
                              maxline: 2,
                              fontwaight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                              fontstyle: FontStyle.normal),
                        ),
                      ],
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 10),
            homeDrawerItem("ic_applanguage.png", "applanguage", () {
              changeLanguage(context);
            }),
            homeDrawerItem("ic_refand.png", "refundpolicy", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CommonPage(
                      title: "refundpolicy",
                      url: refundPolicyUrl ?? "",
                    );
                  },
                ),
              );
            }),
            homeDrawerItem("ic_tc.png", "termscondition", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CommonPage(
                      title: "termscondition",
                      url: termsConditionUrl ?? "",
                    );
                  },
                ),
              );
            }),
            homeDrawerItem("ic_privacy.png", "privacypolicy", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CommonPage(
                      title: "privacypolicy",
                      url: privacyUrl ?? "",
                    );
                  },
                ),
              );
            }),
            homeDrawerItem("ic_about.png", "aboutus", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CommonPage(
                      title: "aboutus",
                      url: aboutUsUrl ?? "",
                    );
                  },
                ),
              );
            }),
            Consumer<HomeProvider>(
              builder: (context, homeProvider, child) {
                return InkWell(
                  onTap: () {
                    if (userid.isEmpty || userid == "") {
                      Utils.openLogin(
                          context: context, isHome: true, isReplace: false);
                    } else {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25),
                          ),
                        ),
                        builder: (context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.25,
                            color: colorPrimary,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MyText(
                                  color: white,
                                  text: "youwanttologout",
                                  multilanguage: true,
                                  textalign: TextAlign.center,
                                  fontsize: 16,
                                  inter: true,
                                  maxline: 6,
                                  fontwaight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        // Firebase Signout
                                        await _auth.signOut();
                                        await GoogleSignIn().signOut();
                                        removeUseridFromLocal();
                                        await homeprovider.clearProvider();
                                        if (!mounted) return;
                                        getApi("1", "1");
                                        if (!mounted) return;
                                        Navigator.pop(context);
                                        Utils.openLogin(
                                            context: context,
                                            isHome: true,
                                            isReplace: true);
                                      },
                                      child: Container(
                                        width: 100,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          color: colorPrimary,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                        child: MyText(
                                          color: white,
                                          text: "yes",
                                          multilanguage: true,
                                          textalign: TextAlign.center,
                                          fontsize: 16,
                                          inter: true,
                                          maxline: 6,
                                          fontwaight: FontWeight.w600,
                                          overflow: TextOverflow.ellipsis,
                                          fontstyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 100,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          color: colorAccent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                        child: MyText(
                                          color: white,
                                          text: "no",
                                          multilanguage: true,
                                          textalign: TextAlign.center,
                                          fontsize: 16,
                                          inter: true,
                                          maxline: 6,
                                          fontwaight: FontWeight.w600,
                                          overflow: TextOverflow.ellipsis,
                                          fontstyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyImage(
                          width: 23,
                          height: 23,
                          imagePath: "ic_logout.png",
                        ),
                        const SizedBox(width: 15),
                        MyText(
                          color: white,
                          text: (userid.isEmpty || userid == "")
                              ? "login"
                              : "logout",
                          multilanguage: true,
                          textalign: TextAlign.start,
                          fontsize: 14,
                          inter: true,
                          maxline: 2,
                          fontwaight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Consumer<HomeProvider>(
              builder: (context, homeProvider, child) {
                if (userid.isNotEmpty || userid != "") {
                  return InkWell(
                    onTap: () {
                      if (userid.isNotEmpty || userid != "") {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),
                          builder: (context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.25,
                              color: colorPrimary,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  MyText(
                                    color: white,
                                    text: "youwantdeleteaccount",
                                    multilanguage: true,
                                    textalign: TextAlign.center,
                                    fontsize: 16,
                                    inter: true,
                                    maxline: 6,
                                    fontwaight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    fontstyle: FontStyle.normal,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          clearLocalData();
                                          final generalprovider =
                                              Provider.of<GeneralProvider>(
                                                  context,
                                                  listen: false);
                                          await generalprovider
                                              .getDeleteAccount(userid);
                                          if (!mounted) return;

                                          if (generalprovider.loading) {
                                            Utils().showProgress(
                                                context, "Deleted Account");
                                          } else {
                                            if (generalprovider
                                                    .deleteaccountModel
                                                    .status ==
                                                200) {
                                              Utils().showSnackbar(
                                                  context, "accountdelete");
                                              Utils().hideProgress(context);
                                            } else {
                                              Utils().showSnackbar(context,
                                                  "somethingWentWronge");
                                              Utils().hideProgress(context);
                                            }
                                          }

                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Bottombar()));
                                        },
                                        child: Container(
                                          width: 100,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            color: colorPrimary,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50)),
                                          ),
                                          child: MyText(
                                              color: white,
                                              text: "yes",
                                              multilanguage: true,
                                              textalign: TextAlign.center,
                                              fontsize: 16,
                                              inter: true,
                                              maxline: 6,
                                              fontwaight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis,
                                              fontstyle: FontStyle.normal),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: 100,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            color: colorAccent,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50)),
                                          ),
                                          child: MyText(
                                              color: white,
                                              text: "no",
                                              multilanguage: true,
                                              textalign: TextAlign.center,
                                              fontsize: 16,
                                              inter: true,
                                              maxline: 6,
                                              fontwaight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis,
                                              fontstyle: FontStyle.normal),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyImage(
                            width: 23,
                            height: 23,
                            imagePath: "ic_deleteaccount.png",
                          ),
                          const SizedBox(width: 15),
                          MyText(
                            color: white,
                            text: "deleteaccount",
                            multilanguage: true,
                            textalign: TextAlign.start,
                            fontsize: 14,
                            inter: true,
                            maxline: 2,
                            fontwaight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            fontstyle: FontStyle.normal,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget homeDrawerItem(String icon, String title, VoidCallback ontap) {
    return InkWell(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyImage(width: 23, height: 23, imagePath: icon),
            const SizedBox(width: 15),
            Expanded(
              child: MyText(
                color: white,
                text: title,
                multilanguage: true,
                textalign: TextAlign.start,
                fontsize: 14,
                inter: true,
                maxline: 2,
                fontwaight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
                fontstyle: FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeLanguage(context) {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        barrierColor: white.withAlpha(1),
        backgroundColor: transperent,
        builder: (BuildContext bc) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                padding: const EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.30,
                decoration: BoxDecoration(
                  color: colorPrimary,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                        color: colorAccent,
                        text: "chooselanguage",
                        multilanguage: true,
                        textalign: TextAlign.center,
                        fontsize: 16,
                        inter: true,
                        maxline: 6,
                        fontwaight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        LocaleNotifier.of(context)?.change('en');
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width * 0.30,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: MyText(
                            color: white,
                            text: "english",
                            textalign: TextAlign.center,
                            fontsize: 16,
                            multilanguage: true,
                            inter: true,
                            maxline: 6,
                            fontwaight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            fontstyle: FontStyle.normal),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        LocaleNotifier.of(context)?.change('ar');
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width * 0.30,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: MyText(
                            color: white,
                            text: "arabic",
                            textalign: TextAlign.center,
                            fontsize: 16,
                            inter: true,
                            maxline: 6,
                            multilanguage: true,
                            fontwaight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            fontstyle: FontStyle.normal),
                      ),
                    ),
                    InkWell(
                      focusColor: gray.withOpacity(0.40),
                      onTap: () {
                        LocaleNotifier.of(context)?.change('hi');
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width * 0.30,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: MyText(
                            color: white,
                            text: "hindi",
                            textalign: TextAlign.center,
                            fontsize: 16,
                            multilanguage: true,
                            inter: true,
                            maxline: 6,
                            fontwaight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            fontstyle: FontStyle.normal),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
            ],
          );
        });
  }

  Widget profileShimmer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: const CustomWidget.circular(
            height: 80,
            width: 80,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: const CustomWidget.roundrectborder(
            height: 15,
            width: 130,
          ),
        ),
        const CustomWidget.roundrectborder(
          height: 12,
          width: 100,
        ),
      ],
    );
  }

  Widget tabMenuItem(int index) {
    if (index == 0) {
      return firstitem();
    } else if (index == 1) {
      return secondItem();
    } else if (index == 2) {
      return threeItem();
    } else {
      return fouritem();
    }
  }

  alertdilog(BuildContext buildContext) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          insetPadding: const EdgeInsets.all(15),
          backgroundColor: colorPrimaryDark,
          child: Container(
            width: 300,
            height: 150,
            decoration: BoxDecoration(
                color: colorPrimaryDark,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: MyText(
                    color: white,
                    text: "Alert !!",
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 18,
                    fontwaight: FontWeight.w700,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: MyText(
                    color: white,
                    text: "Are you sure,do you want to Exit?",
                    fontsize: 16,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    fontwaight: FontWeight.w400,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        exit(0);
                      },
                      child: Container(
                        width: 120,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: colorAccent,
                            borderRadius: BorderRadius.circular(50)),
                        child: MyText(
                          color: black,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          text: "Yes",
                          fontsize: 14,
                          fontwaight: FontWeight.w600,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 120,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            // color: primary,
                            border: Border.all(color: white, width: 2),
                            borderRadius: BorderRadius.circular(50)),
                        child: MyText(
                          color: white,
                          text: "No",
                          overflow: TextOverflow.ellipsis,
                          fontsize: 14,
                          maxline: 1,
                          fontwaight: FontWeight.w600,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget firstitem() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      controller: scollController,
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          bannerwithItem(),
          const SizedBox(height: 20),
          horizontalList("yourlisteningschedule"),
          gridList("top20"),
          const SizedBox(height: 15),
          landscapList("newrealeses"),
        ],
      ),
    );
  }

  Widget secondItem() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          // const SizedBox(height: 20),
          bannerwithItem(),
          const SizedBox(height: 20),
          horizontalList("yourlisteningschedule"),
          gridList("top20"),
          const SizedBox(height: 15),
          landscapList("topstory"),
        ],
      ),
    );
  }

  Widget threeItem() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          bannerwithItem(),
          const SizedBox(height: 20),
          landscapListtopcourse("topcoure"),
          const SizedBox(height: 20),
          landscapList("editorpicks"),
        ],
      ),
    );
  }

  Widget fouritem() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          bannerwithItem(),
          const SizedBox(height: 20),
          gridList("top20fullbooks"),
          const SizedBox(height: 15),
          landscapList("topfullbooks"),
        ],
      ),
    );
  }

  Widget horizontalList(String title) {
    return Consumer<HomeProvider>(builder: (context, homeprovider, child) {
      if (homeprovider.loadingContinue) {
        return horizontalListShimmer();
      } else {
        if (homeprovider.continuewatchingModel.status == 200 &&
            (homeprovider.continuewatchingModel.result?.length ?? 0) > 0) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.31,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    MyImage(
                      width: 25,
                      height: 25,
                      imagePath: "ic_play.png",
                      color: colorAccent,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    MyText(
                        color: white,
                        text: title,
                        multilanguage: true,
                        textalign: TextAlign.center,
                        fontsize: 18,
                        inter: true,
                        maxline: 6,
                        fontwaight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        AdHelper.interstitialAd(context, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ContinueWatchingSeeall(
                                  title: title,
                                  userid: userid,
                                  ishomepage: "1",
                                  type: "1",
                                );
                              },
                            ),
                          );
                        });
                      },
                      child: MyText(
                          color: colorAccent,
                          text: "seeall",
                          multilanguage: true,
                          textalign: TextAlign.center,
                          fontsize: 12,
                          inter: true,
                          maxline: 6,
                          fontwaight: FontWeight.w400,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          homeprovider.continuewatchingModel.result?.length ??
                              0,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Detail(
                                    iscontinuewatching: true,
                                    audioname: homeprovider
                                            .continuewatchingModel
                                            .result?[index]
                                            .title
                                            .toString() ??
                                        "",
                                    audioid: homeprovider.continuewatchingModel
                                            .result?[index].id
                                            .toString() ??
                                        "",
                                    userid: userid,
                                    categoryid: homeprovider
                                            .continuewatchingModel
                                            .result?[index]
                                            .categoryId
                                            .toString() ??
                                        "",
                                  );
                                },
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(7, 0, 0, 7),
                            child: Stack(
                              children: [
                                Container(
                                  width: 120,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    color: divider,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: colorPrimaryDark,
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(7),
                                              bottomRight: Radius.circular(7),
                                              topLeft: Radius.circular(7),
                                              topRight: Radius.circular(7),
                                            ),
                                            child: MyNetworkImage(
                                              imageUrl: homeprovider
                                                      .continuewatchingModel
                                                      .result?[index]
                                                      .episode
                                                      ?.image
                                                      .toString() ??
                                                  "",
                                              fit: BoxFit.cover,
                                              imgWidth: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              imgHeight: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 15, 0),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            MyText(
                                              color: white,
                                              text: homeprovider
                                                      .continuewatchingModel
                                                      .result?[index]
                                                      .title
                                                      .toString() ??
                                                  "",
                                              textalign: TextAlign.center,
                                              fontsize: 11,
                                              inter: true,
                                              maxline: 1,
                                              fontwaight: FontWeight.w500,
                                              overflow: TextOverflow.ellipsis,
                                              fontstyle: FontStyle.normal,
                                            ),
                                            MyText(
                                              color: white,
                                              text: Utils.dateFormat(
                                                  homeprovider
                                                          .continuewatchingModel
                                                          .result?[0]
                                                          .createdAt
                                                          .toString() ??
                                                      "",
                                                  "dd MMMM yyyy"),
                                              textalign: TextAlign.center,
                                              fontsize: 10,
                                              inter: true,
                                              maxline: 1,
                                              fontwaight: FontWeight.w400,
                                              overflow: TextOverflow.ellipsis,
                                              fontstyle: FontStyle.normal,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                  color: divider,
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

  Widget horizontalListShimmer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.26,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          Row(
            children: [
              const CustomWidget.circular(
                height: 25,
                width: 25,
              ),
              const SizedBox(width: 10),
              CustomWidget.roundrectborder(
                height: 14,
                width: MediaQuery.of(context).size.width * 0.30,
              ),
              const Spacer(),
              CustomWidget.roundrectborder(
                height: 14,
                width: MediaQuery.of(context).size.width * 0.15,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerLeft,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(7, 0, 0, 7),
                    child: CustomWidget.roundrectborder(
                      height: MediaQuery.of(context).size.height,
                      width: 120,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget gridList(String title) {
    return Consumer<HomeProvider>(
      builder: (context, homeprovider, child) {
        if (homeprovider.loadingTopPlay) {
          return gridListShimmer();
        } else {
          if (homeprovider.topplayModel.status == 200 &&
              homeprovider.topplayModel.result != null) {
            if ((homeprovider.topplayModel.result?.length ?? 0) > 0) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        MyImage(
                          width: 25,
                          height: 25,
                          imagePath: "topindia.png",
                          color: colorAccent,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        MyText(
                            color: white,
                            text: title,
                            multilanguage: true,
                            textalign: TextAlign.center,
                            fontsize: 18,
                            inter: true,
                            maxline: 6,
                            fontwaight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                            fontstyle: FontStyle.normal),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            AdHelper.interstitialAd(context, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return GridListSeeall(
                                      title: title,
                                      userid: userid,
                                      ishomepage: pagePosition == 0 ? "1" : "2",
                                      type: pagePosition == 0
                                          ? "1"
                                          : pagePosition.toString(),
                                    );
                                  },
                                ),
                              );
                            });
                          },
                          child: MyText(
                              color: colorAccent,
                              text: "seeall",
                              multilanguage: true,
                              textalign: TextAlign.center,
                              fontsize: 12,
                              inter: true,
                              maxline: 6,
                              fontwaight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontstyle: FontStyle.normal),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount:
                              homeprovider.topplayModel.result?.length ?? 0,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 5 / 6,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          itemBuilder: (BuildContext ctx, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return Detail(
                                        audioname: homeprovider.topplayModel
                                                .result?[index].title
                                                .toString() ??
                                            "",
                                        audioid: homeprovider
                                                .topplayModel.result?[index].id
                                                .toString() ??
                                            "",
                                        userid: userid,
                                        categoryid: homeprovider.topplayModel
                                                .result?[index].categoryId
                                                .toString() ??
                                            "",
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  RotationTransition(
                                    alignment: Alignment.bottomCenter,
                                    turns:
                                        const AlwaysStoppedAnimation(10 / 360),
                                    child: Container(
                                      width: 120,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.17,
                                      margin: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        color: colorPrimary,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(7),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Stack(
                                        alignment: Alignment.bottomLeft,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            child: MyNetworkImage(
                                              imgWidth: 120,
                                              imgHeight: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.20,
                                              fit: BoxFit.cover,
                                              imageUrl: homeprovider
                                                      .topplayModel
                                                      .result?[index]
                                                      .image
                                                      .toString() ??
                                                  "",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    right: 20,
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Stack(
                                        alignment: Alignment.bottomLeft,
                                        children: [
                                          Text(
                                            "${index + 1}",
                                            style: TextStyle(
                                              fontSize: 70,
                                              letterSpacing: 5,
                                              // fontWeight: FontWeight.bold,
                                              foreground: Paint()
                                                ..style = PaintingStyle.stroke
                                                ..strokeWidth = 2
                                                ..color = lightpurpole,
                                            ),
                                          ),
                                          Text(
                                            "${index + 1}",
                                            style: const TextStyle(
                                              fontSize: 70,
                                              // fontWeight: FontWeight.bold,
                                              color: colorPrimaryDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget gridListShimmer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              const CustomWidget.circular(
                height: 25,
                width: 25,
              ),
              const SizedBox(width: 10),
              CustomWidget.roundrectborder(
                height: 14,
                width: MediaQuery.of(context).size.width * 0.30,
              ),
              const Spacer(),
              CustomWidget.roundrectborder(
                height: 14,
                width: MediaQuery.of(context).size.width * 0.15,
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 5 / 6,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemBuilder: (BuildContext ctx, index) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      RotationTransition(
                        alignment: Alignment.bottomCenter,
                        turns: const AlwaysStoppedAnimation(10 / 360),
                        child: Container(
                          width: 120,
                          height: MediaQuery.of(context).size.height * 0.17,
                          margin: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              CustomWidget.roundrectborder(
                                width: 120,
                                height:
                                    MediaQuery.of(context).size.height * 0.20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned.fill(
                        right: 20,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Text(
                                "${index + 1}",
                                style: TextStyle(
                                  fontSize: 70,
                                  letterSpacing: 5,
                                  // fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 2
                                    ..color = gray.withOpacity(0.40),
                                ),
                              ),
                              Text(
                                "${index + 1}",
                                style: TextStyle(
                                  fontSize: 70,
                                  // fontWeight: FontWeight.bold,
                                  color: gray.withOpacity(0.40),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget landscapListtopcourse(String title) {
    return Consumer<HomeProvider>(builder: (context, homeprovider, child) {
      if (homeprovider.loadingTopPlay) {
        return landscapListShimmer();
      } else {
        if (homeprovider.topplayModel.status == 200 &&
            (homeprovider.topplayModel.result?.length ?? 0) > 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    MyImage(
                      width: 25,
                      height: 25,
                      imagePath: "topindia.png",
                      color: colorAccent,
                    ),
                    const SizedBox(width: 10),
                    MyText(
                        color: white,
                        text: title,
                        textalign: TextAlign.center,
                        fontsize: 18,
                        inter: true,
                        maxline: 6,
                        multilanguage: true,
                        fontwaight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        AdHelper.interstitialAd(context, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LandScapSeeall(
                                  subtype: "1",
                                  title: title,
                                  userid: userid,
                                  ishomepage: pagePosition == 0 ? "1" : "2",
                                  type: pagePosition == 0
                                      ? "1"
                                      : pagePosition.toString(),
                                );
                              },
                            ),
                          );
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: MyText(
                            color: colorAccent,
                            text: "seeall",
                            multilanguage: true,
                            textalign: TextAlign.center,
                            fontsize: 12,
                            inter: true,
                            maxline: 6,
                            fontwaight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis,
                            fontstyle: FontStyle.normal),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: homeprovider.topplayModel.result?.length ?? 0,
                      itemBuilder: (BuildContext ctx, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Detail(
                                    audioname: homeprovider
                                            .topplayModel.result?[index].title
                                            .toString() ??
                                        "",
                                    audioid: homeprovider
                                            .topplayModel.result?[index].id
                                            .toString() ??
                                        "",
                                    userid: userid,
                                    categoryid: homeprovider.topplayModel
                                            .result?[index].categoryId
                                            .toString() ??
                                        "",
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.14,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: MyNetworkImage(
                                      imgWidth: 110,
                                      fit: BoxFit.cover,
                                      imgHeight:
                                          MediaQuery.of(context).size.height,
                                      imageUrl: homeprovider
                                              .topplayModel.result?[index].image
                                              .toString() ??
                                          "",
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        MyText(
                                            color: white,
                                            text: homeprovider.topplayModel
                                                    .result?[index].title
                                                    .toString() ??
                                                "",
                                            fontsize: 14,
                                            inter: true,
                                            fontwaight: FontWeight.w500,
                                            maxline: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textalign: TextAlign.left,
                                            fontstyle: FontStyle.normal),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            MyImage(
                                                width: 15,
                                                height: 15,
                                                imagePath: "play.png"),
                                            const SizedBox(width: 10),
                                            MyText(
                                                color: gray,
                                                text: Numeral(int.parse(
                                                  homeprovider.topplayModel
                                                          .result?[index].played
                                                          .toString() ??
                                                      "",
                                                )).format(),
                                                fontsize: 12,
                                                inter: true,
                                                fontwaight: FontWeight.w500,
                                                maxline: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textalign: TextAlign.center,
                                                fontstyle: FontStyle.normal),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        MyText(
                                            color: white,
                                            text: homeprovider.topplayModel
                                                    .result?[index].description
                                                    .toString() ??
                                                "",
                                            fontsize: 10,
                                            inter: true,
                                            fontwaight: FontWeight.w400,
                                            maxline: 3,
                                            overflow: TextOverflow.ellipsis,
                                            textalign: TextAlign.left,
                                            fontstyle: FontStyle.normal),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 60,
                                    height: 25,
                                    margin: const EdgeInsets.only(top: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: yellow),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        MyImage(
                                            width: 10,
                                            height: 10,
                                            imagePath: "ic_star.png"),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02,
                                        ),
                                        MyText(
                                            color: black,
                                            text: homeprovider.topplayModel
                                                    .result?[index].rating
                                                    .toString() ??
                                                "",
                                            textalign: TextAlign.center,
                                            fontsize: 12,
                                            inter: true,
                                            maxline: 6,
                                            fontwaight: FontWeight.w600,
                                            overflow: TextOverflow.ellipsis,
                                            fontstyle: FontStyle.normal),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        );
                      }),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

  Widget landscapList(String title) {
    return Consumer<HomeProvider>(
      builder: (context, homeprovider, child) {
        if (homeprovider.loadingNew) {
          return landscapListShimmer();
        } else {
          if (homeprovider.newreleaseModel.status == 200 &&
              (homeprovider.newreleaseModel.result?.length ?? 0) > 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      MyImage(
                        width: 25,
                        height: 25,
                        imagePath: "topindia.png",
                        color: colorAccent,
                      ),
                      const SizedBox(width: 10),
                      MyText(
                          color: white,
                          multilanguage: true,
                          text: title,
                          textalign: TextAlign.center,
                          fontsize: 18,
                          inter: true,
                          maxline: 6,
                          fontwaight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          AdHelper.interstitialAd(context, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return LandScapSeeall(
                                    subtype: "0",
                                    title: title,
                                    ishomepage: pagePosition == 0 ? "1" : "2",
                                    type: pagePosition == 0
                                        ? "1"
                                        : pagePosition.toString(),
                                    userid: userid,
                                  );
                                },
                              ),
                            );
                          });
                        },
                        child: MyText(
                            color: colorAccent,
                            text: "seeall",
                            textalign: TextAlign.center,
                            fontsize: 12,
                            inter: true,
                            multilanguage: true,
                            maxline: 6,
                            fontwaight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis,
                            fontstyle: FontStyle.normal),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount:
                          homeprovider.newreleaseModel.result?.length ?? 0,
                      itemBuilder: (BuildContext ctx, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Detail(
                                    audioname: homeprovider.newreleaseModel
                                            .result?[index].title
                                            .toString() ??
                                        "",
                                    audioid: homeprovider
                                            .newreleaseModel.result?[index].id
                                            .toString() ??
                                        "",
                                    userid: userid,
                                    categoryid: homeprovider.newreleaseModel
                                            .result?[index].categoryId
                                            .toString() ??
                                        "",
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.14,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: MyNetworkImage(
                                      imgWidth: 110,
                                      fit: BoxFit.cover,
                                      imgHeight:
                                          MediaQuery.of(context).size.height,
                                      imageUrl: homeprovider.newreleaseModel
                                              .result?[index].image
                                              .toString() ??
                                          ""),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      MyText(
                                          color: white,
                                          text: homeprovider.newreleaseModel
                                                  .result?[index].title
                                                  .toString() ??
                                              "",
                                          fontsize: 14,
                                          inter: true,
                                          fontwaight: FontWeight.w500,
                                          maxline: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textalign: TextAlign.left,
                                          fontstyle: FontStyle.normal),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          MyImage(
                                              width: 15,
                                              height: 15,
                                              imagePath: "play.png"),
                                          const SizedBox(width: 10),
                                          MyText(
                                              color: gray,
                                              text: Utils.kmbGenerator(
                                                  int.parse(homeprovider
                                                          .newreleaseModel
                                                          .result?[index]
                                                          .played
                                                          .toString() ??
                                                      "")),
                                              fontsize: 12,
                                              inter: true,
                                              fontwaight: FontWeight.w500,
                                              maxline: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textalign: TextAlign.center,
                                              fontstyle: FontStyle.normal),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      MyText(
                                          color: white,
                                          text: homeprovider.newreleaseModel
                                                  .result?[index].description
                                                  .toString() ??
                                              "",
                                          fontsize: 10,
                                          inter: true,
                                          fontwaight: FontWeight.w400,
                                          maxline: 3,
                                          overflow: TextOverflow.ellipsis,
                                          textalign: TextAlign.left,
                                          fontstyle: FontStyle.normal),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 60,
                                  height: 25,
                                  margin: const EdgeInsets.only(top: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: yellow),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      MyImage(
                                          width: 10,
                                          height: 10,
                                          imagePath: "ic_star.png"),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      SizedBox(
                                        width: 30,
                                        child: MyText(
                                            color: black,
                                            text: homeprovider.newreleaseModel
                                                    .result?[index].rating
                                                    ?.toString() ??
                                                "",
                                            textalign: TextAlign.center,
                                            fontsize: 12,
                                            inter: true,
                                            maxline: 1,
                                            fontwaight: FontWeight.w600,
                                            overflow: TextOverflow.ellipsis,
                                            fontstyle: FontStyle.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget landscapListShimmer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CustomWidget.circular(
                height: 30,
                width: 30,
              ),
              const SizedBox(width: 10),
              CustomWidget.roundrectborder(
                height: 14,
                width: MediaQuery.of(context).size.width * 0.30,
              ),
              const Spacer(),
              CustomWidget.roundrectborder(
                height: 14,
                width: MediaQuery.of(context).size.width * 0.15,
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (BuildContext ctx, index) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.14,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: CustomWidget.roundrectborder(
                          width: 110,
                          height: MediaQuery.of(context).size.height,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomWidget.roundrectborder(
                              width: MediaQuery.of(context).size.width * 0.30,
                              height: 10,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const CustomWidget.roundrectborder(
                                  width: 15,
                                  height: 15,
                                ),
                                const SizedBox(width: 10),
                                CustomWidget.roundrectborder(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  height: 10,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            CustomWidget.roundrectborder(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      CustomWidget.roundcorner(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: 20,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget bannerwithItem() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* first Banner List */
            Consumer<HomeProvider>(
              builder: (context, homeprovider, child) {
                if (homeprovider.loadingBanner) {
                  return bannerwithItemshimmer();
                } else {
                  if (homeprovider.bannerModel.status == 200 &&
                      (homeprovider.bannerModel.result?.length ?? 0) > 0) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.42,
                            child: CarouselSlider(
                              items: homeprovider.bannerModel.result
                                  ?.map(
                                    (bannerlist) => Builder(
                                      builder: (BuildContext context) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return Detail(
                                                      audioname: bannerlist
                                                          .title
                                                          .toString(),
                                                      audioid: bannerlist.id
                                                          .toString(),
                                                      userid: userid,
                                                      categoryid: bannerlist
                                                          .categoryId
                                                          .toString());
                                                },
                                              ),
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomRight: Radius.circular(35),
                                            ),
                                            child: MyNetworkImage(
                                                imgWidth: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                imgHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.6,
                                                fit: BoxFit.cover,
                                                imageUrl: bannerlist.image
                                                    .toString()),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                  .toList(),
                              carouselController: controller,
                              options: CarouselOptions(
                                height:
                                    MediaQuery.of(context).size.height * 0.72,
                                viewportFraction: 1,
                                autoPlay: true,
                                scrollDirection: Axis.horizontal,
                                autoPlayAnimationDuration:
                                    const Duration(seconds: 3),
                                autoPlayInterval: const Duration(seconds: 4),
                                onPageChanged: (index, reason) {
                                  bannerPosition = index;
                                  homeprovider.getChangeIndicater(index);
                                },
                              ),
                            ),
                          ),
                          /*Animated CircleIndicater Indicater*/
                          Positioned.fill(
                            bottom: 35,
                            right: 20,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: AnimatedSmoothIndicator(
                                activeIndex: homeprovider.ind,
                                count:
                                    homeprovider.bannerModel.result?.length ??
                                        0,
                                effect: const ExpandingDotsEffect(
                                    dotHeight: 8,
                                    dotWidth: 8,
                                    dotColor: gray,
                                    expansionFactor: 3,
                                    offset: 1,
                                    strokeWidth: 1,
                                    activeDotColor: yellow),
                              ),
                            ),
                          ),
                          /* Play Button */

                          Positioned.fill(
                            right: 25,
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Detail(
                                          audioname: homeprovider.bannerModel
                                                  .result?[bannerPosition].title
                                                  .toString() ??
                                              "",
                                          audioid: homeprovider.bannerModel
                                                  .result?[bannerPosition].id
                                                  .toString() ??
                                              "",
                                          userid: userid,
                                          categoryid: homeprovider
                                                  .bannerModel
                                                  .result?[bannerPosition]
                                                  .categoryId
                                                  .toString() ??
                                              "",
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 120,
                                  height: 45,
                                  decoration: const BoxDecoration(
                                    color: colorAccent,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(50),
                                      bottomRight: Radius.circular(50),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      MyImage(
                                          width: 25,
                                          height: 25,
                                          imagePath: "ic_play.png"),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      MyText(
                                          color: white,
                                          text: "playnow",
                                          multilanguage: true,
                                          textalign: TextAlign.center,
                                          fontsize: 14,
                                          inter: true,
                                          fontwaight: FontWeight.w600,
                                          overflow: TextOverflow.ellipsis,
                                          fontstyle: FontStyle.normal),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.45,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyImage(
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: MediaQuery.of(context).size.width * 0.50,
                            fit: BoxFit.contain,
                            imagePath: "nodata.png",
                          ),
                          MyText(
                              color: white,
                              text: "bannerimageempty",
                              textalign: TextAlign.center,
                              fontsize: 14,
                              multilanguage: true,
                              inter: true,
                              fontwaight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                              fontstyle: FontStyle.normal),
                        ],
                      ),
                    );
                  }
                }
              },
            ),
            geners(),
            const SizedBox(height: 10),
            pagePosition != Constant().tabmenuList.length - 1
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: 2,
                    color: divider,
                  )
                : const SizedBox.shrink(),
          ],
        ),
        /* Language Searchbar and Setting with TabBar*/
      ],
    );
  }

  Widget bannerwithItemshimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* first Banner List */
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.45,
          child: Stack(
            children: [
              CustomWidget.bottomrightcorner(
                height: MediaQuery.of(context).size.height * 0.42,
              ),
              /*Animated CircleIndicater Indicater*/
              Positioned.fill(
                bottom: 35,
                right: 20,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: AnimatedSmoothIndicator(
                    activeIndex: currentIndex,
                    axisDirection: Axis.horizontal,
                    count: 5,
                    effect: const ExpandingDotsEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        expansionFactor: 4,
                        offset: 1,
                        strokeWidth: 1,
                        dotColor: gray,
                        activeDotColor: white),
                  ),
                ),
              ),
              /* Play Button */
              Positioned.fill(
                right: 25,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      width: 140,
                      height: 45,
                      decoration: const BoxDecoration(
                        color: colorAccent,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyImage(
                              width: 25, height: 25, imagePath: "ic_play.png"),
                          const SizedBox(
                            width: 7,
                          ),
                          MyText(
                              color: white,
                              text: "Play Now",
                              textalign: TextAlign.center,
                              fontsize: 14,
                              inter: true,
                              fontwaight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                              fontstyle: FontStyle.normal),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        genersShimmer(),
        pagePosition != Constant().tabmenuList.length - 1
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: 2,
                color: white,
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget geners() {
    return Consumer<HomeProvider>(builder: (context, homeprovider, child) {
      if (homeprovider.loadingCategory) {
        return genersShimmer();
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
              child: Row(
                children: [
                  MyText(
                      color: white,
                      text: "categories",
                      textalign: TextAlign.center,
                      fontsize: 18,
                      multilanguage: true,
                      inter: true,
                      maxline: 6,
                      fontwaight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                      fontstyle: FontStyle.normal),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      AdHelper.interstitialAd(context, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CategorySeeAll(
                                userid: userid,
                              );
                            },
                          ),
                        );
                      });
                    },
                    child: MyText(
                        color: colorAccent,
                        text: "seeall",
                        multilanguage: true,
                        textalign: TextAlign.center,
                        fontsize: 12,
                        inter: true,
                        maxline: 6,
                        fontwaight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.34,
              alignment: Alignment.centerLeft,
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                scrollDirection: Axis.horizontal,
                itemCount: homeprovider.categoryModel.result?.length ?? 0,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AudiobyCategory(
                              categoryid: homeprovider
                                      .categoryModel.result?[index].id
                                      .toString() ??
                                  "",
                              userid: userid,
                            );
                          },
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: MyNetworkImage(
                              imgWidth: 65,
                              imgHeight: 65,
                              fit: BoxFit.cover,
                              imageUrl: homeprovider
                                      .categoryModel.result?[index].image
                                      .toString() ??
                                  ""),
                        ),
                        const SizedBox(height: 10),
                        MyText(
                          color: white,
                          textalign: TextAlign.left,
                          fontsize: 12,
                          inter: true,
                          maxline: 2,
                          fontwaight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal,
                          text: homeprovider.categoryModel.result?[index].name
                                  .toString() ??
                              "",
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }
    });
  }

  Widget genersShimmer() {
    return Consumer<HomeProvider>(builder: (context, homeprovider, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
            child: Row(
              children: [
                const CustomWidget.circular(
                  height: 30,
                  width: 30,
                ),
                const SizedBox(width: 10),
                CustomWidget.roundrectborder(
                  height: 14,
                  width: MediaQuery.of(context).size.width * 0.30,
                ),
                const Spacer(),
                CustomWidget.roundrectborder(
                  height: 14,
                  width: MediaQuery.of(context).size.width * 0.15,
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.34,
            alignment: Alignment.centerLeft,
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4 / 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CustomWidget.circular(
                      width: 65,
                      height: 65,
                    ),
                    CustomWidget.roundrectborder(
                      height: 10,
                      width: 80,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      );
    });
  }

  exitDilog(BuildContext buildContext) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 16,
          // shape: ,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.28,
            decoration: BoxDecoration(
                color: colorPrimary, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyImage(
                  width: 90,
                  height: 90,
                  imagePath: "ic_appicon.png",
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 15),
                MyText(
                  color: white,
                  text: "areyousurewanttoexit",
                  maxline: 1,
                  multilanguage: true,
                  fontwaight: FontWeight.w500,
                  fontsize: 16,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        exit(0);
                      },
                      child: Container(
                        width: 100,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: colorAccent,
                            borderRadius: BorderRadius.circular(50)),
                        child: MyText(
                          color: white,
                          text: "done",
                          multilanguage: true,
                          maxline: 1,
                          fontwaight: FontWeight.w500,
                          fontsize: 14,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 100,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: colorAccent,
                            borderRadius: BorderRadius.circular(50)),
                        child: MyText(
                          color: white,
                          text: "cancel",
                          multilanguage: true,
                          maxline: 1,
                          fontwaight: FontWeight.w500,
                          fontsize: 14,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  removeUseridFromLocal() async {
    await sharedpre.remove("userid");
    await sharedpre.remove("username");
    await sharedpre.remove("userfullname");
    await sharedpre.remove("useremail");
    await sharedpre.remove("usermobile");
    await sharedpre.remove("usertype");
    await sharedpre.remove("userbio");
    await sharedpre.remove("userimage");
  }

  clearLocalData() async {
    await sharedpre.clear();
  }
}
