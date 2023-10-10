import 'package:dtpocketfm/pages/audiobylanguage.dart';
import 'package:dtpocketfm/pages/bottombar.dart';
import 'package:dtpocketfm/pages/audiobycategory.dart';
import 'package:dtpocketfm/pages/detail.dart';
import 'package:dtpocketfm/pages/nodata.dart';
import 'package:dtpocketfm/pages/topsearch.dart';
import 'package:dtpocketfm/provider/searchprovider.dart';
import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/customwidget.dart';
import 'package:dtpocketfm/utils/sharedpre.dart';
import 'package:dtpocketfm/utils/utils.dart';
import 'package:dtpocketfm/widget/myimage.dart';
import 'package:dtpocketfm/widget/mynetworkimg.dart';
import 'package:dtpocketfm/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../model/topsearchmodel.dart' as topsearch;
import '../model/categorymodel.dart' as category;
import '../model/languagemodel.dart' as languagelist;

class Search extends StatefulWidget {
  final String userid;
  const Search({super.key, required this.userid});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();
  SharedPre sharedpre = SharedPre();
  late PagewiseLoadController<topsearch.Result> topsearchController;
  late PagewiseLoadController<category.Result> genresController;
  late PagewiseLoadController<languagelist.Result> languageController;
  int pageno = 1;
  double? width;
  double? height;

  @override
  void initState() {
    super.initState();
    topsearchApi();
    genresApi();
    languageApi();
  }

  topsearchApi() async {
    topsearchController =
        PagewiseLoadController(pageSize: 10, pageFuture: topsearchNewData);
  }

  Future<List<topsearch.Result>> topsearchNewData(int? nextPage) async {
    final searchprovider = Provider.of<SearchProvider>(context, listen: false);
    pageno = (nextPage ?? 0) + 1;
    debugPrint("Pageno =>$pageno");
    await searchprovider.getTopSearch(pageno.toString());
    return searchprovider.topsearchModel.result ?? [];
  }

  genresApi() async {
    genresController =
        PagewiseLoadController(pageSize: 10, pageFuture: genresNewData);
  }

  Future<List<category.Result>> genresNewData(int? nextPage) async {
    final searchprovider = Provider.of<SearchProvider>(context, listen: false);
    pageno = (nextPage ?? 0) + 1;
    debugPrint("Pageno =>$pageno");
    await searchprovider.getCategory(pageno.toString());
    return searchprovider.categoryModel.result ?? [];
  }

  languageApi() async {
    languageController =
        PagewiseLoadController(pageSize: 10, pageFuture: languageNewData);
  }

