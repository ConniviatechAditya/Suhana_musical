import 'package:dtpocketfm/model/getaudiobylanguagemodel.dart';
import 'package:dtpocketfm/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class AudiobyLanguageProvider extends ChangeNotifier {
  GetaudiobylanguageModel getaudiobylanguageModel = GetaudiobylanguageModel();
  bool loading = false;

  getAudiobylanguage(String languageid, String type, String pageno) async {
    loading = true;
    getaudiobylanguageModel =
        await ApiService().audiobylanguage(languageid, type, pageno);
    loading = false;
    notifyListeners();
  }
}
