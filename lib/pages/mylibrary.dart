import 'package:dtpocketfm/pages/detail.dart';
import 'package:dtpocketfm/pages/nodata.dart';
import 'package:dtpocketfm/provider/libraryprovider.dart';
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
import '../model/bookmarklistmodel.dart';

class MyLibrary extends StatefulWidget {
  final String userid;
  const MyLibrary({super.key, required this.userid});

  @override
  State<MyLibrary> createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary>
    with SingleTickerProviderStateMixin {
  late PagewiseLoadController<Result> _pageLoadController;
  int pageno = 1;
  TabController? tabController;
  double? width;
  double? height;

  @override
  void initState() {
    super.initState();
    debugPrint("userid=> ${widget.userid}");
    tabController = TabController(
        length: Constant().mylibraryTabs.length, vsync: this, initialIndex: 0);
    getApi();
    tabController?.addListener(_handleTabIndex);
  }

  void _handleTabIndex() async {
    if (tabController?.index == 0) {
      getApi();
    } else {
      // Download List Api Intigrate
    }
  }

  getApi() async {
    _pageLoadController =
        PagewiseLoadController(pageSize: 10, pageFuture: fetchNewData);
  }

  Future<List<Result>> fetchNewData(int? nextPage) async {
    final libraryprovider =
        Provider.of<LibraryProvider>(context, listen: false);
    pageno = (nextPage ?? 0) + 1;
    debugPrint("Pageno =>$pageno");
    await libraryprovider.getBookmarklist(widget.userid, pageno.toString());
    return libraryprovider.bookmarklistModel.result ?? [];
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      appBar: AppBar(
        backgroundColor: colorPrimaryDark,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 15,
        leadingWidth: 1,
        automaticallyImplyLeading: false,
        title: TabBar(
            controller: tabController,
            labelPadding: Locales.selectedLocaleRtl == true
                ? const EdgeInsets.fromLTRB(10, 0, 0, 0)
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
            tabs: Constant().mylibraryTabs),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          mylibraryTab("Recent Played"),
          // downloadTab(),
        ],
      ),
    );
  }

  Widget downloadTab() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(15),
      child: downloadItem("Download"),
    );
  }

  Widget mylibraryTab(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // MyText(
          //   color: white,
          //   text: label,
          //   textalign: TextAlign.center,
          //   fontsize: 16,
          //   inter: true,
          //   maxline: 6,
          //   fontwaight: FontWeight.w500,
          //   overflow: TextOverflow.ellipsis,
          //   fontstyle: FontStyle.normal,
          // ),
          // const SizedBox(height: 20),
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              child: PagewiseListView<Result>(
                pageLoadController: _pageLoadController,
                showRetry: false,
                physics: const BouncingScrollPhysics(),
                noItemsFoundBuilder: (context) {
                  return const NoData();
                },
                loadingBuilder: (context) {
                  return Utils.pageLoader();
                },
                itemBuilder: (context, entry, index) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    width: MediaQuery.of(context).size.width,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Detail(
                                audioname: entry.title?.toString() ?? "",
                                audioid: entry.id?.toString() ?? "",
                                userid: widget.userid,
                                categoryid: entry.categoryId.toString(),
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.14,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: MyNetworkImage(
                                imgWidth: 110,
                                fit: BoxFit.cover,
                                imgHeight: MediaQuery.of(context).size.height,
                                imageUrl: entry.image.toString(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                    fontstyle: FontStyle.normal,
                                  ),
                                  const SizedBox(width: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      MyImage(
                                        width: 15,
                                        height: 15,
                                        imagePath: "play.png",
                                      ),
                                      const SizedBox(width: 10),
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
                                        fontstyle: FontStyle.normal,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 3),
                                  MyText(
                                    color: white,
                                    text: entry.description.toString(),
                                    fontsize: 10,
                                    inter: true,
                                    fontwaight: FontWeight.w400,
                                    maxline: 3,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.left,
                                    fontstyle: FontStyle.normal,
                                  ),
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
                                    imagePath: "ic_star.png",
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
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
                                    fontstyle: FontStyle.normal,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error) {
                  return const NoData();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget mylibraryTabShimmer() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              CustomWidget.roundrectborder(
                  height: height! * 0.02, width: width! * 0.35),
              const SizedBox(width: 5),
              const CustomWidget.roundrectborder(height: 10, width: 10),
            ],
          ),
          const SizedBox(height: 20),
          shimmerItem(),
          shimmerItem(),
          shimmerItem(),
          shimmerItem(),
          shimmerItem(),
        ],
      ),
    );
  }

  Widget downloadItem(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
            color: white,
            text: label,
            textalign: TextAlign.center,
            fontsize: 16,
            inter: true,
            maxline: 6,
            fontwaight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
            fontstyle: FontStyle.normal),
        const SizedBox(height: 5),
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (BuildContext ctx, index) {
              return InkWell(
                onTap: () {},
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.09,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: MyImage(
                            width: MediaQuery.of(context).size.width * 0.21,
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height,
                            imagePath: "bannerimg.png"),
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
                                text: "Sandeep Maheshwari",
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
                                    text: "366K",
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
                                text:
                                    "Sandeep maheshwari ko kaun nahi  Janta , Inki eke ek videos mein itni inspiration hoti  Read More.....",
                                fontsize: 10,
                                inter: true,
                                fontwaight: FontWeight.w400,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.more_vert_outlined,
                        color: white,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget downloadShimmer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (BuildContext ctx, index) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.09,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.fromLTRB(0, 12, 0, 12),
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomWidget.roundrectborder(
                  width: MediaQuery.of(context).size.width * 0.21,
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
                        width: MediaQuery.of(context).size.width * 0.21,
                        height: 10,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CustomWidget.rectangular(
                            width: 15,
                            height: 15,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          CustomWidget.roundrectborder(
                            width: MediaQuery.of(context).size.width * 0.21,
                            height: 10,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      CustomWidget.roundrectborder(
                        width: MediaQuery.of(context).size.width * 0.21,
                        height: 10,
                      ),
                    ],
                  ),
                ),
                const CustomWidget.roundrectborder(
                  width: 4,
                  height: 12,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget shimmerItem() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.14,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
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
                      width: MediaQuery.of(context).size.width * 0.15,
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
  }
}
