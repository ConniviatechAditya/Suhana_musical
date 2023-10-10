import 'package:dtpocketfm/model/gettopplaymodel.dart';
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
import 'package:provider/provider.dart';

class GridListSeeall extends StatefulWidget {
  final String? title, ishomepage, type;
  final String userid;

  const GridListSeeall(
      {super.key,
      required this.userid,
      this.title,
      this.ishomepage,
      this.type});

  @override
  State<GridListSeeall> createState() => GridListSeeallState();
}

class GridListSeeallState extends State<GridListSeeall> {
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
    await homeprovider.getTopPlay(widget.ishomepage.toString(),
        widget.type.toString(), pageno.toString());
    return homeprovider.topplayModel.result ?? [];
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
                  child:
                      MyImage(width: 15, height: 15, imagePath: "ic_back.png")),
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
      body: PagewiseGridView<Result>.count(
          crossAxisCount: 2,
          pageLoadController: _pageLoadController,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 5 / 6,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(15.0),
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
              onTap: () {},
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Detail(
                          audioid: entry.id.toString(),
                          audioname: entry.title.toString(),
                          userid: widget.userid,
                          categoryid: entry.categoryId.toString(),
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: MyNetworkImage(
                                imgWidth: 120,
                                imgHeight:
                                    MediaQuery.of(context).size.height * 0.20,
                                fit: BoxFit.cover,
                                imageUrl: entry.image.toString(),
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
              ),
            );
          }),
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
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: 8,
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
}
