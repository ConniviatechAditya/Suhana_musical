import 'package:dtpocketfm/pages/detail.dart';
import 'package:dtpocketfm/pages/nodata.dart';
import 'package:dtpocketfm/provider/continuewatchingseeallprovider.dart';
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

import '../model/continuewatchingmodel.dart';

class ContinueWatchingSeeall extends StatefulWidget {
  final String? title, ishomepage, type;
  final String userid;

  const ContinueWatchingSeeall(
      {super.key,
      required this.userid,
      this.title,
      this.ishomepage,
      this.type});

  @override
  State<ContinueWatchingSeeall> createState() => ContinueWatchingSeeallState();
}

class ContinueWatchingSeeallState extends State<ContinueWatchingSeeall> {
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
    final continuewatchingprovider =
        Provider.of<ContinuewatchingSeeallProvider>(context, listen: false);
    pageno = (nextPage ?? 0) + 1;
    debugPrint("Pageno =>$pageno");
    await continuewatchingprovider.getContinueWatching(
        widget.userid, pageno.toString());
    return continuewatchingprovider.continuewatchingModel.result ?? [];
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
              multilanguage: true,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.center,
              fontstyle: FontStyle.normal,
              inter: true,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            continueWatchingList(),
          ],
        ),
      ),
    );
  }

  Widget continueWatchingList() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: PagewiseGridView<Result>.count(
            crossAxisCount: 3,
            pageLoadController: _pageLoadController,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 5 / 7,
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
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
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
                            MyText(
                                color: white,
                                text: Utils.dateFormat(
                                    entry.createdAt.toString(), "dd MMMM yyyy"),
                                textalign: TextAlign.center,
                                fontsize: 10,
                                inter: true,
                                maxline: 1,
                                fontwaight: FontWeight.w400,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }

  Widget continueWatchingListShimmer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
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
}
