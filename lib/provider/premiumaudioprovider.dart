import 'package:dtpocketfm/model/premiumaudiomodel.dart';
import 'package:dtpocketfm/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class PremiumaudioProvider extends ChangeNotifier {
  PremiumaudioModel premiumaudioModel = PremiumaudioModel();
  bool loading = false;

  getPremiumAudio(String ishomepage, String type, String pageno) async {
    loading = true;
    premiumaudioModel =
        await ApiService().premiumaudio(ishomepage, type, pageno);
    loading = false;
    notifyListeners();
  }
}
