import 'package:dtpocketfm/model/bannermodel.dart';
import 'package:dtpocketfm/model/categorymodel.dart';
import 'package:dtpocketfm/model/continuewatchingmodel.dart';
import 'package:dtpocketfm/model/gettopplaymodel.dart';
import 'package:dtpocketfm/model/newreleasemodel.dart';
import 'package:dtpocketfm/model/profilemodel.dart';
import 'package:dtpocketfm/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  BannerModel bannerModel = BannerModel();
  ProfileModel profileModel = ProfileModel();
  CategoryModel categoryModel = CategoryModel();
  TopplayModel topplayModel = TopplayModel();
  NewreleaseModel newreleaseModel = NewreleaseModel();
  ContinuewatchingModel continuewatchingModel = ContinuewatchingModel();
  bool loadingBanner = false,
      loadingCategory = false,
      loadingTopPlay = false,
      loadingProfile = false,
      loadingNew = false,
      loadingContinue = false,
      loadingPages = false;
  int ind = 0;
  int pageindex = 0;
  String? uid;

  getBanner(String ishomepage, String type, String userid) async {
    loadingBanner = true;
    bannerModel = await ApiService().banner(ishomepage, type, userid);
    loadingBanner = false;
    notifyListeners();
  }

  getCategory(String pageno) async {
    loadingCategory = true;
    categoryModel = await ApiService().category(pageno);
    loadingCategory = false;
    notifyListeners();
  }

  getTopPlay(String ishomepage, String type, String pageno) async {
    loadingTopPlay = true;
    topplayModel = await ApiService().topplay(ishomepage, type, pageno);
    loadingTopPlay = false;
    notifyListeners();
  }

  getNewRelease(String ishomepage, String type, String pageno) async {
    loadingNew = true;
    newreleaseModel = await ApiService().newrelease(ishomepage, type, pageno);
    loadingNew = false;
    notifyListeners();
  }

  getContinueWatching(String userid, String pageno) async {
    loadingContinue = true;
    continuewatchingModel = await ApiService().continuewatching(userid, pageno);
    loadingContinue = false;
    notifyListeners();
  }

  getProfile(String userid) async {
    loadingProfile = true;
    profileModel = await ApiService().profile(userid);
    loadingProfile = false;
    notifyListeners();
  }

  getChangeIndicater(int index) {
    ind = index;
    notifyListeners();
  }

  getchangeTab(int index) {
    pageindex = index;
    notifyListeners();
  }

  valueUpdate(String id) {
    debugPrint("valueUpdate id =======> $id");
    uid = id;
    debugPrint("valueUpdate uid ======> $uid");
    notifyListeners();
  }

  setLoading(bool isLoading) {
    loadingBanner = isLoading;
    loadingCategory = isLoading;
    loadingTopPlay = isLoading;
    if (uid != null || uid != "") {
      loadingContinue = isLoading;
      loadingProfile = isLoading;
    }
    loadingNew = isLoading;
    loadingPages = isLoading;
    notifyListeners();
  }

  clearProvider() {
    bannerModel = BannerModel();
    profileModel = ProfileModel();
    categoryModel = CategoryModel();
    topplayModel = TopplayModel();
    newreleaseModel = NewreleaseModel();
    continuewatchingModel = ContinuewatchingModel();
    loadingBanner = false;
    loadingCategory = false;
    loadingTopPlay = false;
    loadingProfile = false;
    loadingNew = false;
    loadingContinue = false;
    loadingPages = false;
    ind = 0;
    pageindex = 0;
    uid = null;
  }
}
