import 'package:dtpocketfm/pages/detail.dart';
import 'package:dtpocketfm/provider/searchprovider.dart';
import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/customwidget.dart';
import 'package:dtpocketfm/utils/utils.dart';
import 'package:dtpocketfm/widget/myimage.dart';
import 'package:dtpocketfm/widget/mynetworkimg.dart';
import 'package:dtpocketfm/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopSearch extends StatefulWidget {
  final String topsearchname, userid;
  const TopSearch({
    super.key,
    required this.topsearchname,
    required this.userid,
  });

  @override
  State<TopSearch> createState() => TopSearchState();
}

class TopSearchState extends State<TopSearch> {
  double? width;
  double? height;

  @override
  void initState() {
    super.initState();
    getApi();
  }

  getApi() async {
    final searchprovider = Provider.of<SearchProvider>(context, listen: false);
    await searchprovider.getSearch(widget.topsearchname, widget.userid);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      appBar: Utils().myappbar("ic_back.png", "topsearch", () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            manualSearch(),
          ],
        ),
      ),
    );
  }

  Widget manualSearch() {
    return Consumer<SearchProvider>(
      builder: (context, searchprovider, child) {
        if (searchprovider.loading) {
          return manualSearchShimmer();
        } else {
          if (searchprovider.searchModel.status == 200 &&
              searchprovider.searchModel.result != null) {
            if ((searchprovider.searchModel.result?.length ?? 0) > 0) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount:
                            searchprovider.searchModel.result?.length ?? 0,
                        itemBuilder: (BuildContext ctx, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Detail(
                                      audioname: searchprovider
                                              .searchModel.result?[index].title
                                              .toString() ??
                                          "",
                                      audioid: searchprovider
                                              .searchModel.result?[index].id
                                              .toString() ??
                                          "",
                                      userid: widget.userid,
                                      categoryid: searchprovider.searchModel
                                              .result?[index].categoryId
                                              .toString() ??
                                          "",
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: MyNetworkImage(
                                          imgWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.21,
                                          fit: BoxFit.cover,
                                          imgHeight: MediaQuery.of(context)
                                              .size
                                              .height,
                                          imageUrl: searchprovider.searchModel
                                                  .result?[index].image
                                                  .toString() ??
                                              ""),
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
                                              text: searchprovider.searchModel
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
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              MyText(
                                                  color: gray,
                                                  text: Utils.kmbGenerator(
                                                      int.parse(
                                                    searchprovider
                                                            .searchModel
                                                            .result?[index]
                                                            .played
                                                            .toString() ??
                                                        "",
                                                  )),
                                                  fontsize: 12,
                                                  inter: true,
                                                  fontwaight: FontWeight.w500,
                                                  maxline: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textalign: TextAlign.center,
                                                  fontstyle: FontStyle.normal),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          MyText(
                                              color: white,
                                              text: searchprovider
                                                      .searchModel
                                                      .result?[index]
                                                      .description
                                                      .toString() ??
                                                  "",
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
                                    Container(
                                      width: 60,
                                      height: 25,
                                      margin: const EdgeInsets.only(top: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
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
                                              text: searchprovider.searchModel
                                                      .result?[index].rating
                                                      ?.toString() ??
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
              );
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.topCenter,
                child: MyText(
                    color: white,
                    text: "Record Not Found",
                    fontsize: 16,
                    fontwaight: FontWeight.w600,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal),
              );
            }
          } else {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.topCenter,
              child: MyText(
                  color: white,
                  text: "Record Not Found",
                  fontsize: 16,
                  fontwaight: FontWeight.w600,
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal),
            );
          }
        }
      },
    );
  }

  Widget manualSearchShimmer() {
    return Column(
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
                height: MediaQuery.of(context).size.height * 0.09,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: CustomWidget.roundrectborder(
                          width: MediaQuery.of(context).size.width * 0.21,
                          height: MediaQuery.of(context).size.height,
                        )),
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
                              const CustomWidget.roundcorner(
                                width: 15,
                                height: 15,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              CustomWidget.roundrectborder(
                                width: MediaQuery.of(context).size.width * 0.10,
                                height: 10,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          CustomWidget.roundrectborder(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: 10,
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
      ],
    );
  }
}
