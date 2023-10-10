import 'package:dtpocketfm/model/topratingaudiomodel.dart';
import 'package:dtpocketfm/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class TopRatingAudioProvider extends ChangeNotifier {
  TopratingaudioModel topratingaudioModel = TopratingaudioModel();
  bool loading = false;

  getTopRatingAudio(String ishomepage, String type, String pageno) async {
    loading = true;
    topratingaudioModel =
        await ApiService().topratingaudio(ishomepage, type, pageno);
    loading = false;
    notifyListeners();
  }
}
