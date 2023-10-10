import 'package:dtpocketfm/model/addrating.dart';
import 'package:dtpocketfm/model/addreviewmodel.dart';
import 'package:dtpocketfm/model/bookmarkmodel.dart';
import 'package:dtpocketfm/model/detailmodel.dart';
import 'package:dtpocketfm/model/getcastbyaudioidmodel.dart';
import 'package:dtpocketfm/model/getcommentbyaudioidmodel.dart';
import 'package:dtpocketfm/model/getepisodebyaudioidmodel.dart';
import 'package:dtpocketfm/model/getrelatedaudiobyaudioidmodel.dart';
import 'package:dtpocketfm/utils/utils.dart';
import 'package:dtpocketfm/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class DetailProvider extends ChangeNotifier {
  DetailModel detailModel = DetailModel();
  GetepisodebyaudioidModel getepisodebyaudioidModel =
      GetepisodebyaudioidModel();
  GetcommentbyaudioidModel getcommentbyaudioidModel =
      GetcommentbyaudioidModel();
  GetrelatedaudiobyaudioidModel getrelatedaudiobyaudioidModel =
      GetrelatedaudiobyaudioidModel();
  GetcastbyaudioidModel getcastbyaudioidModel = GetcastbyaudioidModel();
  BookmarkModel bookmarkModel = BookmarkModel();
  AddratingModel addratingModel = AddratingModel();
  AddreviewModel addreviewModel = AddreviewModel();
  bool loading = false;

  getDetail(String audioid, String userid) async {
    loading = true;
    detailModel = await ApiService().audiodetail(audioid, userid);
    loading = false;
    notifyListeners();
  }

  getEpisodebyAudioid(String userid, String audioid, String pageno) async {
    loading = true;
    getepisodebyaudioidModel =
        await ApiService().episodebyaudioid(userid, audioid, pageno);
    loading = false;
    notifyListeners();
  }

  getCommentbyAudioid(String userid, String audioid, String pageno) async {
    debugPrint("userid =====> $userid");
    loading = true;
    getcommentbyaudioidModel =
        await ApiService().commentbyaudioid(userid, audioid, pageno);
    loading = false;
    notifyListeners();
  }

  getRelatedaudiobyAudioid(
      String audioid, String pageno, String categoryid) async {
    loading = true;
    getrelatedaudiobyaudioidModel =
        await ApiService().relatedaudiobyaudioid(audioid, pageno, categoryid);
    loading = false;
    notifyListeners();
  }

  getCastbyAudioid(String audioid, String pageno) async {
    loading = true;
    getcastbyaudioidModel = await ApiService().castbyaudioid(audioid, pageno);
    loading = false;
    notifyListeners();
  }

  Future<void> setBookMark(BuildContext context, audioid, userid) async {
    if ((detailModel.result?[0].isBookmark ?? 0) == 0) {
      detailModel.result?[0].isBookmark = 1;
      Utils.showSnackbarNew(context, "success", "addwatchlistmessage", true);
    } else {
      detailModel.result?[0].isBookmark = 0;
      Utils.showSnackbarNew(context, "success", "removewatchlistmessage", true);
    }
    notifyListeners();
    getBookmark(audioid, userid);
  }

  getBookmark(String audioid, String userid) async {
    debugPrint("getBookmark audioid :==> $audioid");
    debugPrint("getBookmark userid :===> $userid");
    bookmarkModel = await ApiService().bookmark(userid, audioid);
  }

  getAddrating(String userid, String audioid, String rating) async {
    loading = true;
    addratingModel = await ApiService().addrating(userid, audioid, rating);
    loading = false;
    notifyListeners();
  }

  getAddreview(String userid, String audioid, String comment) async {
    loading = true;
    addreviewModel = await ApiService().addreview(userid, audioid, comment);
    loading = false;
    notifyListeners();
  }
}
