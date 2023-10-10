import 'package:dtpocketfm/pages/nodata.dart';
import 'package:dtpocketfm/provider/notificationprovider.dart';
import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/customwidget.dart';
import 'package:dtpocketfm/utils/utils.dart';
import 'package:dtpocketfm/widget/myimage.dart';
import 'package:dtpocketfm/widget/mynetworkimg.dart';
import 'package:dtpocketfm/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import '../model/getnotificatiomodel.dart';

class NotificationPage extends StatefulWidget {
  final String userid;
  const NotificationPage({Key? key, required this.userid}) : super(key: key);

  @override
  State<NotificationPage> createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
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
    final homeprovider =
        Provider.of<NotificationProvider>(context, listen: false);
    pageno = (nextPage ?? 0) + 1;
    debugPrint("Pageno =>$pageno");
    await homeprovider.getnotification(widget.userid, pageno.toString());
    return homeprovider.getnotificatioModel.result ?? [];
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
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context, false);
              },
              child: MyImage(width: 20, height: 20, imagePath: "ic_back.png"),
            ),
            const SizedBox(width: 10),
            MyText(
              color: white,
              text: "notification",
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
      body: notificationlist(),
    );
  }

  Widget notificationlist() {
    return PagewiseListView<Result>(
      noItemsFoundBuilder: (context) {
        return const NoData();
      },
      showRetry: false,
      pageLoadController: _pageLoadController,
      loadingBuilder: (context) {
        return Utils.pageLoader();
      },
      itemBuilder: (context, entry, index) {
        return Slidable(
          key: const ValueKey(0),
          direction: Axis.horizontal,
          closeOnScroll: true,
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            dragDismissible: true,
            dismissible: DismissiblePane(onDismissed: () {}),
            children: const [],
          ),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              // delete Button
              SlidableAction(
                onPressed: (BuildContext context) async {
                  final notificationprovider =
                      Provider.of<NotificationProvider>(context, listen: false);
                  notificationprovider.readnotification(
                      widget.userid, entry.id.toString());
                  if (notificationprovider.readnotificationModel.status ==
                      200) {
                    getApi();
                    setState(() {});
                  }
                },
                backgroundColor: colorPrimaryDark,
                icon: Icons.delete,
                autoClose: true,
                foregroundColor: white,
              ),
            ],
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorPrimary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: MyNetworkImage(
                      imgWidth: 55,
                      imgHeight: 55,
                      imageUrl: entry.image.toString(),
                      fit: BoxFit.cover),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          MyText(
                              color: white,
                              text: entry.title.toString(),
                              fontsize: 14,
                              maxline: 2,
                              inter: true,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.left,
                              fontstyle: FontStyle.normal,
                              fontwaight: FontWeight.w500),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.topLeft,
                        child: ReadMoreText(
                          entry.message.toString(),
                          trimLines: 5,
                          preDataTextStyle:
                              const TextStyle(fontWeight: FontWeight.w400),
                          style: const TextStyle(
                              color: gray,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                          colorClickableText: yellow,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: '  Read More',
                          trimExpandedText: ' Read less',
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
    );
  }

  Widget notificationlistShimmer() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 10,
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorPrimary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                const CustomWidget.circular(
                  width: 55,
                  height: 55,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomWidget.roundrectborder(
                        width: MediaQuery.of(context).size.width * 0.40,
                        height: 10,
                      ),
                      const SizedBox(height: 5),
                      CustomWidget.roundrectborder(
                        width: MediaQuery.of(context).size.width * 0.20,
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
