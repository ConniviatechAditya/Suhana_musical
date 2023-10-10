import 'dart:developer';
import 'package:dtpocketfm/pages/bottombar.dart';
import 'package:dtpocketfm/pages/musicdetails.dart';
import 'package:dtpocketfm/pages/nodata.dart';
import 'package:dtpocketfm/pages/package.dart';
import 'package:dtpocketfm/provider/detailprovider.dart';
import 'package:dtpocketfm/provider/playprovider.dart';
import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/constant.dart';
import 'package:dtpocketfm/utils/customwidget.dart';
import 'package:dtpocketfm/utils/musicmanager.dart';
import 'package:dtpocketfm/utils/utils.dart';
import 'package:dtpocketfm/widget/myimage.dart';
import 'package:dtpocketfm/widget/mynetworkimg.dart';
import 'package:dtpocketfm/widget/mytext.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import '../model/getepisodebyaudioidmodel.dart';

class Detail extends StatefulWidget {
  final String audioid, userid, categoryid, audioname;
  final bool? iscontinuewatching;
  const Detail(
      {super.key,
      required this.userid,
      required this.audioid,
      this.iscontinuewatching,
      required this.audioname,
      required this.categoryid});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> with SingleTickerProviderStateMixin {
  late DetailProvider detailprovider;
  final MusicManager musicManager = MusicManager();
  var scrollController = ScrollController();
  int position = 0;
  PageController pageController =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 1.0);
  final commentController = TextEditingController();
  double? rating;
  TabController? tabController;
  int pageno = 1;

// Comment ShowMore Item
  int commentincrement = 1;
  int commentrepeatincrement = 2;

  List<Map<String, dynamic>> commentList = [];
  List<Map<String, dynamic>> recommendedList = [];
  List<Map<String, dynamic>> castList = [];

  @override
  void initState() {
    detailprovider = Provider.of<DetailProvider>(context, listen: false);
    super.initState();
    debugPrint("isContinueWatching==> ${widget.iscontinuewatching}");
    tabController = TabController(
        length: Constant().myTabs.length, vsync: this, initialIndex: 0);
    tabchange();
    getApi();
  }

  tabchange() {
    tabController?.addListener(() {
      if (tabController?.index != pageController.page?.toInt()) {
        pageController.animateToPage(tabController!.index,
            duration: const Duration(milliseconds: 10), curve: Curves.linear);
      }
    });

    pageController.addListener(() {
      if (tabController?.index != pageController.page?.toInt()) {
        tabController?.animateTo(
          pageController.page?.toInt() ?? 0,
          duration: const Duration(milliseconds: 10),
          curve: Curves.ease,
        );
      }
    });
  }

