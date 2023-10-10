import 'package:dtpocketfm/model/deleteaccountmodel.dart';
import 'package:dtpocketfm/model/generalsettingmodel.dart';
import 'package:dtpocketfm/model/getpagesmodel.dart';
import 'package:dtpocketfm/model/loginmodel.dart';
import 'package:dtpocketfm/utils/sharedpre.dart';
import 'package:dtpocketfm/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class GeneralProvider extends ChangeNotifier {
  GeneralsettingModel generalSettingModel = GeneralsettingModel();
  GetpagesModel pagesModel = GetpagesModel();
  LoginModel loginModel = LoginModel();
  DeleteaccountModel deleteaccountModel = DeleteaccountModel();
  bool loading = false;

  SharedPre sharedPre = SharedPre();

  Future<void> getGeneralsetting() async {
    loading = true;
    generalSettingModel = await ApiService().generalsetting();
    debugPrint("genaral_setting status :==> ${generalSettingModel.status}");
    loading = false;
    debugPrint('generalSettingData status ==> ${generalSettingModel.status}');
    if (generalSettingModel.status == 200) {
      if (generalSettingModel.result != null) {
        for (var i = 0; i < (generalSettingModel.result?.length ?? 0); i++) {
          await sharedPre.save(
            generalSettingModel.result?[i].key.toString() ?? "",
            generalSettingModel.result?[i].value.toString() ?? "",
          );
          debugPrint(
              '${generalSettingModel.result?[i].key.toString()} ==> ${generalSettingModel.result?[i].value.toString()}');
        }
      }
    }
  }

  Future<void> getPages() async {
    loading = true;
    pagesModel = await ApiService().getpages();
    debugPrint("getPages status :==> ${pagesModel.status}");
    loading = false;
  }

  getlogin(String type, String mobile, String email) async {
    loading = true;
    loginModel = await ApiService().login(type, mobile, email);
    loading = false;
    notifyListeners();
  }

  getDeleteAccount(String userid) async {
    loading = true;
    deleteaccountModel = await ApiService().deleteaccount(userid);
    loading = false;
    notifyListeners();
  }
}
