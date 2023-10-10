import 'package:dtpocketfm/pages/bottombar.dart';
import 'package:dtpocketfm/pages/detail.dart';
import 'package:dtpocketfm/pages/nodata.dart';
import 'package:dtpocketfm/pages/package.dart';
import 'package:dtpocketfm/provider/premiumaudioprovider.dart';
import 'package:dtpocketfm/utils/adhelper.dart';
import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/customwidget.dart';
import 'package:dtpocketfm/utils/utils.dart';
import 'package:dtpocketfm/widget/myimage.dart';
import 'package:dtpocketfm/widget/mynetworkimg.dart';
import 'package:dtpocketfm/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../model/premiumaudiomodel.dart';

class PrimiumAudio extends StatefulWidget {
  final String userid;
  const PrimiumAudio({super.key, required this.userid});

  @override
  State<PrimiumAudio> createState() => _PrimiumAudioState();
}

class _PrimiumAudioState extends State<PrimiumAudio> {
  late PagewiseLoadController<Result> _pageLoadController;
  int pageno = 1;

  @override
  initState() {
    super.initState();
    MobileAds.instance.initialize();
    getApi();
  }

  getApi() async {
    _pageLoadController =
        PagewiseLoadController(pageSize: 10, pageFuture: fetchNewData);

    AdHelper.createRewardedAd();
  }

  Future<List<Result>> fetchNewData(int? nextPage) async {
    final primiumaudioprovider =
        Provider.of<PremiumaudioProvider>(context, listen: false);
    pageno = (nextPage ?? 0) + 1;
    debugPrint("Pageno =>$pageno");
    await primiumaudioprovider.getPremiumAudio("1", "1", pageno.toString());
    return primiumaudioprovider.premiumaudioModel.result ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorPrimaryDark,
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: colorPrimaryDark,
          ),
          backgroundColor: colorPrimaryDark,
          title: MyText(
            color: white,
            multilanguage: true,
            text: "premiumaudio",
            fontsize: 16,
            fontwaight: FontWeight.w500,
            maxline: 1,
            overflow: TextOverflow.ellipsis,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
            inter: true,
          ),
        ),
        body: fullbook());
  }

  Widget fullbook() {
    return Column(
      children: [
        banner(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Expanded(child: landscapList()),
        ValueListenableBuilder(
          valueListenable: currentlyPlaying,
          builder:
              (BuildContext context, AudioPlayer? audioObject, Widget? child) {
            if (audioObject?.audioSource != null) {
              return const SizedBox(height: 75);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  Widget banner() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.25,
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          alignment: Alignment.center,
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 1,
            itemBuilder: (context, index) {
              return Stack(
                alignment: Alignment.topLeft,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: MyImage(
                      imagePath: "ic_categorybg.png",
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                  Positioned.fill(
                    right: 20,
                    top: 45,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        children: [
                          MyText(
                            color: white,
                            textalign: TextAlign.center,
                            fontsize: 16,
                            inter: true,
                            maxline: 2,
                            multilanguage: true,
                            fontwaight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            fontstyle: FontStyle.normal,
                            text: "trytonew",
                          ),
                          MyText(
                            color: white,
                            textalign: TextAlign.center,
                            fontsize: 16,
                            inter: true,
                            multilanguage: true,
                            maxline: 2,
                            fontwaight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            fontstyle: FontStyle.normal,
                            text: "premiumaudio",
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          InkWell(
                            onTap: () {
                              AdHelper.rewardedAd(context, () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return Package(userid: widget.userid);
                                    },
                                  ),
                                );
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.40,
                              height: MediaQuery.of(context).size.height * 0.05,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    yellow.withOpacity(0.9),
                                    orange.withOpacity(0.3),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  MyText(
                                    color: white,
                                    textalign: TextAlign.center,
                                    fontsize: 16,
                                    inter: true,
                                    maxline: 2,
                                    multilanguage: true,
                                    fontwaight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    fontstyle: FontStyle.normal,
                                    text: "buynow",
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  MyImage(
                                      width: 15,
                                      height: 15,
                                      imagePath: "ic_rightarrow.png"),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget landscapList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.centerLeft,
        child: PagewiseListView<Result>(
            scrollDirection: Axis.vertical,
            showRetry: false,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 10),
            noItemsFoundBuilder: (context) {
              return const NoData();
            },
            pageLoadController: _pageLoadController,
            loadingBuilder: (context) {
              return Utils.pageLoader();
            },
            itemBuilder: (context, entry, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Detail(
                          audioname: entry.title.toString(),
                          audioid: entry.id.toString(),
                          userid: widget.userid,
                          categoryid: entry.categoryId.toString(),
                        );
                      },
                    ),
                  );
                },
                child: Container(
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
                          child: MyNetworkImage(
                              imgWidth: 110,
                              fit: BoxFit.cover,
                              imgHeight: MediaQuery.of(context).size.height,
                              imageUrl: entry.image.toString()),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MyText(
                                  color: white,
                                  text: entry.title.toString(),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  MyImage(
                                      width: 15,
                                      height: 15,
                                      imagePath: "play.png"),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  MyText(
                                      color: gray,
                                      text: Utils.kmbGenerator(int.parse(
                                        entry.played.toString(),
                                      )),
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
                                  text: entry.description.toString(),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MyImage(
                                  width: 10,
                                  height: 10,
                                  imagePath: "ic_star.png"),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              MyText(
                                  color: black,
                                  text: entry.rating?.toString() ?? "",
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
    );
  }

  Widget landscapListShimmer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Container(
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
                  CustomWidget.roundrectborder(
                    width: 110,
                    height: MediaQuery.of(context).size.height,
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
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: 15,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CustomWidget.circular(width: 15, height: 15),
                            const SizedBox(
                              width: 10,
                            ),
                            CustomWidget.roundrectborder(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: 15,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        CustomWidget.roundrectborder(
                          width: MediaQuery.of(context).size.width * 0.20,
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  const CustomWidget.roundcorner(
                    width: 60,
                    height: 25,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
