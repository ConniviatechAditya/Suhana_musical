import 'package:dtpocketfm/model/paymentoptionmodel.dart';
import 'package:dtpocketfm/model/premiummodel.dart';
import 'package:dtpocketfm/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class PremiumProvider extends ChangeNotifier {
  PremiumModel premiumModel = PremiumModel();
  PaymentOptionModel paymentOptionModel = PaymentOptionModel();
  bool loading = false, payLoading = false;

  getPackage(String userid) async {
    loading = true;
    premiumModel = await ApiService().package(userid);
    loading = false;
    notifyListeners();
  }
}
