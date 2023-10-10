import 'dart:io';
import 'package:dtpocketfm/model/profilemodel.dart';
import 'package:dtpocketfm/model/updateprofilemodel.dart';
import 'package:dtpocketfm/utils/sharedpre.dart';
import 'package:dtpocketfm/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class UpdateProfileProvider extends ChangeNotifier {
  UpdateprofileModel updateprofileModel = UpdateprofileModel();
  ProfileModel profileModel = ProfileModel();
  bool loading = false;
  SharedPre sharePref = SharedPre();

  getupdateProfile(
      String userid,String fullname,String number,String bio,String email, File image) async {
    loading = true;
    updateprofileModel = await ApiService()
        .updateprofile(userid, fullname, number, bio, email, image);
    loading = false;
    notifyListeners();
  }

  getProfile(String userid) async {
    loading = true;
    profileModel = await ApiService().profile(userid);
    loading = false;
    notifyListeners();
  }
}
