import 'package:dtpocketfm/model/getpagesmodel.dart';
import 'package:dtpocketfm/model/profilemodel.dart';
import 'package:dtpocketfm/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class SidedrawerProvider extends ChangeNotifier {
  ProfileModel profileModel = ProfileModel();
  GetpagesModel getpagesModel = GetpagesModel();
  bool loading = false;
  String uid = "";

  getProfile(String userid) async {
    loading = true;
    profileModel = await ApiService().profile(userid);
    loading = false;
    notifyListeners();
  }

  getPages() async {
    loading = true;
    getpagesModel = await ApiService().getpages();
    loading = false;
    notifyListeners();
  }

  valueUpdate(String id) {
    uid = id;
    notifyListeners();
  }
}
