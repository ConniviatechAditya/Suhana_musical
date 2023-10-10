import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dtpocketfm/pages/bottombar.dart';
import 'package:dtpocketfm/provider/paymentprovider.dart';
import 'package:dtpocketfm/utils/consumable_store.dart';
import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/constant.dart';
import 'package:dtpocketfm/utils/sharedpre.dart';
import 'package:dtpocketfm/utils/strings.dart';
import 'package:dtpocketfm/utils/utils.dart';
import 'package:dtpocketfm/widget/myimage.dart';
import 'package:dtpocketfm/widget/mytext.dart';
import 'package:dtpocketfm/pages/nodata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

final bool _kAutoConsume = Platform.isIOS || true;
String _kConsumableId = 'android.test.purchased';

class AllPayment extends StatefulWidget {
  final String? payType, itemId, price, itemTitle, productPackage, currency;
  const AllPayment({
    Key? key,
    required this.payType,
    required this.itemId,
    required this.price,
    required this.itemTitle,
    required this.productPackage,
    required this.currency,
  }) : super(key: key);

  @override
  State<AllPayment> createState() => AllPaymentState();
}

class AllPaymentState extends State<AllPayment> {
  final couponController = TextEditingController();
  late ProgressDialog prDialog;
  late PaymentProvider paymentProvider;
  SharedPre sharedPref = SharedPre();
  String? userId, userName, userEmail, userMobileNo, paymentId;
  String? strCouponCode = "";
  bool isPaymentDone = false;

  /* Paytm */
  String paytmResult = "";

  /* InApp Purchase */
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final List<ProductDetails> _products = <ProductDetails>[];
  late List<String> _kProductIds;
  String androidPackageID = "android.test.purchased";
  final List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  /* Paypal */

  /* Stripe */
  Map<String, dynamic>? paymentIntent;