  Future<List<languagelist.Result>> languageNewData(int? nextPage) async {
    final searchprovider = Provider.of<SearchProvider>(context, listen: false);
    pageno = (nextPage ?? 0) + 1;
    debugPrint("Pageno =>$pageno");
    await searchprovider.getLanguage(pageno.toString());
    return searchprovider.languageModel.result ?? [];
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Align(
          alignment: Alignment.center,
          child: AppBar(
            centerTitle: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: colorPrimaryDark,
            title: SizedBox(
              height: 45,
              child: TextFormField(
                obscureText: false,
                keyboardType: TextInputType.text,
                controller: searchController,
                textInputAction: TextInputAction.done,
                cursorColor: white,
                onTap: () {
                  if (widget.userid.isEmpty || widget.userid == "") {
                    Utils.openLogin(
                        context: context, isHome: false, isReplace: false);
                  }
                },
                onChanged: (value) async {
                  final searchprovider =
                      Provider.of<SearchProvider>(context, listen: false);
                  setState(() {});
                  if (searchController.text.isNotEmpty ||
                      searchController.text != "") {
                    await searchprovider.getSearch(
                        searchController.text.toString(), widget.userid);
                  }
                },
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    color: colorAccent,
                    fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  prefixIcon: Container(
                      alignment: Alignment.center,
                      width: 20,
                      height: 20,
                      child: MyImage(
                          width: 25,
                          height: 25,
                          color: white,
                          imagePath: "ic_search.png")),
                  hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      color: white,
                      fontWeight: FontWeight.w500),
                  hintText: "Search  “ Stories “",
                  filled: true,
                  fillColor: gray.withOpacity(0.40),
                  contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(width: 1, color: lightblue),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(width: 1, color: lightblue),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(width: 1, color: lightblue),
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(width: 1, color: lightblue)),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  searchController.text.isEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            topsearchSection(),
                            const SizedBox(height: 10),
                            geners(),
                            const SizedBox(height: 10),
                            language(),
                          ],
                        )
                      : manualSearch(),
                ],
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: currentlyPlaying,
            builder: (BuildContext context, AudioPlayer? audioObject,
                Widget? child) {
              if (audioObject?.audioSource != null) {
                return const SizedBox(height: 75);
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget topsearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
            color: white,
            text: "topsearch",
            fontsize: 14,
            multilanguage: true,
            overflow: TextOverflow.ellipsis,
            maxline: 1,
            fontwaight: FontWeight.w600,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal),
        const SizedBox(height: 20),
        Container(
          height: MediaQuery.of(context).size.height * 0.21,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.topLeft,
          child: PagewiseGridView<topsearch.Result>.count(
            crossAxisCount: 3,
            pageLoadController: topsearchController,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3 / 8,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 15),
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
                onTap: () async {
                  if (widget.userid.isEmpty || widget.userid == "") {
                    Utils.openLogin(
                        context: context, isHome: false, isReplace: false);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return TopSearch(
                              topsearchname: entry.title.toString(),
                              userid: widget.userid);
                        },
                      ),
                    );
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      border: Border.all(width: 1, color: darkpurpole)),
                  child: MyText(
                      color: darkpurpole,
                      text: entry.title.toString(),
                      fontsize: 12,
                      overflow: TextOverflow.ellipsis,
                      maxline: 1,
                      fontwaight: FontWeight.w600,
                      textalign: TextAlign.center,
                      fontstyle: FontStyle.normal),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget topsearchShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomWidget.roundrectborder(
            height: height! * 0.02, width: width! * 0.35),
        const SizedBox(height: 20),
        Container(
          height: MediaQuery.of(context).size.height * 0.22,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: 15,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 45,
                childAspectRatio: 3 / 8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (BuildContext ctx, index) {
              return CustomWidget.roundcorner(height: height!, width: width!);
            },
          ),
        ),
      ],
    );
  }

  Widget geners() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        MyText(
            color: white,
            text: "genres",
            textalign: TextAlign.center,
            fontsize: 14,
            inter: true,
            multilanguage: true,
            maxline: 6,
            fontwaight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
            fontstyle: FontStyle.normal),
        const SizedBox(height: 10),
        Container(
          height: MediaQuery.of(context).size.height * 0.35,
          alignment: Alignment.centerLeft,
          child: PagewiseGridView<category.Result>.count(
            crossAxisCount: 3,
            pageLoadController: genresController,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 5 / 6,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
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
                child: Container(
                  foregroundDecoration: BoxDecoration(
                    color: white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(
                      colors: [
                        colorPrimary.withOpacity(0.9),
                        colorPrimary.withOpacity(0.1),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.01, 2],
                    ),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: MyNetworkImage(
                            imgWidth: MediaQuery.of(context).size.width,
                            imgHeight: MediaQuery.of(context).size.height,
                            fit: BoxFit.cover,
                            imageUrl: entry.image.toString()),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: MyText(
                            color: white,
                            textalign: TextAlign.left,
                            fontsize: 10,
                            inter: true,
                            maxline: 2,
                            fontwaight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            fontstyle: FontStyle.normal,
                            text: entry.name.toString(),
                          ),
                        ),
                      ),
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

  Widget genersShimmer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        CustomWidget.roundrectborder(
            height: height! * 0.02, width: width! * 0.35),
        const SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 6 / 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemBuilder: (BuildContext ctx, index) {
                return CustomWidget.roundrectborder(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                );
              }),
        ),
      ],
    );
  }

  Widget language() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          MyText(
              color: white,
              text: "language",
              textalign: TextAlign.center,
              fontsize: 14,
              multilanguage: true,
              inter: true,
              maxline: 6,
              fontwaight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
              fontstyle: FontStyle.normal),
          const SizedBox(height: 15),
          Container(
            height: MediaQuery.of(context).size.height * 0.12,
            alignment: Alignment.centerLeft,
            child: PagewiseGridView<languagelist.Result>.count(
                crossAxisCount: 2,
                pageLoadController: languageController,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 3 / 8,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
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
                            return AudiobyLanguage(
                              languageid: entry.id.toString(),
                              userid: widget.userid,
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorPrimary,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: MyText(
                          color: white,
                          text: entry.name.toString(),
                          textalign: TextAlign.center,
                          fontsize: 14,
                          inter: true,
                          maxline: 6,
                          fontwaight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal),
                    ),
                  );
                }),
          ),
        ]);
  }

  Widget languageShimmer() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          CustomWidget.roundrectborder(
              height: height! * 0.02, width: width! * 0.35),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return CustomWidget.rectangular(
                    height: height! * 0.07,
                  );
                }),
          ),
        ]);
  }

  Widget manualSearch() {
    return Consumer<SearchProvider>(
      builder: (context, searchprovider, child) {
        if (searchprovider.loading) {
          return manualSearchShimmer();
        } else {
          if (searchprovider.searchModel.status == 200 &&
              searchController.text.toString().isNotEmpty &&
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
                  fontstyle: FontStyle.normal,
                ),
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
                fontstyle: FontStyle.normal,
              ),
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
        // const SizedBox(height: 5),
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
