import 'package:dtpocketfm/model/getaudiobycategorymodel.dart';
import 'package:dtpocketfm/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class AudiobyCategoryProvider extends ChangeNotifier {
  GetaudiobycategoryModel getaudiobycategoryModel = GetaudiobycategoryModel();
  bool loading = false;

  getAudiobycategory(String categoryid, String type, String pageno) async {
    loading = true;
    getaudiobycategoryModel =
        await ApiService().audiobycategory(categoryid, type, pageno);
    loading = false;
    notifyListeners();
  }
}