  @override
  void initState() {
    _kProductIds = <String>[androidPackageID];
    prDialog = ProgressDialog(context);
    _getData();
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
      log("onError ============> ${error.toString()}");
    });
    initStoreInfo();
    super.initState();
  }

  _getData() async {
    paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    await paymentProvider.getPaymentOption();
    await paymentProvider.setFinalAmount(widget.price ?? "");

    /* PaymentID */
    paymentId = Utils.generateRandomOrderID();
    log('paymentId =====================> $paymentId');

    userId = await sharedPref.read("userid");
    userName = await sharedPref.read("username");
    userEmail = await sharedPref.read("useremail");
    userMobileNo = await sharedPref.read("usermobile");
    log('getUserData userId ==> $userId');
    log('getUserData userName ==> $userName');
    log('getUserData userEmail ==> $userEmail');
    log('getUserData userMobileNo ==> $userMobileNo');

    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    paymentProvider.clearProvider();
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    couponController.dispose();
    super.dispose();
  }

  /* add_transaction API */
  Future addTransaction(
      packageId, paymentId, amount, description, currencyCode) async {
    Utils().showProgress(context, pleaseWait);
    await paymentProvider.addTransaction(
        userId, packageId, paymentId, amount, description, currencyCode);

    if (!paymentProvider.payLoading) {
      await prDialog.hide();

      if (paymentProvider.transectionModel.status == 200) {
        isPaymentDone = true;
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) {
              return const Bottombar();
            },
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        isPaymentDone = false;
        if (!mounted) return;
        Utils.showSnackbarNew(context, "info",
            paymentProvider.transectionModel.message ?? "", false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        backgroundColor: colorPrimaryDark,
        appBar: Utils.myAppBarWithBack(context, "payment_details", true),
        body: SafeArea(
          child: SingleChildScrollView(
            child: paymentProvider.loading
                ? Container(
                    height: 230,
                    padding: const EdgeInsets.all(20),
                    child: Utils.pageLoader(),
                  )
                : paymentProvider.paymentOptionModel.status == 200
                    ? paymentProvider.paymentOptionModel.result != null
                        ? _buildPaymentPage()
                        : const NoData()
                    : const NoData(),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentPage() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyText(
            color: white,
            text: "payment_methods",
            fontsize: 15,
            maxline: 1,
            multilanguage: true,
            overflow: TextOverflow.ellipsis,
            fontwaight: FontWeight.w600,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
          ),
          const SizedBox(height: 5),
          MyText(
            color: gray,
            text: "choose_a_payment_methods_to_pay",
            multilanguage: true,
            fontsize: 13,
            maxline: 2,
            overflow: TextOverflow.ellipsis,
            fontwaight: FontWeight.w500,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
          ),
          const SizedBox(height: 15),
          MyText(
            color: colorAccent,
            text: "pay_with",
            multilanguage: true,
            fontsize: 16,
            maxline: 1,
            overflow: TextOverflow.ellipsis,
            fontwaight: FontWeight.w700,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
          ),
          const SizedBox(height: 20),

          /* /* Payments */ */
          /* In-App purchase */
          paymentProvider.paymentOptionModel.result?.inAppPurchage != null
              ? paymentProvider.paymentOptionModel.result?.inAppPurchage
                          ?.visibility ==
                      "1"
                  ? Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      color: colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          await paymentProvider.setCurrentPayment("inapp");
                          _initInAppPurchase();
                        },
                        child: _buildPGButton(
                            "inapp.png", "InApp Purchase", 35, 110),
                      ),
                    )
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
          const SizedBox(height: 5),

          /* Paypal */
          paymentProvider.paymentOptionModel.result?.paypal != null
              ? paymentProvider.paymentOptionModel.result?.paypal?.visibility ==
                      "1"
                  ? Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      color: colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          await paymentProvider.setCurrentPayment("paypal");
                          _paypalInit();
                        },
                        child: _buildPGButton("paypal.png", "Paypal", 35, 130),
                      ),
                    )
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
          const SizedBox(height: 5),

          /* Razorpay */
          paymentProvider.paymentOptionModel.result?.razorpay != null
              ? paymentProvider
                          .paymentOptionModel.result?.razorpay?.visibility ==
                      "1"
                  ? Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      color: colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          await paymentProvider.setCurrentPayment("razorpay");
                          _initializeRazorpay();
                        },
                        child:
                            _buildPGButton("razorpay.png", "Razorpay", 35, 130),
                      ),
                    )
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
          const SizedBox(height: 5),

          /* Paytm */
          paymentProvider.paymentOptionModel.result?.payTm != null
              ? paymentProvider.paymentOptionModel.result?.payTm?.visibility ==
                      "1"
                  ? Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      color: colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          await paymentProvider.setCurrentPayment("paytm");
                          _paytmInit();
                        },
                        child: _buildPGButton("paytm.png", "Paytm", 30, 90),
                      ),
                    )
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
          const SizedBox(height: 5),

          /* Flutterwave */
          paymentProvider.paymentOptionModel.result?.flutterWave != null
              ? paymentProvider
                          .paymentOptionModel.result?.flutterWave?.visibility ==
                      "1"
                  ? Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      color: colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          await paymentProvider
                              .setCurrentPayment("flutterwave");
                        },
                        child: _buildPGButton(
                            "flutterwave.png", "Flutterwave", 35, 130),
                      ),
                    )
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
          const SizedBox(height: 5),

          /* Stripe */
          paymentProvider.paymentOptionModel.result?.stripe != null
              ? paymentProvider.paymentOptionModel.result?.stripe?.visibility ==
                      "1"
                  ? Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      color: colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          await paymentProvider.setCurrentPayment("stripe");
                          _stripeInit();
                        },
                        child: _buildPGButton("stripe.png", "Stripe", 35, 100),
                      ),
                    )
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
          const SizedBox(height: 5),

          /* PayUMoney */
          paymentProvider.paymentOptionModel.result?.payUMoney != null
              ? paymentProvider
                          .paymentOptionModel.result?.payUMoney?.visibility ==
                      "1"
                  ? Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      color: colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          await paymentProvider.setCurrentPayment("payumoney");
                        },
                        child: _buildPGButton(
                            "payumoney.png", "PayU Money", 35, 130),
                      ),
                    )
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildPGButton(
      String imageName, String pgName, double imgHeight, double imgWidth) {
    return Container(
      constraints: const BoxConstraints(minHeight: 85),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          MyImage(
            imagePath: imageName,
            fit: BoxFit.fill,
            height: imgHeight,
            width: imgWidth,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: MyText(
              color: white,
              text: pgName,
              multilanguage: false,
              fontsize: 14,
              maxline: 2,
              overflow: TextOverflow.ellipsis,
              fontwaight: FontWeight.w600,
              textalign: TextAlign.end,
              fontstyle: FontStyle.normal,
            ),
          ),
          const SizedBox(width: 15),
          MyImage(
            imagePath: "ic_arrow_right.png",
            fit: BoxFit.fill,
            height: 22,
            width: 20,
            color: white,
          ),
        ],
      ),
    );
  }

  /* ********* InApp purchase START ********* */
  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final List<String> consumables = await ConsumableStore.load();
    log("consumables ======> ${consumables.length}");
    setState(() {
      _isAvailable = isAvailable;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  _initInAppPurchase() async {
    log("_initInAppPurchase _kProductIds ============> ${_kProductIds[0].toString()}");
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_kProductIds.toSet());
    if (response.notFoundIDs.isNotEmpty) {
      Utils().showToast("Please check SKU");
      return;
    }
    log("productID ============> ${response.productDetails[0].id}");
    late PurchaseParam purchaseParam;
    if (Platform.isAndroid) {
      purchaseParam =
          GooglePlayPurchaseParam(productDetails: response.productDetails[0]);
    } else {
      purchaseParam = PurchaseParam(productDetails: response.productDetails[0]);
    }
    _inAppPurchase.buyConsumable(
        purchaseParam: purchaseParam, autoConsume: false);
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          log("purchaseDetails ============> ${purchaseDetails.error.toString()}");
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          log("===> status ${purchaseDetails.status}");
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!_kAutoConsume && purchaseDetails.productID == androidPackageID) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                _inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          log("===> pendingCompletePurchase ${purchaseDetails.pendingCompletePurchase}");
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    log("===> productID ${purchaseDetails.productID}");
    if (purchaseDetails.productID == androidPackageID) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      final List<String> consumables = await ConsumableStore.load();
      log("===> consumables $consumables");
      addTransaction(widget.itemId, widget.itemTitle,
          paymentProvider.finalAmount, paymentId, widget.currency);
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      log("===> consumables else $purchaseDetails");
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }
  }

  void showPendingUI() {
    setState(() {});
  }

  void handleError(IAPError error) {
    setState(() {});
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    log("invalid Purchase ===> $purchaseDetails");
  }
  /* ********* InApp purchase END ********* */

  /* ********* Razorpay START ********* */
  void _initializeRazorpay() {
    if (paymentProvider.paymentOptionModel.result?.razorpay != null) {
      Razorpay razorpay = Razorpay();
      var options = {
        'key':
            paymentProvider.paymentOptionModel.result?.razorpay?.isLive == "1"
                ? paymentProvider
                        .paymentOptionModel.result?.razorpay?.liveKey1 ??
                    ""
                : paymentProvider
                        .paymentOptionModel.result?.razorpay?.testKey1 ??
                    "",
        'amount': (double.parse(paymentProvider.finalAmount ?? "") * 100),
        'name': widget.itemTitle ?? "",
        'description': widget.itemTitle ?? "",
        'retry': {'enabled': true, 'max_count': 1},
        'send_sms_hash': true,
        'prefill': {'contact': userMobileNo, 'email': userEmail},
        'external': {'wallets': []}
      };
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
      razorpay.open(options);
    } else {
      Utils.showSnackbarNew(context, "", "payment_not_processed", true);
    }
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) async {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    Utils.showSnackbarNew(context, "fail", "payment_fail", true);
    await paymentProvider.setCurrentPayment("");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    // paymentId = response.paymentId;
    debugPrint("paymentId ========> $paymentId");
    Utils.showSnackbarNew(context, "success", "payment_success", true);
    addTransaction(widget.itemId, widget.itemTitle, paymentProvider.finalAmount,
        paymentId, widget.currency);
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    debugPrint("============ External Wallet Selected ============");
  }
  /* ********* Razorpay END ********* */

  /* ********* Paytm START ********* */
  Future<void> _paytmInit() async {
    if (paymentProvider.paymentOptionModel.result?.payTm != null) {
      var sendMap = <String, dynamic>{
        "mid": paymentProvider.paymentOptionModel.result?.payTm?.isLive == "1"
            ? paymentProvider.paymentOptionModel.result?.payTm?.liveKey1 ?? ""
            : paymentProvider.paymentOptionModel.result?.payTm?.testKey1 ?? "",
        "orderId": paymentId,
        "amount": paymentProvider.finalAmount ?? "",
        "txnToken": "",
        "callbackUrl":
            "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$paymentId",
        "isStaging":
            paymentProvider.paymentOptionModel.result?.payTm?.isLive == "1"
                ? false
                : true,
        "restrictAppInvoke": false,
        "enableAssist": true
      };
      debugPrint("sendMap ===> $sendMap");
      try {
        var response = AllInOneSdk.startTransaction(
            paymentProvider.paymentOptionModel.result?.payTm?.isLive == "1"
                ? paymentProvider.paymentOptionModel.result?.payTm?.liveKey1 ??
                    ""
                : paymentProvider.paymentOptionModel.result?.payTm?.testKey1 ??
                    "",
            paymentId ?? "",
            paymentProvider.finalAmount ?? "",
            "",
            "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$paymentId",
            paymentProvider.paymentOptionModel.result?.payTm?.isLive == "1"
                ? false
                : true,
            false,
            true);
        response.then((value) {
          debugPrint("value ====> $value");
          setState(() {
            paytmResult = value.toString();
          });
        }).catchError((onError) {
          if (onError is PlatformException) {
            setState(() {
              paytmResult = "${onError.message} \n  ${onError.details}";
            });
          } else {
            setState(() {
              paytmResult = onError.toString();
            });
          }
        });
      } catch (err) {
        paytmResult = err.toString();
      }
    } else {
      Utils.showSnackbarNew(context, "", "payment_not_processed", true);
    }
  }
  /* ********* Paytm END ********* */

  /* ********* Paypal START ********* */
  Future<void> _paypalInit() async {
    if (paymentProvider.paymentOptionModel.result?.paypal != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => UsePaypal(
              sandboxMode: (paymentProvider
                              .paymentOptionModel.result?.paypal?.isLive ??
                          "") ==
                      "1"
                  ? false
                  : true,
              clientId:
                  paymentProvider.paymentOptionModel.result?.paypal?.isLive ==
                          "1"
                      ? paymentProvider
                              .paymentOptionModel.result?.paypal?.liveKey1 ??
                          ""
                      : paymentProvider
                              .paymentOptionModel.result?.paypal?.testKey1 ??
                          "",
              secretKey: paymentProvider
                          .paymentOptionModel.result?.paypal?.isLive ==
                      "1"
                  ? paymentProvider
                          .paymentOptionModel.result?.paypal?.liveKey2 ??
                      ""
                  : paymentProvider
                          .paymentOptionModel.result?.paypal?.testKey2 ??
                      "",
              returnURL: "return.example.com",
              cancelURL: "cancel.example.com",
              transactions: [
                {
                  "amount": {
                    "total": '${paymentProvider.finalAmount}',
                    "currency": "USD" /* Constant.currency */,
                    "details": {
                      "subtotal": '${paymentProvider.finalAmount}',
                      "shipping": '0',
                      "shipping_discount": 0
                    }
                  },
                  "description": "The payment transaction description.",
                  "item_list": {
                    "items": [
                      {
                        "name": "${widget.itemTitle}",
                        "quantity": 1,
                        "price": '${paymentProvider.finalAmount}',
                        "currency": "USD" /* Constant.currency */
                      }
                    ],
                  }
                }
              ],
              note: "Contact us for any questions on your order.",
              onSuccess: (params) async {
                debugPrint("onSuccess: ${params["paymentId"]}");
                addTransaction(
                    widget.itemId,
                    widget.itemTitle,
                    paymentProvider.finalAmount,
                    params["paymentId"],
                    widget.currency);
              },
              onError: (params) {
                debugPrint("onError: ${params["message"]}");
                Utils.showSnackbarNew(
                    context, "fail", params["message"].toString(), false);
              },
              onCancel: (params) {
                debugPrint('cancelled: $params');
                Utils.showSnackbarNew(
                    context, "fail", params.toString(), false);
              }),
        ),
      );
    } else {
      Utils.showSnackbarNew(context, "", "payment_not_processed", true);
    }
  }
  /* ********* Paypal END ********* */

  /* ********* Stripe START ********* */
  Future<void> _stripeInit() async {
    if (paymentProvider.paymentOptionModel.result?.stripe != null) {
      stripe.Stripe.publishableKey = paymentProvider
                  .paymentOptionModel.result?.stripe?.isLive ==
              "1"
          ? paymentProvider.paymentOptionModel.result?.stripe?.liveKey1 ?? ""
          : paymentProvider.paymentOptionModel.result?.stripe?.testKey1 ?? "";
      try {
        //STEP 1: Create Payment Intent
        paymentIntent = await createPaymentIntent(
            paymentProvider.finalAmount ?? "", Constant.currency);

        //STEP 2: Initialize Payment Sheet
        await stripe.Stripe.instance
            .initPaymentSheet(
                paymentSheetParameters: stripe.SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent?['client_secret'],
              style: ThemeMode.light,
              merchantDisplayName: Constant.appName,
            ))
            .then((value) {});

        //STEP 3: Display Payment sheet
        displayPaymentSheet();
      } catch (err) {
        throw Exception(err);
      }
    } else {
      Utils.showSnackbarNew(context, "", "payment_not_processed", true);
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'description': widget.itemTitle,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer ${paymentProvider.paymentOptionModel.result?.stripe?.isLive == "1" ? paymentProvider.paymentOptionModel.result?.stripe?.liveKey2 ?? "" : paymentProvider.paymentOptionModel.result?.stripe?.testKey2 ?? ""}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  displayPaymentSheet() async {
    try {
      await stripe.Stripe.instance.presentPaymentSheet().then((value) {
        Utils.showSnackbarNew(context, "success", "payment_success", true);
        addTransaction(widget.itemId, widget.itemTitle,
            paymentProvider.finalAmount, paymentId, widget.currency);

        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on stripe.StripeException catch (e) {
      debugPrint('Error is:---> $e');
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint('$e');
    }
  }
  /* ********* Stripe END ********* */

  Future<bool> onBackPressed() async {
    if (!mounted) return Future.value(false);
    Navigator.pop(context, isPaymentDone);
    return Future.value(isPaymentDone == true ? true : false);
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
