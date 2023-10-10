import 'package:dtpocketfm/pages/detail.dart';
import 'package:dtpocketfm/pages/nodata.dart';
import 'package:dtpocketfm/provider/homeprovider.dart';
import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/customwidget.dart';
import 'package:dtpocketfm/utils/utils.dart';
import 'package:dtpocketfm/widget/myimage.dart';
import 'package:dtpocketfm/widget/mynetworkimg.dart';
import 'package:dtpocketfm/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';

import '../model/newreleasemodel.dart';

class LandScapSeeall extends StatefulWidget {
  final String? title, ishomepage, type;
  final String subtype, userid;

  const LandScapSeeall(
      {super.key,
      required this.subtype,
      this.title,
      this.ishomepage,
      required this.userid,
      this.type});

  @override
  State<LandScapSeeall> createState() => LandScapSeeallState();
}

class LandScapSeeallState extends State<LandScapSeeall> {
  late PagewiseLoadController<Result> _pageLoadController;
  int pageno = 1;

  @override
  initState() {
    super.initState();
    getApi();
  }

  getApi() async {
    _pageLoadController =
        PagewiseLoadController(pageSize: 10, pageFuture: fetchNewData);
  }

  Future<List<Result>> fetchNewData(int? nextPage) async {
    final homeprovider = Provider.of<HomeProvider>(context, listen: false);
    pageno = (nextPage ?? 0) + 1;
    debugPrint("Pageno =>$pageno");
    await homeprovider.getNewRelease(widget.ishomepage.toString(),
        widget.type.toString(), pageno.toString());
    return homeprovider.newreleaseModel.result ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorPrimaryDark,
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          elevation: 0,
          titleSpacing: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: colorPrimaryDark,
          ),
          backgroundColor: colorPrimaryDark,
          title: Row(
            children: [
              InkWell(
                focusColor: white.withOpacity(0.40),
                onTap: () {
                  Navigator.pop(context, false);
                },
                child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: MyImage(
                        width: 15, height: 15, imagePath: "ic_back.png")),
              ),
              const SizedBox(width: 10),
              MyText(
                color: white,
                text: widget.title.toString(),
                fontsize: 16,
                fontwaight: FontWeight.w600,
                maxline: 1,
                multilanguage: true,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.center,
                fontstyle: FontStyle.normal,
                inter: true,
              ),
            ],
          ),
        ),
        body: widget.subtype == "0" ? landscapList() : landscapListtopcourse());
  }

  Widget landscapList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: PagewiseListView<Result>(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
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
                      imageUrl: entry.image.toString(),
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
                                width: 15, height: 15, imagePath: "play.png"),
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
                        borderRadius: BorderRadius.circular(50), color: yellow),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyImage(
                            width: 10, height: 10, imagePath: "ic_star.png"),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        MyText(
                            color: black,
                            text: entry.rating?.toString() ?? "",
                            textalign: TextAlign.center,
                            fontsize: 12,
                            inter: true,
                            maxline: 1,
                            fontwaight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                            fontstyle: FontStyle.normal),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget landscapListtopcourse() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: PagewiseListView<Result>(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        loadingBuilder: (context) {
          return Utils.pageLoader();
        },
        noItemsFoundBuilder: (context) {
          return const NoData();
        },
        pageLoadController: _pageLoadController,
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
                      imageUrl: entry.image.toString(),
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
                                width: 15, height: 15, imagePath: "play.png"),
                            const SizedBox(width: 10),
                            MyText(
                                color: gray,
                                text: Numeral(int.parse(
                                  entry.played.toString(),
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
                        borderRadius: BorderRadius.circular(50), color: yellow),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyImage(
                            width: 10, height: 10, imagePath: "ic_star.png"),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        MyText(
                            color: black,
                            text: entry.rating.toString(),
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
              ),
            ),
          );
        },
      ),
    );
  }

  Widget landscapListShimmer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (BuildContext ctx, index) {
                  return Container(
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      height: 10,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                CustomWidget.roundrectborder(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
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
                      ));
                }),
          ),
        ],
      ),
    );
  }
}
