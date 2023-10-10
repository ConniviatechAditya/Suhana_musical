import 'package:dtpocketfm/model/addaudioplaymodel.dart';
import 'package:dtpocketfm/model/addcontinuewatchingmodel.dart';
import 'package:dtpocketfm/model/removecontinuewatchingmodel.dart';
import 'package:dtpocketfm/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class PlayProvider extends ChangeNotifier {
  AddcontinuewatchingModel addcontinuewatchingModel =
      AddcontinuewatchingModel();
  RemovecontinuewatchingModel removecontinuewatchingModel =
      RemovecontinuewatchingModel();
  Addaudioplaymodel addaudioplaymodel = Addaudioplaymodel();
  bool loading = false;

// This Provider is Not Use in The App (Because Api is Not Attech in this App)
  getaddcontinueWatching(
      String userid, String audioid, String episodeid, String stoptime) async {
    loading = true;
    addcontinuewatchingModel = await ApiService()
        .addcontinuewatching(userid, audioid, episodeid, stoptime);
    loading = false;
    notifyListeners();
  }

  getremovecontinueWatching(
      String userid, String audioid, String episodeid) async {
    loading = true;
    removecontinuewatchingModel =
        await ApiService().removecontinuewatching(userid, audioid, episodeid);
    loading = false;
    notifyListeners();
  }

  getaddAudioplay(String userid, String audioid) async {
    loading = true;
    addaudioplaymodel = await ApiService().addaudioplay(userid, audioid);
    loading = false;
    notifyListeners();
  }
}
