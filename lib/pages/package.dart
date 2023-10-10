import 'package:dtpocketfm/model/premiummodel.dart';
import 'package:dtpocketfm/pages/allpayment.dart';
import 'package:dtpocketfm/pages/bottombar.dart';
import 'package:dtpocketfm/provider/premiumprovider.dart';
import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/constant.dart';
import 'package:dtpocketfm/utils/customwidget.dart';
import 'package:dtpocketfm/utils/sharedpre.dart';
import 'package:dtpocketfm/utils/utils.dart';
import 'package:dtpocketfm/widget/myimage.dart';
import 'package:dtpocketfm/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

class Package extends StatefulWidget {
  final String userid;
  const Package({
    super.key,
    required this.userid,
  });

  @override
  State<Package> createState() => _PremiumState();
}

class _PremiumState extends State<Package> with TickerProviderStateMixin {
  SharedPre sharedpre = SharedPre();
  var scrollController = ScrollController();
  late PremiumProvider premiumprovider;

  late ProgressDialog prDialog;
  TabController? tabController;
  TabController? shimmertabController;

  int ind = 0;
  String? username, number, email;
  String packageid = "",
      price = "",
      currencycode = "",
      currency = "",
      discription = "";

  @override
  void initState() {
    super.initState();
    premiumprovider = Provider.of<PremiumProvider>(context, listen: false);
    prDialog = ProgressDialog(context);
    _getdata();
    _getApi();
  }

  @override
  void dispose() {
    super.dispose();
    tabController?.dispose();
  }

  _getdata() async {
    username = await sharedpre.read("fullname") ?? "";
    email = await sharedpre.read("useremail") ?? "";
    number = await sharedpre.read("usermobile") ?? "";
    currency = await sharedpre.read("currency") ?? "";
    debugPrint("curency=> $currency");
    debugPrint("username=> $username");
  }

  _getApi() async {
    Utils().getCurrencySymbol();
    await premiumprovider.getPackage(widget.userid);
    shimmertabController = TabController(length: 3, vsync: this);
    tabController = TabController(
        length: premiumprovider.premiumModel.result?.length ?? 0, vsync: this);
  }

