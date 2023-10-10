import 'dart:developer';
import 'package:dtpocketfm/pages/bottombar.dart';
import 'package:dtpocketfm/provider/generalprovider.dart';
import 'package:dtpocketfm/provider/homeprovider.dart';
import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/sharedpre.dart';
import 'package:dtpocketfm/utils/strings.dart';
import 'package:dtpocketfm/utils/utils.dart';
import 'package:dtpocketfm/widget/myimage.dart';
import 'package:dtpocketfm/widget/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OTP extends StatefulWidget {
  final String? number;
  final String verificationid;
  final String mobilenumber;
  const OTP({
    super.key,
    this.number,
    required this.mobilenumber,
    required this.verificationid,
  });

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  SharedPre sharedPre = SharedPre();
  final pinPutController = TextEditingController();
  String? countryCode;
  int? forceResendingToken;
  String? verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/ic_splashbg.png'),
                  fit: BoxFit.cover),
              color: white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorPrimaryDark.withOpacity(0.6),
                    colorPrimaryDark.withOpacity(1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0, 0.7],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.25,
                  ),
                  RichText(
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.left,
                    textDirection: TextDirection.ltr,
                    softWrap: true,
                    maxLines: 2,
                    text: TextSpan(
                      text: 'Enter the OTP sent to ',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: white,
                          fontSize: 16),
                      children: [
                        TextSpan(
                          text: widget.number,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              color: red,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Pinput(
                    length: 6,
                    keyboardType: TextInputType.number,
                    controller: pinPutController,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    defaultPinTheme: PinTheme(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border.all(color: red, width: 1),
                        shape: BoxShape.rectangle,
                        color: white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      textStyle: Utils.googleFontStyle(
                          1, 16, FontStyle.normal, black, FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        codeSend();
                      },
                      child: MyText(
                          color: orange,
                          text: "resendotp",
                          multilanguage: true,
                          textalign: TextAlign.center,
                          fontsize: 14,
                          inter: true,
                          maxline: 6,
                          fontwaight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal),
                    ),
                  ),
                  const SizedBox(height: 25),
                  InkWell(
                    onTap: () {
                      if (pinPutController.text.isEmpty) {
                        Utils().showSnackbar(context, "pleaseenterotp");
                      } else {
                        checkOTPAndLogin();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        gradient: LinearGradient(
                          colors: [
                            colorAccent.withOpacity(0.6),
                            red.withOpacity(1),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: MyText(
                          color: white,
                          text: "submit",
                          multilanguage: true,
                          textalign: TextAlign.center,
                          fontsize: 16,
                          inter: true,
                          maxline: 6,
                          fontwaight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            top: 50,
            left: 15,
            child: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  focusColor: white.withOpacity(0.40),
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: MyImage(
                        width: 18, height: 18, imagePath: "ic_back.png"),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  codeSend() async {
    Utils().showProgress(context, "Please Wait");
    await phoneSignIn(phoneNumber: widget.mobilenumber.toString());
    if (!mounted) return;
    Utils().hideProgress(context);
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    await auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: phoneNumber,
      forceResendingToken: forceResendingToken,
      verificationCompleted: _onVerificationCompleted,
      verificationFailed: _onVerificationFailed,
      codeSent: _onCodeSent,
      codeAutoRetrievalTimeout: _onCodeTimeout,
    );
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    log("verification completed ======> ${authCredential.smsCode}");
    User? user = FirebaseAuth.instance.currentUser;
    log("user phoneNumber =====> ${user?.phoneNumber}");
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      log("The phone number entered is invalid!");
      Utils().showSnackbar(context, "thephonenumberenteredisinvalid");
      Utils().hideProgress(context);
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    this.verificationId = verificationId;
    this.forceResendingToken = forceResendingToken;
    log("verificationId =======> $verificationId");
    log("resendingToken =======> ${forceResendingToken.toString()}");
    log("code sent");
    Utils().showSnackbar(context, "coderesendsuccsessfully");
    Utils().hideProgress(context);
  }

  _onCodeTimeout(String verificationId) {
    log("_onCodeTimeout verificationId =======> $verificationId");
    this.verificationId = verificationId;
    Utils().hideProgress(context);
    return null;
  }

  checkOTPAndLogin() async {
    bool error = false;
    UserCredential? userCredential;

    log("_checkOTPAndLogin verificationId =====> ${widget.verificationid}");
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential? phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: widget.verificationid,
      smsCode: pinPutController.text.toString(),
    );

    log("phoneAuthCredential.smsCode   =====> ${phoneAuthCredential.smsCode}");
    log("phoneAuthCredential.verificationId =====> ${phoneAuthCredential.verificationId}");
    try {
      userCredential = await auth.signInWithCredential(phoneAuthCredential);
      log("_checkOTPAndLogin userCredential =====> ${userCredential.user?.phoneNumber ?? ""}");
    } on FirebaseAuthException catch (e) {
      Utils().hideProgress(context);
      log("_checkOTPAndLogin error Code =====> ${e.code}");
      if (e.code == 'invalid-verification-code' ||
          e.code == 'invalid-verification-id') {
        if (!mounted) return;
        Utils().showSnackbar(context, "otp_invalid");
        return;
      } else if (e.code == 'session-expired') {
        if (!mounted) return;
        Utils().showSnackbar(context, "otp_session_expired");
        return;
      } else {
        error = true;
      }
    }
    log("Firebase Verification Complated & phoneNumber => ${userCredential?.user?.phoneNumber} and isError => $error");
    if (!error && userCredential != null) {
      // Call Login Api
      loginApi("1", widget.mobilenumber.toString(), "");
    } else {
      if (!mounted) return;
      Utils().hideProgress(context);
      Utils().showSnackbar(context, "otp_login_fail");
    }
  }

  loginApi(String type, String mobile, String email) async {
    final homeprovider = Provider.of<HomeProvider>(context, listen: false);
    final loginItem = Provider.of<GeneralProvider>(context, listen: false);
    Utils().showProgress(context, pleaseWait);
    await loginItem.getlogin(type, mobile, "");

    if (loginItem.loading) {
      if (!mounted) return;
      Utils().showProgress(context, pleaseWait);
    } else {
      if (loginItem.loginModel.status == 200 &&
          loginItem.loginModel.result != null) {
        await sharedPre.save(
            "userid", loginItem.loginModel.result?[0].id.toString());
        await sharedPre.save(
            "username", loginItem.loginModel.result?[0].fullName.toString());
        await sharedPre.save("userfullname",
            loginItem.loginModel.result?[0].fullName.toString());
        await sharedPre.save(
            "useremail", loginItem.loginModel.result?[0].email.toString());
        await sharedPre.save("usermobile",
            loginItem.loginModel.result?[0].mobileNumber.toString());
        await sharedPre.save(
            "userimage", loginItem.loginModel.result?[0].image.toString());
        await sharedPre.save(
            "usertype", loginItem.loginModel.result?[0].type.toString());
        await sharedPre.save(
            "userbio", loginItem.loginModel.result?[0].bio.toString());

        await homeprovider
            .valueUpdate(loginItem.loginModel.result?[0].id.toString() ?? "");
        await homeprovider
            .getProfile(loginItem.loginModel.result?[0].id.toString() ?? "");
        await homeprovider.getContinueWatching(
            loginItem.loginModel.result?[0].id.toString() ?? "", "1");
        if (!mounted) return;
        Utils().hideProgress(context);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Bottombar()),
            (Route route) => false);
      } else {
        Utils().showToast("${loginItem.loginModel.message}");
        if (!mounted) return;
        Utils().hideProgress(context);
      }
    }
  }
}
