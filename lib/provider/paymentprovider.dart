import 'dart:developer';

import 'package:dtpocketfm/model/paymentoptionmodel.dart';
import 'package:dtpocketfm/model/transectionmodel.dart';
import 'package:dtpocketfm/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class PaymentProvider extends ChangeNotifier {
  PaymentOptionModel paymentOptionModel = PaymentOptionModel();
  TransectionModel transectionModel = TransectionModel();

  bool loading = false, payLoading = false;
  String? currentPayment = "", finalAmount = "";

  Future<void> getPaymentOption() async {
    loading = true;
    paymentOptionModel = await ApiService().getPaymentOption();
    debugPrint("getPaymentOption status :==> ${paymentOptionModel.status}");
    debugPrint("getPaymentOption message :==> ${paymentOptionModel.message}");
    loading = false;
    notifyListeners();
  }

  setFinalAmount(String? amount) {
    finalAmount = amount;
    debugPrint("setFinalAmount finalAmount :==> $finalAmount");
    notifyListeners();
  }

  setCurrentPayment(String? payment) {
    currentPayment = payment;
    notifyListeners();
  }

  Future<void> addTransaction(
      userid, packageId, paymentId, amount, description, currencyCode) async {
    debugPrint("addTransaction packageId :==> $packageId");
    payLoading = true;
    transectionModel = await ApiService().transection(
        userid, packageId, paymentId, amount, description, currencyCode);
    debugPrint("addTransaction status :==> ${transectionModel.status}");
    debugPrint("addTransaction message :==> ${transectionModel.message}");
    payLoading = false;
    notifyListeners();
  }

  clearProvider() {
    log("<================ clearProvider ================>");
    currentPayment = "";
    finalAmount = "";
    paymentOptionModel = PaymentOptionModel();
  }
}