  _checkAndPay(List<Result>? packageList, int index) async {
    if (widget.userid.isNotEmpty || widget.userid.toString() != "") {
      for (var i = 0; i < (packageList?.length ?? 0); i++) {
        if (packageList?[i].isBuy == 1) {
          debugPrint("<============= Purchaged =============>");
          Utils.showSnackbarNew(context, "info", "already_purchased", true);
          return;
        }
      }
      if (packageList?[index].isBuy == 0) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AllPayment(
                payType: 'Package',
                itemId: packageList?[index].id.toString() ?? '',
                price: packageList?[index].price.toString() ?? '',
                itemTitle: packageList?[index].name.toString() ?? '',
                productPackage: '',
                currency: '',
              );
            },
          ),
        );
      }
    } else {
      Utils.openLogin(context: context, isHome: false, isReplace: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Premium Image (Static)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.40,
                  alignment: Alignment.center,
                  foregroundDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorPrimaryDark.withOpacity(0.1),
                        colorPrimaryDark.withOpacity(1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: MyImage(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      fit: BoxFit.cover,
                      imagePath: "ic_introbg.png"),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyImage(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.25,
                        imagePath: "ic_premium.png"),
                    MyText(
                      color: white,
                      text: "freehdaudiodownload",
                      multilanguage: true,
                      textalign: TextAlign.center,
                      fontsize: 18,
                      inter: true,
                      maxline: 2,
                      fontwaight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                      fontstyle: FontStyle.normal,
                    ),
                    MyText(
                      color: white,
                      text: "fiftypercentoff",
                      textalign: TextAlign.center,
                      fontsize: 18,
                      multilanguage: true,
                      inter: true,
                      maxline: 2,
                      fontwaight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                      fontstyle: FontStyle.normal,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Positioned.fill(
                  top: 50,
                  left: 15,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        focusColor: white.withOpacity(0.40),
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: MyImage(
                              width: 18, height: 18, imagePath: "ic_back.png"),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Consumer<PremiumProvider>(
              builder: (context, premiumprovider, child) {
                if (premiumprovider.loading) {
                  return premiumShimmer();
                } else {
                  if (premiumprovider.premiumModel.status == 200 &&
                      (premiumprovider.premiumModel.result?.length ?? 0) > 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TabBar(
                          indicatorColor: colorAccent,
                          isScrollable: true,
                          unselectedLabelColor: gray,
                          labelPadding:
                              const EdgeInsets.only(left: 15, right: 15),
                          physics: const AlwaysScrollableScrollPhysics(),
                          indicator: const UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 1,
                              color: colorAccent,
                            ),
                          ),
                          labelStyle: GoogleFonts.inter(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            color: colorAccent,
                            fontWeight: FontWeight.w500,
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          padding: const EdgeInsets.all(0),
                          labelColor: colorAccent,
                          indicatorPadding:
                              const EdgeInsets.only(left: 15, right: 10),
                          controller: tabController,
                          tabs: List<Widget>.generate(
                              premiumprovider.premiumModel.result?.length ?? 0,
                              (ind) {
                            return Tab(
                                child: Text(premiumprovider
                                        .premiumModel.result?[ind].name
                                        .toString() ??
                                    ""));
                          }),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.55,
                          child: TabBarView(
                            controller: tabController,
                            physics: const BouncingScrollPhysics(),
                            children: List<Widget>.generate(
                              premiumprovider.premiumModel.result?.length ?? 0,
                              (ind) {
                                return SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.18,
                                        alignment: Alignment.center,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            MyImage(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.60,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                imagePath: "ic_halfround.png"),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                MyText(
                                                    color: colorAccent,
                                                    text:
                                                        "${Constant.currencySymbol.toString()} ${premiumprovider.premiumModel.result?[ind].price.toString() ?? ""}",
                                                    textalign: TextAlign.center,
                                                    fontsize: 24,
                                                    inter: true,
                                                    maxline: 6,
                                                    fontwaight: FontWeight.w600,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontstyle:
                                                        FontStyle.normal),
                                                const SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    MyText(
                                                        color: lightblue,
                                                        text: "per",
                                                        textalign:
                                                            TextAlign.center,
                                                        fontsize: 12,
                                                        inter: true,
                                                        maxline: 6,
                                                        multilanguage: true,
                                                        fontwaight:
                                                            FontWeight.w600,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontstyle:
                                                            FontStyle.normal),
                                                    const SizedBox(width: 3),
                                                    MyText(
                                                        color: lightblue,
                                                        text: premiumprovider
                                                                .premiumModel
                                                                .result?[ind]
                                                                .type
                                                                .toString() ??
                                                            "",
                                                        textalign:
                                                            TextAlign.center,
                                                        fontsize: 12,
                                                        inter: true,
                                                        maxline: 6,
                                                        fontwaight:
                                                            FontWeight.w600,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontstyle:
                                                            FontStyle.normal),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      packageItem(
                                          "ic_audio.png", "freehdqulityaudio"),
                                      const SizedBox(height: 15),
                                      packageItem("ic_downloadAudio.png",
                                          "freeunlimiteddownload"),
                                      const SizedBox(height: 15),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            15, 0, 15, 0),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(9),
                                          onTap: () {
                                            _checkAndPay(
                                                premiumprovider
                                                    .premiumModel.result,
                                                ind);
                                          },
                                          child: _buildPayBtn(
                                            price: premiumprovider.premiumModel
                                                    .result?[ind].price
                                                    .toString() ??
                                                "",
                                            isBuy: premiumprovider.premiumModel
                                                    .result?[ind].isBuy ??
                                                0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.40,
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyImage(
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: MediaQuery.of(context).size.height * 0.25,
                            fit: BoxFit.contain,
                            imagePath: "nodata.png",
                          ),
                          MyText(
                              color: white,
                              text: "packageisempty",
                              textalign: TextAlign.center,
                              multilanguage: true,
                              fontsize: 14,
                              inter: true,
                              maxline: 6,
                              fontwaight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                              fontstyle: FontStyle.normal),
                        ],
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget premiumShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Row(
            children: const [
              CustomWidget.roundrectborder(
                width: 70,
                height: 20,
              ),
              SizedBox(width: 15),
              CustomWidget.roundrectborder(
                width: 70,
                height: 20,
              ),
              SizedBox(width: 15),
              CustomWidget.roundrectborder(
                width: 70,
                height: 20,
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.18,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      MyImage(
                          width: MediaQuery.of(context).size.width * 0.60,
                          height: MediaQuery.of(context).size.height,
                          color: gray.withOpacity(0.40),
                          imagePath: "ic_halfround.png"),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CustomWidget.roundrectborder(
                            width: 80,
                            height: 15,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CustomWidget.roundrectborder(
                                width: 40,
                                height: 15,
                              ),
                              SizedBox(width: 3),
                              CustomWidget.roundrectborder(
                                width: 50,
                                height: 15,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: CustomWidget.roundrectborder(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: CustomWidget.roundrectborder(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: CustomWidget.roundcorner(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.06,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget packageItem(String imagepath, String label) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        color: colorPrimary,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: divider, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 35,
            height: 35,
            alignment: Alignment.center,
            decoration:
                const BoxDecoration(color: purpole, shape: BoxShape.circle),
            child: MyImage(width: 20, height: 20, imagePath: imagepath),
          ),
          const SizedBox(width: 10),
          MyText(
              color: white,
              multilanguage: true,
              text: label,
              textalign: TextAlign.center,
              fontsize: 14,
              inter: false,
              maxline: 6,
              fontwaight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
              fontstyle: FontStyle.normal),
        ],
      ),
    );
  }

  Widget _buildPayBtn({required String price, required int isBuy}) {
    if (isBuy == 1) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          gradient: LinearGradient(
            colors: [
              colorAccent.withOpacity(0.6),
              yellow.withOpacity(1),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: MyText(
          color: white,
          text: "current",
          multilanguage: true,
          textalign: TextAlign.center,
          fontsize: 16,
          inter: true,
          maxline: 6,
          fontwaight: FontWeight.w600,
          overflow: TextOverflow.ellipsis,
          fontstyle: FontStyle.normal,
        ),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(9)),
          gradient: LinearGradient(
            colors: [
              colorAccent.withOpacity(0.6),
              yellow.withOpacity(1),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: Constant.currencySymbol.toString(),
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      color: white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: " $price",
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                          color: white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            MyText(
              color: white,
              text: "buynow",
              multilanguage: true,
              textalign: TextAlign.center,
              fontsize: 16,
              inter: true,
              maxline: 6,
              fontwaight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
              fontstyle: FontStyle.normal,
            ),
          ],
        ),
      );
    }
  }

  void failDilog(
      BuildContext context, String title, String message, String paymementId) {
    Widget continueButton = ElevatedButton(
      child: MyText(
          color: white,
          multilanguage: true,
          text: "retry",
          textalign: TextAlign.center,
          fontsize: 14,
          inter: false,
          maxline: 6,
          fontwaight: FontWeight.w600,
          overflow: TextOverflow.ellipsis,
          fontstyle: FontStyle.normal),
      onPressed: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const Bottombar();
            },
          ),
        );
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    Widget continueButton = ElevatedButton(
      child: MyText(
          color: white,
          multilanguage: true,
          text: "continue",
          textalign: TextAlign.center,
          fontsize: 14,
          inter: false,
          maxline: 6,
          fontwaight: FontWeight.w600,
          overflow: TextOverflow.ellipsis,
          fontstyle: FontStyle.normal),
      onPressed: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const Bottombar();
            },
          ),
        );
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
