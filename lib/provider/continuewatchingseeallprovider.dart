import 'package:dtpocketfm/model/continuewatchingmodel.dart';
import 'package:dtpocketfm/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class ContinuewatchingSeeallProvider extends ChangeNotifier {
  ContinuewatchingModel continuewatchingModel = ContinuewatchingModel();
  bool loading = false;

  getContinueWatching(String userid, String pageno) async {
    loading = true;
    continuewatchingModel = await ApiService().continuewatching(userid, pageno);
    loading = false;
    notifyListeners();
  }
}
