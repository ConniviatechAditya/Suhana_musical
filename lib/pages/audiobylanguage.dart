import 'package:dtpocketfm/pages/detail.dart';
import 'package:dtpocketfm/pages/nodata.dart';
import 'package:dtpocketfm/pages/package.dart';
import 'package:dtpocketfm/provider/audiobylanguageprovider.dart';
import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/constant.dart';
import 'package:dtpocketfm/utils/customwidget.dart';
import 'package:dtpocketfm/utils/utils.dart';
import 'package:dtpocketfm/widget/myimage.dart';
import 'package:dtpocketfm/widget/mynetworkimg.dart';
import 'package:dtpocketfm/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../model/getaudiobylanguagemodel.dart';

class AudiobyLanguage extends StatefulWidget {
  final String languageid, userid;
  const AudiobyLanguage(
      {super.key, required this.languageid, required this.userid});

  @override
  State<AudiobyLanguage> createState() => AudiobyLanguageState();
}

class AudiobyLanguageState extends State<AudiobyLanguage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  late PagewiseLoadController<Result> audiobylanguageController;
  int pageno = 1;
  int tabindex = 1;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: Constant().searchItemTab.length, vsync: this, initialIndex: 0);
    getApi();
    tabController?.addListener(_handleTabIndex);
  }

  void _handleTabIndex() async {
    tabindex = tabController!.index + 1;
    getApi();
  }

  getApi() async {
    audiobylanguageController =
        PagewiseLoadController(pageSize: 10, pageFuture: fetchNewData);
  }

  Future<List<Result>> fetchNewData(int? nextPage) async {
    final audiolistprovider =
        Provider.of<AudiobyLanguageProvider>(context, listen: false);
    pageno = (nextPage ?? 0) + 1;
    debugPrint("tabindex = > $tabindex");
    await audiolistprovider.getAudiobylanguage(
        widget.languageid, tabindex.toString(), pageno.toString());
    return audiolistprovider.getaudiobylanguageModel.result ?? [];
  }

  @override
  void dispose() {
    tabController?.removeListener(_handleTabIndex);
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      appBar: AppBar(
        backgroundColor: colorPrimaryDark,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 5,
        leadingWidth: 1,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context, false);
              },
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child:
                      MyImage(width: 15, height: 15, imagePath: "ic_back.png")),
            ),
            TabBar(
                controller: tabController,
                labelPadding: Locales.selectedLocaleRtl == true
                    ? const EdgeInsets.fromLTRB(15, 0, 0, 0)
                    : const EdgeInsets.fromLTRB(0, 0, 15, 0),
                isScrollable: true,
                labelColor: white,
                physics: const BouncingScrollPhysics(),
                unselectedLabelColor: gray,
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 1,
                    color: colorPrimaryDark,
                  ),
                ),
                indicatorColor: colorPrimaryDark,
                labelStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  color: white,
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  color: white,
                  fontWeight: FontWeight.w400,
                ),
                padding: const EdgeInsets.all(0),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: Constant().searchItemTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          story(),
          course(),
          fullbook(),
        ],
      ),
    );
  }

  Widget story() {
    return Column(
      children: [
        banner(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Expanded(child: gridList()),
      ],
    );
  }

  Widget course() {
    return Column(
      children: [
        banner(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Expanded(child: landscapList()),
      ],
    );
  }

  Widget fullbook() {
    return Column(
      children: [
        banner(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Expanded(child: landscapList()),
      ],
    );
  }

  Widget banner() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.27,
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          alignment: Alignment.center,
          child: PageView.builder(
            itemCount: 10,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Package(userid: widget.userid);
                                  },
                                ),
                              );
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

  Widget gridList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topCenter,
        child: PagewiseGridView<Result>.count(
            crossAxisCount: 3,
            pageLoadController: audiobylanguageController,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 5 / 7,
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 10),
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            addRepaintBoundaries: true,
            addAutomaticKeepAlives: true,
            addSemanticIndexes: true,
            noItemsFoundBuilder: (context) {
              return const NoData();
            },
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
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(7),
                              bottomRight: Radius.circular(7),
                              topLeft: Radius.circular(7),
                              topRight: Radius.circular(7),
                            ),
                            child: MyNetworkImage(
                              imageUrl: entry.image.toString(),
                              fit: BoxFit.cover,
                              imgWidth: MediaQuery.of(context).size.width,
                              imgHeight: MediaQuery.of(context).size.height,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MyText(
                                color: white,
                                text: entry.title.toString(),
                                textalign: TextAlign.center,
                                fontsize: 11,
                                inter: true,
                                maxline: 1,
                                fontwaight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyText(
                                    color: white,
                                    multilanguage: true,
                                    text: "episodes",
                                    textalign: TextAlign.center,
                                    fontsize: 10,
                                    inter: true,
                                    maxline: 6,
                                    fontwaight: FontWeight.w400,
                                    overflow: TextOverflow.ellipsis,
                                    fontstyle: FontStyle.normal),
                                const SizedBox(width: 2),
                                MyText(
                                    color: white,
                                    text: entry.totalEpisode.toString(),
                                    textalign: TextAlign.center,
                                    fontsize: 10,
                                    inter: true,
                                    maxline: 6,
                                    fontwaight: FontWeight.w400,
                                    overflow: TextOverflow.ellipsis,
                                    fontstyle: FontStyle.normal),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget gridListShimmer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.centerLeft,
        child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 12,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 5 / 7,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5),
            itemBuilder: (BuildContext ctx, index) {
              return CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              );
            }),
      ),
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
            physics: const BouncingScrollPhysics(),
            showRetry: false,
            padding: const EdgeInsets.only(bottom: 10),
            noItemsFoundBuilder: (context) {
              return const NoData();
            },
            pageLoadController: audiobylanguageController,
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
