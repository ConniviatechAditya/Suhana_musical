import 'package:dtpocketfm/pages/audiobycategory.dart';
import 'package:dtpocketfm/pages/nodata.dart';
import 'package:dtpocketfm/provider/homeprovider.dart';
import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/utils.dart';
import 'package:dtpocketfm/widget/mynetworkimg.dart';
import 'package:dtpocketfm/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:provider/provider.dart';

import '../model/categorymodel.dart';

class CategorySeeAll extends StatefulWidget {
  final String userid;
  const CategorySeeAll({super.key, required this.userid});

  @override
  State<CategorySeeAll> createState() => _CategorySeeAllState();
}

class _CategorySeeAllState extends State<CategorySeeAll> {
  late PagewiseLoadController<Result> genresController;
  int pageno = 1;
  @override
  void initState() {
    super.initState();
    genresApi();
  }

  genresApi() async {
    genresController =
        PagewiseLoadController(pageSize: 10, pageFuture: genresNewData);
  }

  Future<List<Result>> genresNewData(int? nextPage) async {
    final searchprovider = Provider.of<HomeProvider>(context, listen: false);
    pageno = (nextPage ?? 0) + 1;
    debugPrint("Pageno =>$pageno");
    await searchprovider.getCategory(pageno.toString());
    return searchprovider.categoryModel.result ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      appBar: Utils().myappbar("ic_back.png", "allcategory", () {
        Navigator.pop(context, false);
      }),
      body: geners(),
    );
  }

  Widget geners() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        PagewiseGridView<Result>.count(
          crossAxisCount: 3,
          pageLoadController: genresController,
          mainAxisSpacing: 5,
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          crossAxisSpacing: 5,
          childAspectRatio: 5 / 6,
          shrinkWrap: true,
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
                      return AudiobyCategory(
                        categoryid: entry.id.toString(),
                        userid: widget.userid,
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
                        imgWidth: 70,
                        imgHeight: 70,
                        fit: BoxFit.cover,
                        imageUrl: entry.image.toString()),
                  ),
                  const SizedBox(height: 15),
                  MyText(
                    color: white,
                    textalign: TextAlign.left,
                    fontsize: 14,
                    inter: true,
                    maxline: 2,
                    fontwaight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                    fontstyle: FontStyle.normal,
                    text: entry.name.toString(),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
