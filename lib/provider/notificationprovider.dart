import 'package:dtpocketfm/model/getnotificatiomodel.dart';
import 'package:dtpocketfm/model/readnotificationmodel.dart';
import 'package:dtpocketfm/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  GetnotificationModel getnotificatioModel = GetnotificationModel();
  ReadnotificationModel readnotificationModel = ReadnotificationModel();
  bool loading = false;

  getnotification(String userid, String pageno) async {
    loading = true;
    getnotificatioModel = await ApiService().notification(userid, pageno);
    loading = false;
    notifyListeners();
  }

  readnotification(String userid, String notificationid) async {
    loading = true;
    readnotificationModel =
        await ApiService().readnotification(userid, notificationid);
    loading = false;
    notifyListeners();
  }
}