  getApi() async {
    debugPrint("audioid=>${widget.audioid}");
    await detailprovider.getDetail(widget.audioid.toString(), widget.userid);
    await detailprovider.getEpisodebyAudioid(
        widget.userid, widget.audioid.toString(), "1");
    await detailprovider.getCommentbyAudioid(widget.userid.toString(),
        widget.audioid.toString(), commentincrement.toString());
    for (var i = 0;
        i < (detailprovider.getcommentbyaudioidModel.result?.length ?? 0);
        i++) {
      commentList.add({
        "image": detailprovider.getcommentbyaudioidModel.result?[i].image
                .toString() ??
            "",
        "comment": detailprovider.getcommentbyaudioidModel.result?[i].comment
                .toString() ??
            "",
        "fullname": detailprovider.getcommentbyaudioidModel.result?[i].fullName
                .toString() ??
            "",
        "israting": detailprovider.getcommentbyaudioidModel.result?[i].isRating
                .toString() ??
            "",
        "date": detailprovider.getcommentbyaudioidModel.result?[i].createdAt
                .toString() ??
            "",
      });
    }
    await detailprovider.getRelatedaudiobyAudioid(widget.audioid.toString(),
        commentincrement.toString(), widget.categoryid.toString());

    for (var i = 0;
        i < (detailprovider.getrelatedaudiobyaudioidModel.result?.length ?? 0);
        i++) {
      recommendedList.add({
        "image": detailprovider.getrelatedaudiobyaudioidModel.result?[i].image
                .toString() ??
            "",
        "played": detailprovider.getrelatedaudiobyaudioidModel.result?[i].played
                .toString() ??
            "",
        "audioid": detailprovider.getrelatedaudiobyaudioidModel.result?[i].id
                .toString() ??
            "",
        "categoryid": detailprovider
                .getrelatedaudiobyaudioidModel.result?[i].categoryId
                .toString() ??
            "",
        "title": detailprovider.getrelatedaudiobyaudioidModel.result?[i].title
                .toString() ??
            "",
        "israting": detailprovider
                .getrelatedaudiobyaudioidModel.result?[i].isRating
                .toString() ??
            "",
        "description": detailprovider
                .getrelatedaudiobyaudioidModel.result?[i].description
                .toString() ??
            "",
      });
    }

    await detailprovider.getCastbyAudioid(
        widget.audioid.toString(), commentincrement.toString());

    for (var i = 0;
        i < (detailprovider.getcastbyaudioidModel.result?.length ?? 0);
        i++) {
      castList.add({
        "image":
            detailprovider.getcastbyaudioidModel.result?[i].image.toString() ??
                "",
        "name":
            detailprovider.getcastbyaudioidModel.result?[i].name.toString() ??
                "",
        "type":
            detailprovider.getcastbyaudioidModel.result?[i].type.toString() ??
                "",
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    commentList.clear();
    recommendedList.clear();
    castList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: colorPrimaryDark,
          appBar: AppBar(
            backgroundColor: colorPrimaryDark,
            elevation: 0,
            centerTitle: false,
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
              child: Row(
                children: [
                  InkWell(
                    focusColor: gray.withOpacity(0.40),
                    hoverColor: gray.withOpacity(0.40),
                    highlightColor: gray.withOpacity(0.40),
                    onTap: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: MyImage(
                            width: 15, height: 15, imagePath: "ic_back.png")),
                  ),
                  const SizedBox(width: 10),
                  MyText(
                      color: white,
                      text: widget.audioname.toString(),
                      textalign: TextAlign.center,
                      fontsize: 14,
                      inter: true,
                      maxline: 6,
                      fontwaight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                      fontstyle: FontStyle.normal),
                ],
              ),
            ),
          ),
          body: Consumer<DetailProvider>(
            builder: (context, detailprovider, child) {
              if (detailprovider.loading) {
                return detailShimmer();
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            // Detail Image
                            Stack(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.40,
                                  foregroundDecoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        colorPrimaryDark.withOpacity(0.80),
                                        colorPrimaryDark.withOpacity(0.1),
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      stops: const [0.2, 0.9],
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: MyNetworkImage(
                                      imgWidth:
                                          MediaQuery.of(context).size.width,
                                      imgHeight:
                                          MediaQuery.of(context).size.height,
                                      imageUrl: detailprovider
                                              .detailModel.result?[0].image
                                              .toString() ??
                                          "",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  bottom: 5,
                                  left: 15,
                                  right: 15,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.50,
                                            child: MyText(
                                                color: white,
                                                text: detailprovider.detailModel
                                                        .result?[0].title
                                                        .toString() ??
                                                    "",
                                                textalign: TextAlign.left,
                                                fontsize: 16,
                                                inter: true,
                                                maxline: 3,
                                                fontwaight: FontWeight.w600,
                                                overflow: TextOverflow.ellipsis,
                                                fontstyle: FontStyle.normal),
                                          ),
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: colorAccent),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.watch_later_rounded,
                                                  color: white,
                                                ),
                                                const SizedBox(height: 5),
                                                MyText(
                                                    color: white,
                                                    text: Utils.convertMinute(
                                                      detailprovider
                                                              .detailModel
                                                              .result?[0]
                                                              .totalTime
                                                              .toString() ??
                                                          "",
                                                    ),
                                                    textalign: TextAlign.center,
                                                    fontsize: 10,
                                                    inter: true,
                                                    maxline: 6,
                                                    fontwaight: FontWeight.w500,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontstyle:
                                                        FontStyle.normal),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Space
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            // Plays,Review,Age Ristriction
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MyText(
                                        color: white,
                                        text: Utils.kmbGenerator(int.parse(
                                            detailprovider.detailModel
                                                    .result?[0].played
                                                    .toString() ??
                                                "")),
                                        textalign: TextAlign.center,
                                        fontsize: 16,
                                        inter: true,
                                        maxline: 6,
                                        fontwaight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis,
                                        fontstyle: FontStyle.normal),
                                    const SizedBox(height: 5),
                                    MyText(
                                        color: gray,
                                        text: "plays",
                                        textalign: TextAlign.center,
                                        fontsize: 10,
                                        inter: true,
                                        multilanguage: true,
                                        maxline: 6,
                                        fontwaight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis,
                                        fontstyle: FontStyle.normal),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 55,
                                      height: 20,
                                      padding: const EdgeInsets.all(2),
                                      margin: const EdgeInsets.only(top: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: yellow),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          MyImage(
                                              width: 12,
                                              height: 12,
                                              imagePath: "ic_star.png"),
                                          SizedBox(
                                            width: 30,
                                            child: MyText(
                                                color: black,
                                                text: detailprovider.detailModel
                                                        .result?[0].rating
                                                        .toString() ??
                                                    "",
                                                textalign: TextAlign.center,
                                                fontsize: 11,
                                                inter: true,
                                                maxline: 1,
                                                fontwaight: FontWeight.w600,
                                                overflow: TextOverflow.ellipsis,
                                                fontstyle: FontStyle.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        MyText(
                                            color: gray,
                                            text: Numeral(int.parse(
                                                    detailprovider
                                                            .detailModel
                                                            .result?[0]
                                                            .totalReviews
                                                            .toString() ??
                                                        ""))
                                                .format(),
                                            textalign: TextAlign.center,
                                            fontsize: 10,
                                            inter: true,
                                            maxline: 6,
                                            fontwaight: FontWeight.w500,
                                            overflow: TextOverflow.ellipsis,
                                            fontstyle: FontStyle.normal),
                                        const SizedBox(width: 2),
                                        MyText(
                                            color: gray,
                                            text: "reviews",
                                            textalign: TextAlign.center,
                                            fontsize: 10,
                                            multilanguage: true,
                                            inter: true,
                                            maxline: 6,
                                            fontwaight: FontWeight.w500,
                                            overflow: TextOverflow.ellipsis,
                                            fontstyle: FontStyle.normal),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 20,
                                      margin: const EdgeInsets.only(top: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: colorPrimary),
                                      child: MyText(
                                          color: white,
                                          text: "age",
                                          textalign: TextAlign.center,
                                          fontsize: 11,
                                          inter: true,
                                          maxline: 6,
                                          multilanguage: true,
                                          fontwaight: FontWeight.w400,
                                          overflow: TextOverflow.ellipsis,
                                          fontstyle: FontStyle.normal),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        MyText(
                                            color: gray,
                                            text:
                                                "${detailprovider.detailModel.result?[0].ageRestriction.toString() ?? ""}+",
                                            textalign: TextAlign.center,
                                            fontsize: 10,
                                            inter: true,
                                            maxline: 6,
                                            fontwaight: FontWeight.w500,
                                            overflow: TextOverflow.ellipsis,
                                            fontstyle: FontStyle.normal),
                                        const SizedBox(width: 2),
                                        MyText(
                                            color: gray,
                                            text: "above",
                                            multilanguage: true,
                                            textalign: TextAlign.center,
                                            fontsize: 10,
                                            inter: true,
                                            maxline: 6,
                                            fontwaight: FontWeight.w500,
                                            overflow: TextOverflow.ellipsis,
                                            fontstyle: FontStyle.normal),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: white, width: 1),
                                    color: divider,
                                  ),
                                  child: MyText(
                                      color: white,
                                      text: "English",
                                      textalign: TextAlign.center,
                                      fontsize: 11,
                                      inter: true,
                                      maxline: 1,
                                      fontwaight: FontWeight.w400,
                                      overflow: TextOverflow.ellipsis,
                                      fontstyle: FontStyle.normal),
                                ),
                              ],
                            ),
                            // Space
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06),
                            // Play Button and Save Video Button
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: InkWell(
                                      onTap: () async {
                                        log("time ${detailprovider.getepisodebyaudioidModel.result?[0].stopTime.toString() ?? ""}");
                                        playAudio(
                                          detailprovider
                                                  .getepisodebyaudioidModel
                                                  .result?[0]
                                                  .id
                                                  .toString() ??
                                              "",
                                          detailprovider
                                                  .detailModel.result?[0].id
                                                  .toString() ??
                                              "",
                                          0,
                                          detailprovider
                                                  .getepisodebyaudioidModel
                                                  .result ??
                                              [],
                                          detailprovider
                                                  .detailModel.result?[0].title
                                                  .toString() ??
                                              "",
                                          int.parse(
                                            detailprovider
                                                    .getepisodebyaudioidModel
                                                    .result?[0]
                                                    .stopTime
                                                    .toString() ??
                                                "",
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            color: colorAccent),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            MyImage(
                                                width: 20,
                                                height: 20,
                                                color: white,
                                                imagePath: "play.png"),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02,
                                            ),
                                            MyText(
                                              color: white,
                                              text: "play",
                                              textalign: TextAlign.center,
                                              fontsize: 16,
                                              multilanguage: true,
                                              inter: true,
                                              maxline: 6,
                                              fontwaight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis,
                                              fontstyle: FontStyle.normal,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () async {
                                        if (widget.userid.isEmpty ||
                                            widget.userid == "") {
                                          Utils.openLogin(
                                              context: context,
                                              isHome: false,
                                              isReplace: false);
                                        } else {
                                          debugPrint(
                                              "isBookmark ====> ${detailprovider.detailModel.result?[0].isBookmark ?? 0}");
                                          await detailprovider.setBookMark(
                                            context,
                                            widget.audioid,
                                            widget.userid,
                                          );
                                        }
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          shape: BoxShape.rectangle,
                                          gradient: LinearGradient(
                                            colors: [
                                              yellow.withOpacity(0.8),
                                              diffrentyellow.withOpacity(0.3),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                        ),
                                        child: MyText(
                                            color: black,
                                            text: detailprovider.detailModel
                                                        .result?[0].isBookmark
                                                        .toString() ==
                                                    "1"
                                                ? "remove"
                                                : "save",
                                            multilanguage: true,
                                            textalign: TextAlign.center,
                                            fontsize: 16,
                                            inter: true,
                                            maxline: 6,
                                            fontwaight: FontWeight.w600,
                                            overflow: TextOverflow.ellipsis,
                                            fontstyle: FontStyle.normal),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Add Review and Rating
                            InkWell(
                              onTap: () {
                                if (widget.userid.isEmpty &&
                                    widget.userid == "") {
                                  Utils.openLogin(
                                      context: context,
                                      isHome: false,
                                      isReplace: false);
                                } else {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return Dialog(
                                        elevation: 5,
                                        insetPadding: const EdgeInsets.all(25),
                                        insetAnimationCurve: Curves.easeInExpo,
                                        insetAnimationDuration:
                                            const Duration(seconds: 1),
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.40,
                                          decoration: BoxDecoration(
                                              color: colorPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                child: Row(
                                                  children: [
                                                    MyText(
                                                        color: white,
                                                        text: "Review & Rating",
                                                        textalign:
                                                            TextAlign.center,
                                                        fontsize: 14,
                                                        inter: true,
                                                        maxline: 1,
                                                        fontwaight:
                                                            FontWeight.w500,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontstyle:
                                                            FontStyle.normal),
                                                    const Spacer(),
                                                    RatingBar(
                                                      initialRating: 0.0,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: false,
                                                      itemSize: 25,
                                                      glowColor: orange,
                                                      unratedColor: orange,
                                                      itemCount: 5,
                                                      ratingWidget:
                                                          RatingWidget(
                                                              full: const Icon(
                                                                Icons.star,
                                                                color: orange,
                                                              ),
                                                              half: const Icon(
                                                                  Icons
                                                                      .star_half,
                                                                  color:
                                                                      orange),
                                                              empty: const Icon(
                                                                  Icons
                                                                      .star_border,
                                                                  color:
                                                                      orange)),
                                                      onRatingUpdate:
                                                          (double value) {
                                                        debugPrint(
                                                            "rating=> $value");
                                                        rating = value;
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                color: white,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1,
                                              ),
                                              const SizedBox(height: 5),
                                              TextField(
                                                maxLines: null,
                                                minLines: null,
                                                controller: commentController,
                                                style: GoogleFonts.inter(
                                                  color: white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textInputAction:
                                                    TextInputAction.newline,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: colorPrimary),
                                                  ),
                                                  disabledBorder:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: colorPrimary),
                                                  ),
                                                  focusedBorder:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: colorPrimary),
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          15, 10, 15, 10),
                                                  hintText: 'Comment',
                                                  hintStyle: GoogleFonts.inter(
                                                    color: gray,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 0, 8, 0),
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      flex: 1,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          final detailprovider =
                                                              Provider.of<
                                                                      DetailProvider>(
                                                                  context,
                                                                  listen:
                                                                      false);

                                                          if (commentController
                                                                  .text
                                                                  .toString()
                                                                  .isEmpty ||
                                                              commentController
                                                                      .text
                                                                      .toString() ==
                                                                  "") {
                                                          } else if (rating ==
                                                                  0.0 ||
                                                              rating == null) {
                                                          } else {
                                                            Navigator.pop(
                                                                context);

                                                            await detailprovider
                                                                .getAddreview(
                                                              widget.userid,
                                                              detailprovider
                                                                      .detailModel
                                                                      .result?[
                                                                          0]
                                                                      .id
                                                                      .toString() ??
                                                                  "",
                                                              commentController
                                                                  .text
                                                                  .toString(),
                                                            );

                                                            await detailprovider
                                                                .getAddrating(
                                                              widget.userid,
                                                              detailprovider
                                                                      .detailModel
                                                                      .result?[
                                                                          0]
                                                                      .id
                                                                      .toString() ??
                                                                  "",
                                                              rating.toString(),
                                                            );

                                                            if (detailprovider
                                                                .loading) {
                                                              if (!mounted) {
                                                                return;
                                                              }
                                                              Utils().showProgress(
                                                                  context,
                                                                  "Please Wait");
                                                            } else {
                                                              if (detailprovider
                                                                          .addreviewModel
                                                                          .status ==
                                                                      200 &&
                                                                  detailprovider
                                                                          .addratingModel
                                                                          .status ==
                                                                      200) {
                                                                await detailprovider.getCommentbyAudioid(
                                                                    widget
                                                                        .userid
                                                                        .toString(),
                                                                    widget
                                                                        .audioid
                                                                        .toString(),
                                                                    commentincrement
                                                                        .toString());

                                                                commentList
                                                                    .clear();

                                                                for (var i = 0;
                                                                    i <
                                                                        (detailprovider.getcommentbyaudioidModel.result?.length ??
                                                                            0);
                                                                    i++) {
                                                                  commentList
                                                                      .add({
                                                                    "image": detailprovider
                                                                            .getcommentbyaudioidModel
                                                                            .result?[i]
                                                                            .image
                                                                            .toString() ??
                                                                        "",
                                                                    "comment": detailprovider
                                                                            .getcommentbyaudioidModel
                                                                            .result?[i]
                                                                            .comment
                                                                            .toString() ??
                                                                        "",
                                                                    "fullname": detailprovider
                                                                            .getcommentbyaudioidModel
                                                                            .result?[i]
                                                                            .fullName
                                                                            .toString() ??
                                                                        "",
                                                                    "israting": detailprovider
                                                                            .getcommentbyaudioidModel
                                                                            .result?[i]
                                                                            .isRating
                                                                            .toString() ??
                                                                        "",
                                                                    "date": detailprovider
                                                                            .getcommentbyaudioidModel
                                                                            .result?[i]
                                                                            .createdAt
                                                                            .toString() ??
                                                                        "",
                                                                  });
                                                                }

                                                                commentController
                                                                    .clear();
                                                                rating == 0.0;

                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                Utils()
                                                                    .hideProgress(
                                                                        context);
                                                                setState(() {});
                                                              } else {
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                Utils()
                                                                    .hideProgress(
                                                                        context);
                                                              }
                                                            }
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 45,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              color:
                                                                  colorAccent),
                                                          alignment:
                                                              Alignment.center,
                                                          child: MyText(
                                                              color: white,
                                                              text: "Add",
                                                              textalign:
                                                                  TextAlign
                                                                      .center,
                                                              fontsize: 14,
                                                              inter: true,
                                                              maxline: 1,
                                                              fontwaight:
                                                                  FontWeight
                                                                      .w500,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              fontstyle:
                                                                  FontStyle
                                                                      .normal),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Flexible(
                                                      flex: 1,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          height: 45,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              color:
                                                                  colorAccent),
                                                          alignment:
                                                              Alignment.center,
                                                          child: MyText(
                                                              color: white,
                                                              text: "Cancel",
                                                              textalign:
                                                                  TextAlign
                                                                      .center,
                                                              fontsize: 14,
                                                              inter: true,
                                                              maxline: 1,
                                                              fontwaight:
                                                                  FontWeight
                                                                      .w500,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              fontstyle:
                                                                  FontStyle
                                                                      .normal),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.all(15),
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(7),
                                    color: colorPrimary),
                                child: MyText(
                                    color: white,
                                    text: "addreviewandrating",
                                    multilanguage: true,
                                    textalign: TextAlign.center,
                                    fontsize: 16,
                                    inter: true,
                                    maxline: 6,
                                    fontwaight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    fontstyle: FontStyle.normal),
                              ),
                            ),
                            // Space
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            // Discription
                            Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: ReadMoreText(
                                detailprovider
                                        .detailModel.result?[0].description
                                        .toString() ??
                                    "",
                                trimLines: 5,
                                preDataTextStyle: const TextStyle(
                                    fontWeight: FontWeight.w400),
                                style:
                                    const TextStyle(color: white, fontSize: 14),
                                colorClickableText: yellow,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: '  Read More',
                                trimExpandedText: ' Read less',
                              ),
                            ),
                            // Space
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),

                            // TabBar Title
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TabBar(
                                controller: tabController,
                                labelPadding: const EdgeInsets.only(left: 15),
                                isScrollable: true,
                                labelColor: colorAccent,
                                indicatorPadding:
                                    const EdgeInsets.only(left: 15),
                                physics: const BouncingScrollPhysics(),
                                unselectedLabelColor: gray,
                                indicator: const UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: colorAccent,
                                  ),
                                ),
                                indicatorColor: colorAccent,
                                labelStyle: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontStyle: FontStyle.normal,
                                  color: colorAccent,
                                  fontWeight: FontWeight.w500,
                                ),
                                unselectedLabelStyle: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontStyle: FontStyle.normal,
                                  color: white,
                                  fontWeight: FontWeight.w400,
                                ),
                                padding: const EdgeInsets.all(0),
                                indicatorSize: TabBarIndicatorSize.label,
                                onTap: (value) {
                                  tabchange();
                                },
                                tabs: Constant().myTabs,
                              ),
                            ),
                            // Expandable Pageview With Tabbar
                            ExpandablePageView(
                              controller: pageController,
                              children: [
                                episodeItem(),
                                detailItem(),
                              ],
                            ),
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
                );
              }
            },
          ),
        ),
        _buildMusicPanel(context),
      ],
    );
  }

  Widget detailShimmer() {
    return NestedScrollView(
      controller: scrollController,
      floatHeaderSlivers: false,
      /*profile Item*/
      body: DefaultTabController(
        length: 1,
        child: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: [
            episodeListShimmer(),
          ],
        ),
      ),
      physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
      scrollDirection: Axis.vertical,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.40,
                  foregroundDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorPrimaryDark.withOpacity(0.2),
                        colorPrimaryDark.withOpacity(0.2),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [0.05, 0.9],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Stack(
                      children: [
                        CustomWidget.roundrectborder(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomWidget.roundrectborder(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.15,
                        ),
                        const SizedBox(height: 5),
                        CustomWidget.roundrectborder(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.15,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomWidget.roundrectborder(
                          height: 20,
                          width: 50,
                        ),
                        const SizedBox(height: 5),
                        CustomWidget.roundrectborder(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.15,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomWidget.roundrectborder(
                          height: 20,
                          width: 50,
                        ),
                        const SizedBox(height: 5),
                        CustomWidget.roundrectborder(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.15,
                        ),
                      ],
                    ),
                    CustomWidget.roundrectborder(
                        height: 20,
                        width: MediaQuery.of(context).size.width * 0.15),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: CustomWidget.roundrectborder(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.06,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        flex: 1,
                        child: CustomWidget.roundrectborder(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.06,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomWidget.roundrectborder(
                        width: MediaQuery.of(context).size.width * 0.60,
                        height: 8,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      CustomWidget.roundrectborder(
                        width: MediaQuery.of(context).size.width * 0.70,
                        height: 8,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      CustomWidget.roundrectborder(
                        width: MediaQuery.of(context).size.width * 0.50,
                        height: 8,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      CustomWidget.roundrectborder(
                        width: MediaQuery.of(context).size.width * 0.80,
                        height: 8,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CustomWidget.circular(
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomWidget.roundrectborder(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: 12,
                          ),
                          const SizedBox(height: 5),
                          CustomWidget.roundrectborder(
                            width: MediaQuery.of(context).size.width * 0.18,
                            height: 10,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.height * 0.05,
                      ),
                      const CustomWidget.circular(
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomWidget.roundrectborder(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: 12,
                          ),
                          const SizedBox(height: 5),
                          CustomWidget.roundrectborder(
                            width: MediaQuery.of(context).size.width * 0.18,
                            height: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 50,
                        alignment: Alignment.center,
                        child: CustomWidget.roundrectborder(
                          width: MediaQuery.of(context).size.width,
                          height: 30,
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.height * 0.02),
                      Container(
                        width: 100,
                        height: 50,
                        alignment: Alignment.center,
                        child: CustomWidget.roundrectborder(
                          width: MediaQuery.of(context).size.width,
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ];
      },
    );
  }

  Widget episodeItem() {
    return Wrap(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.010),
        episodeList(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.010),
      ],
    );
  }

  Widget episodeList() {
    return Consumer<DetailProvider>(
      builder: (context, episodeprovider, child) {
        if (episodeprovider.loading) {
          return episodeListShimmer();
        } else {
          if (episodeprovider.getepisodebyaudioidModel.status == 200 &&
              episodeprovider.getepisodebyaudioidModel.result != null) {
            return MediaQuery.removePadding(
              context: context,
              removeBottom: true,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount:
                    episodeprovider.getepisodebyaudioidModel.result?.length ??
                        0,
                itemBuilder: (BuildContext ctx, index) {
                  position = index;
                  return InkWell(
                    onTap: () async {
                      log("userid=>${widget.userid}");
                      debugPrint(
                          "click time=>${episodeprovider.getepisodebyaudioidModel.result?[index].stopTime}");
                      playAudio(
                        episodeprovider
                                .getepisodebyaudioidModel.result?[index].id
                                .toString() ??
                            "",
                        episodeprovider.detailModel.result?[0].id.toString() ??
                            "",
                        index,
                        episodeprovider.getepisodebyaudioidModel.result ?? [],
                        episodeprovider.detailModel.result?[0].title
                                .toString() ??
                            "",
                        int.parse(episodeprovider.getepisodebyaudioidModel
                                .result?[index].stopTime
                                .toString() ??
                            ""),
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      margin: const EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          MyText(
                            color: white,
                            text: "${index + 1}",
                            textalign: TextAlign.center,
                            fontsize: 14,
                            inter: true,
                            maxline: 6,
                            fontwaight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                            fontstyle: FontStyle.normal,
                          ),
                          const SizedBox(width: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: MyNetworkImage(
                              imgWidth:
                                  MediaQuery.of(context).size.width * 0.16,
                              imgHeight: MediaQuery.of(context).size.height,
                              fit: BoxFit.cover,
                              imageUrl: episodeprovider.getepisodebyaudioidModel
                                      .result?[index].image
                                      .toString() ??
                                  "",
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyText(
                                  color: colorAccent,
                                  text: episodeprovider.getepisodebyaudioidModel
                                          .result?[index].name
                                          .toString() ??
                                      "",
                                  textalign: TextAlign.left,
                                  fontsize: 14,
                                  inter: true,
                                  maxline: 1,
                                  fontwaight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal,
                                ),
                                const SizedBox(width: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if ((episodeprovider
                                            .getepisodebyaudioidModel
                                            .result?[index]
                                            .played) !=
                                        null)
                                      MyText(
                                        color: darkgray,
                                        text: Utils.kmbGenerator(int.parse(
                                            episodeprovider
                                                    .getepisodebyaudioidModel
                                                    .result?[index]
                                                    .played
                                                    .toString() ??
                                                "")),
                                        textalign: TextAlign.left,
                                        fontsize: 12,
                                        inter: true,
                                        maxline: 1,
                                        fontwaight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis,
                                        fontstyle: FontStyle.normal,
                                      ),
                                    const SizedBox(width: 8),
                                    if ((episodeprovider
                                            .getepisodebyaudioidModel
                                            .result?[index]
                                            .audioDuration) !=
                                        null)
                                      MyText(
                                        color: darkgray,
                                        text: Utils.formatDuration(double.parse(
                                          episodeprovider
                                                  .getepisodebyaudioidModel
                                                  .result?[index]
                                                  .audioDuration
                                                  .toString() ??
                                              "",
                                        )),
                                        textalign: TextAlign.left,
                                        fontsize: 12,
                                        inter: true,
                                        maxline: 6,
                                        fontwaight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis,
                                        fontstyle: FontStyle.normal,
                                      ),
                                    // const SizedBox(width: 8),
                                    // if ((episodeprovider
                                    //         .getepisodebyaudioidModel
                                    //         .result?[index]
                                    //         .createdAt) !=
                                    //     null)
                                    //   MyText(
                                    //     color: darkgray,
                                    //     text: Utils.timeAgoCustom(
                                    //       DateTime.parse(
                                    //         episodeprovider
                                    //                 .getepisodebyaudioidModel
                                    //                 .result?[index]
                                    //                 .createdAt ??
                                    //             "",
                                    //       ),
                                    //     ),
                                    //     textalign: TextAlign.left,
                                    //     fontsize: 12,
                                    //     inter: true,
                                    //     maxline: 6,
                                    //     fontwaight: FontWeight.w500,
                                    //     overflow: TextOverflow.ellipsis,
                                    //     fontstyle: FontStyle.normal,
                                    //   ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // MyImage(
                          //   width: 20,
                          //   height: 20,
                          //   imagePath: "ic_download.png",
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const NoData();
          }
        }
      },
    );
  }

  Widget episodeListShimmer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      child: MediaQuery.removePadding(
        removeTop: true,
        removeBottom: true,
        context: context,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (BuildContext ctx, index) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.08,
              margin: const EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  const CustomWidget.rectangular(
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.height * 0.01),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CustomWidget.circular(
                      width: MediaQuery.of(context).size.width * 0.16,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.height * 0.01),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomWidget.roundrectborder(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: 12,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomWidget.roundrectborder(
                              width: MediaQuery.of(context).size.width * 0.10,
                              height: 12,
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.height * 0.01),
                            CustomWidget.roundrectborder(
                              width: MediaQuery.of(context).size.width * 0.10,
                              height: 12,
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.height * 0.01),
                            CustomWidget.roundrectborder(
                              width: MediaQuery.of(context).size.width * 0.10,
                              height: 12,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  const CustomWidget.circular(
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget detailItem() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          space(0.02),
          detailList(),
          space(0.02),
        ],
      ),
    );
  }

  Widget detailList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topReview(),
          // topsearchSection(),
          recomanded("recommendedforyou"),
          castcrow("castandcrew"),
        ],
      ),
    );
  }

  Widget topReview() {
    return Consumer<DetailProvider>(
      builder: (context, commentprovider, child) {
        if (commentprovider.loading) {
          return Utils.pageLoader();
        } else {
          if (commentprovider.getcommentbyaudioidModel.status == 200 &&
              (commentprovider.getcommentbyaudioidModel.result?.length ?? 0) >
                  0) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                space(0.02),
                MyText(
                  color: white,
                  text: "topreviews",
                  textalign: TextAlign.center,
                  multilanguage: true,
                  fontsize: 16,
                  inter: true,
                  maxline: 1,
                  fontwaight: FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                  fontstyle: FontStyle.normal,
                ),
                space(0.02),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: commentList.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: MyNetworkImage(
                              imgWidth: 55,
                              imgHeight: 55,
                              imageUrl: commentList[index]["image"].toString(),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.height * 0.01),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          MyText(
                                              color: white,
                                              text: (commentprovider
                                                              .getcommentbyaudioidModel
                                                              .status ==
                                                          200 &&
                                                      (commentList[index]
                                                                  ["fullname"]
                                                              .toString())
                                                          .isEmpty)
                                                  ? "Login User"
                                                  : commentprovider
                                                              .getcommentbyaudioidModel
                                                              .status ==
                                                          200
                                                      ? (commentprovider
                                                              .getcommentbyaudioidModel
                                                              .result?[index]
                                                              .fullName
                                                              .toString() ??
                                                          "Guest User")
                                                      : "",
                                              textalign: TextAlign.left,
                                              fontsize: 16,
                                              inter: true,
                                              maxline: 1,
                                              fontwaight: FontWeight.w500,
                                              overflow: TextOverflow.ellipsis,
                                              fontstyle: FontStyle.normal),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01,
                                          ),
                                          MyText(
                                              color: darkgray,
                                              text: Utils.dateFormat(
                                                  commentList[0]["date"]
                                                      .toString(),
                                                  "dd MMMM yy"),
                                              textalign: TextAlign.center,
                                              fontsize: 10,
                                              inter: true,
                                              maxline: 1,
                                              fontwaight: FontWeight.w400,
                                              overflow: TextOverflow.ellipsis,
                                              fontstyle: FontStyle.normal),
                                        ],
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
                                      RatingBar(
                                        initialRating: 5.0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: int.parse(commentList[index]
                                                    ["israting"]
                                                ?.toString() ??
                                            ""),
                                        itemSize: 10,
                                        ratingWidget: RatingWidget(
                                          full: MyImage(
                                            width: 10,
                                            height: 10,
                                            imagePath: "ic_star.png",
                                            color: yellow,
                                          ),
                                          half: MyImage(
                                              width: 10,
                                              height: 10,
                                              imagePath: "ic_star.png",
                                              color: yellow),
                                          empty: MyImage(
                                              width: 10,
                                              height: 10,
                                              imagePath: "ic_star.png",
                                              color: yellow),
                                        ),
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 1.0),
                                        onRatingUpdate: (double value) {},
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02),
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: MyText(
                                  color: darkgray,
                                  text: commentList[index]["comment"],
                                  textalign: TextAlign.left,
                                  fontsize: 10,
                                  inter: true,
                                  maxline: 8,
                                  fontwaight: FontWeight.w400,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal,
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                commentprovider.getcommentbyaudioidModel.morePage == true
                    ? Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () async {
                            debugPrint(
                                "orignal lenght:-${commentprovider.getcommentbyaudioidModel.result?.length}");
                            debugPrint(
                                "commetlist lenght:-${commentList.length}");
                            int increaseData = commentrepeatincrement++;
                            debugPrint("increment:-$increaseData");
                            await commentprovider.getCommentbyAudioid(
                                widget.userid.toString(),
                                widget.audioid.toString(),
                                commentrepeatincrement.toString());

                            for (var i = 0;
                                i <
                                    (commentprovider.getcommentbyaudioidModel
                                            .result?.length ??
                                        0);
                                i++) {
                              commentList.add({
                                "image": commentprovider
                                        .getcommentbyaudioidModel
                                        .result?[i]
                                        .image
                                        .toString() ??
                                    "",
                                "comment": commentprovider
                                        .getcommentbyaudioidModel
                                        .result?[i]
                                        .comment
                                        .toString() ??
                                    "",
                                "fullname": commentprovider
                                        .getcommentbyaudioidModel
                                        .result?[i]
                                        .fullName
                                        .toString() ??
                                    "",
                                "israting": commentprovider
                                        .getcommentbyaudioidModel
                                        .result?[i]
                                        .isRating
                                        .toString() ??
                                    "",
                                "date": commentprovider.getcommentbyaudioidModel
                                        .result?[i].createdAt
                                        .toString() ??
                                    "",
                              });
                            }
                          },
                          child: Column(
                            children: [
                              MyText(
                                color: white,
                                text: "showmore",
                                fontsize: 14,
                                inter: true,
                                multilanguage: true,
                                fontwaight: FontWeight.w500,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal,
                              ),
                              space(0.01),
                              MyImage(
                                width: 20,
                                height: 20,
                                color: white,
                                imagePath: "ic_showmorearrow.png",
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget recomanded(String label) {
    return Consumer<DetailProvider>(
      builder: (context, relatedaudioprovider, child) {
        if (relatedaudioprovider.loading) {
          return recomandedShimmer();
        } else {
          if (relatedaudioprovider.getrelatedaudiobyaudioidModel.status ==
                  200 &&
              relatedaudioprovider.getrelatedaudiobyaudioidModel.result !=
                  null) {
            if ((relatedaudioprovider
                        .getrelatedaudiobyaudioidModel.result?.length ??
                    0) >
                0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  MyText(
                      color: white,
                      text: label,
                      multilanguage: true,
                      textalign: TextAlign.center,
                      fontsize: 16,
                      inter: true,
                      maxline: 1,
                      fontwaight: FontWeight.w400,
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
                      itemCount: recommendedList.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Detail(
                                    audioname: recommendedList[index]["title"]
                                        .toString(),
                                    audioid: recommendedList[index]["audioid"]
                                        .toString(),
                                    userid: widget.userid,
                                    categoryid: recommendedList[index]
                                            ["categoryid"]
                                        .toString(),
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.09,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: MyNetworkImage(
                                      imgWidth:
                                          MediaQuery.of(context).size.width *
                                              0.21,
                                      fit: BoxFit.cover,
                                      imgHeight:
                                          MediaQuery.of(context).size.height,
                                      imageUrl: recommendedList[index]["image"]
                                          .toString()),
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
                                          text: recommendedList[index]["title"]
                                              .toString()
                                              .toString(),
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
                                              text: Numeral(int.parse(
                                                recommendedList[index]["played"]
                                                    .toString(),
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
                                          text: recommendedList[index]
                                                  ["description"]
                                              .toString(),
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
                                  width: 50,
                                  height: 20,
                                  margin: const EdgeInsets.only(top: 5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: yellow),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      MyImage(
                                          width: 12,
                                          height: 12,
                                          imagePath: "ic_star.png"),
                                      MyText(
                                          color: black,
                                          text: recommendedList[index]
                                                  ["israting"]
                                              .toString(),
                                          textalign: TextAlign.center,
                                          fontsize: 11,
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
                  ),
                  relatedaudioprovider.getrelatedaudiobyaudioidModel.morePage ==
                          true
                      ? Align(
                          alignment: Alignment.center,
                          child: InkWell(
                              onTap: () async {
                                debugPrint(
                                    "orignal lenght:-${relatedaudioprovider.getrelatedaudiobyaudioidModel.result?.length}");
                                debugPrint(
                                    "commetlist lenght:-${commentList.length}");
                                int increaseData = commentrepeatincrement++;
                                debugPrint("increment:-$increaseData");
                                await relatedaudioprovider
                                    .getRelatedaudiobyAudioid(
                                        widget.audioid.toString(),
                                        commentrepeatincrement.toString(),
                                        widget.categoryid.toString());

                                for (var i = 0;
                                    i <
                                        (relatedaudioprovider
                                                .getrelatedaudiobyaudioidModel
                                                .result
                                                ?.length ??
                                            0);
                                    i++) {
                                  recommendedList.add({
                                    "image": relatedaudioprovider
                                            .getrelatedaudiobyaudioidModel
                                            .result?[i]
                                            .image
                                            .toString() ??
                                        "",
                                    "played": relatedaudioprovider
                                            .getrelatedaudiobyaudioidModel
                                            .result?[i]
                                            .played
                                            .toString() ??
                                        "",
                                    "title": relatedaudioprovider
                                            .getrelatedaudiobyaudioidModel
                                            .result?[i]
                                            .title
                                            .toString() ??
                                        "",
                                    "israting": relatedaudioprovider
                                            .getrelatedaudiobyaudioidModel
                                            .result?[i]
                                            .isRating
                                            .toString() ??
                                        "",
                                    "description": relatedaudioprovider
                                            .getrelatedaudiobyaudioidModel
                                            .result?[i]
                                            .description
                                            .toString() ??
                                        "",
                                  });
                                }
                              },
                              child: Column(
                                children: [
                                  MyText(
                                      color: white,
                                      text: "Show more",
                                      fontsize: 14,
                                      inter: true,
                                      fontwaight: FontWeight.w500,
                                      maxline: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textalign: TextAlign.left,
                                      fontstyle: FontStyle.normal),
                                  space(0.01),
                                  MyImage(
                                      width: 20,
                                      height: 20,
                                      color: white,
                                      imagePath: "ic_showmorearrow.png"),
                                ],
                              )),
                        )
                      : const SizedBox.shrink(),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget recomandedShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        CustomWidget.roundrectborder(
          width: MediaQuery.of(context).size.width * 0.35,
          height: 15,
        ),
        const SizedBox(height: 5),
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 3,
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
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: 12,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const CustomWidget.circular(
                                  width: 15,
                                  height: 15,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                CustomWidget.roundrectborder(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  height: 12,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            CustomWidget.roundrectborder(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                      const CustomWidget.roundrectborder(
                        width: 50,
                        height: 20,
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

  Widget castcrow(String label) {
    return Consumer<DetailProvider>(builder: (context, castprovider, child) {
      if (castprovider.loading) {
        return castcrowShimmer();
      } else {
        if (castprovider.getcastbyaudioidModel.status == 200 &&
            castprovider.getcastbyaudioidModel.result != null) {
          if ((castprovider.getcastbyaudioidModel.result?.length ?? 0) > 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                MyText(
                    color: white,
                    text: label,
                    textalign: TextAlign.center,
                    fontsize: 16,
                    multilanguage: true,
                    inter: true,
                    maxline: 1,
                    fontwaight: FontWeight.w400,
                    overflow: TextOverflow.ellipsis,
                    fontstyle: FontStyle.normal),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: castList.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: MyNetworkImage(
                                  imgWidth: 45,
                                  fit: BoxFit.cover,
                                  imgHeight: 45,
                                  imageUrl:
                                      castList[index]["image"].toString()),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyText(
                                      color: white,
                                      text: castList[index]["name"].toString(),
                                      fontsize: 14,
                                      inter: true,
                                      fontwaight: FontWeight.w500,
                                      maxline: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textalign: TextAlign.left,
                                      fontstyle: FontStyle.normal),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  MyText(
                                      color: darkgray,
                                      text:
                                          castList[index]["type"].toString() ==
                                                  "1"
                                              ? "Writer"
                                              : "Speaker",
                                      textalign: TextAlign.center,
                                      fontsize: 12,
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
                      );
                    },
                  ),
                ),
                castprovider.getcastbyaudioidModel.morePage == true
                    ? Align(
                        alignment: Alignment.center,
                        child: InkWell(
                            onTap: () async {
                              debugPrint(
                                  "orignal lenght:-${castprovider.getcastbyaudioidModel.result?.length}");
                              debugPrint(
                                  "commetlist lenght:-${commentList.length}");
                              int increaseData = commentrepeatincrement++;
                              debugPrint("increment:-$increaseData");
                              await castprovider.getCastbyAudioid(
                                  widget.audioid.toString(),
                                  commentrepeatincrement.toString());

                              for (var i = 0;
                                  i <
                                      (castprovider.getcastbyaudioidModel.result
                                              ?.length ??
                                          0);
                                  i++) {
                                castList.add({
                                  "image": castprovider.getcastbyaudioidModel
                                          .result?[i].image
                                          .toString() ??
                                      "",
                                  "name": castprovider
                                          .getcastbyaudioidModel.result?[i].name
                                          .toString() ??
                                      "",
                                  "type": castprovider
                                          .getcastbyaudioidModel.result?[i].type
                                          .toString() ??
                                      "",
                                });
                              }
                            },
                            child: Column(
                              children: [
                                MyText(
                                    color: white,
                                    text: "Show more",
                                    fontsize: 14,
                                    inter: true,
                                    fontwaight: FontWeight.w500,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.left,
                                    fontstyle: FontStyle.normal),
                                space(0.01),
                                MyImage(
                                    width: 20,
                                    height: 20,
                                    color: white,
                                    imagePath: "ic_showmorearrow.png"),
                              ],
                            )),
                      )
                    : const SizedBox.shrink(),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

  Widget castcrowShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        CustomWidget.roundrectborder(
          width: MediaQuery.of(context).size.width * 0.35,
          height: 15,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (BuildContext ctx, index) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.07,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: white,
                ),
                margin: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CustomWidget.circular(
                      width: 45,
                      height: 45,
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
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: 12,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          CustomWidget.roundrectborder(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                    const CustomWidget.roundcorner(
                      width: 65,
                      height: 30,
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

  Widget space(double space) {
    return SizedBox(height: MediaQuery.of(context).size.height * space);
  }

  Future<void> playAudio(String episodeid, String audioid, int position,
      List<Result>? sectionBannerList, String audioname, int stoptime) async {
    if (widget.userid.isEmpty || widget.userid.toString() == "") {
      Utils.openLogin(context: context, isHome: false, isReplace: false);
    } else if (detailprovider.detailModel.result?[0].isPremium.toString() ==
        "1") {
      if (detailprovider.detailModel.result?[0].isBuy.toString() == "0") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Package(userid: widget.userid);
            },
          ),
        );
      } else {
        log("time ${detailprovider.getepisodebyaudioidModel.result?[0].stopTime.toString() ?? ""}");
        musicManager.setInitialPlaylist(
            position,
            sectionBannerList,
            addAudioApi(episodeid, audioid),
            audioid,
            widget.iscontinuewatching,
            stoptime);
      }
    } else {
      log("time ${detailprovider.getepisodebyaudioidModel.result?[0].stopTime.toString() ?? ""}");
      musicManager.setInitialPlaylist(
          position,
          sectionBannerList,
          addAudioApi(episodeid, audioid),
          audioid,
          widget.iscontinuewatching,
          stoptime);
    }
  }

  addAudioApi(String episodeid, String audioid) async {
    final playprovider = Provider.of<PlayProvider>(context, listen: false);
    debugPrint("episodeid=> $episodeid");
    await playprovider.getaddAudioplay(
        widget.userid.toString(), episodeid.toString());
  }

  Widget _buildMusicPanel(context) {
    return ValueListenableBuilder(
      valueListenable: currentlyPlaying,
      builder: (BuildContext context, AudioPlayer? audioObject, Widget? child) {
        if (audioObject?.audioSource != null) {
          return MusicDetails(
            ishomepage: false,
            audioid:
                ((audioPlayer.sequenceState?.currentSource?.tag as MediaItem?)
                        ?.album)
                    .toString(),
            episodeid:
                ((audioPlayer.sequenceState?.currentSource?.tag as MediaItem?)
                        ?.id)
                    .toString(),
            stoptime: audioPlayer.position.toString(),
            userid: widget.userid.toString(),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
