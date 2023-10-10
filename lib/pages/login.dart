import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dtpocketfm/pages/bottombar.dart';
import 'package:dtpocketfm/pages/commonpage.dart';
import 'package:dtpocketfm/pages/otp.dart';
import 'package:dtpocketfm/provider/generalprovider.dart';
import 'package:dtpocketfm/provider/homeprovider.dart';
import 'package:dtpocketfm/provider/sidedrawerprovider.dart';
import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/sharedpre.dart';
import 'package:dtpocketfm/utils/strings.dart';
import 'package:dtpocketfm/utils/utils.dart';
import 'package:dtpocketfm/widget/myimage.dart';
import 'package:dtpocketfm/widget/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class Login extends StatefulWidget {
  final bool ishome;
  const Login({super.key, required this.ishome});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  SharedPre sharedPre = SharedPre();
  final numberController = TextEditingController();
  String? mobileNumber, smsotp;
  bool isChecked = false;
  bool isDisabled = false;
  MSHCheckboxStyle style = MSHCheckboxStyle.fillScaleCheck;
  var email = "";
  String appleEmail = "";
  String? countryCode;
  int? forceResendingToken;
  String? verificationId;

  @override
  initState() {
    super.initState();
    getApi();
  }

  getApi() async {
    final pagesProvider =
        Provider.of<SidedrawerProvider>(context, listen: false);
    await pagesProvider.getPages();
  }

  @override
  Widget build(BuildContext context) {
    final pagesProvider =
        Provider.of<SidedrawerProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage('assets/images/ic_splashbg.png'),
              fit: BoxFit.cover),
          gradient: LinearGradient(
            colors: [
              colorPrimaryDark.withOpacity(0.6),
              colorPrimaryDark.withOpacity(1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0, 0.5],
          ),
          color: white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
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
              stops: const [0, 0.5],
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.30,
                    ),
                    Row(
                      children: [
                        MyText(
                            color: white,
                            text: "welcometo",
                            textalign: TextAlign.center,
                            fontsize: 18,
                            inter: true,
                            maxline: 6,
                            multilanguage: true,
                            fontwaight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                            fontstyle: FontStyle.normal),
                        const SizedBox(width: 3),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    MyText(
                        color: white,
                        text: "loginforpersonalosedlistning",
                        textalign: TextAlign.center,
                        multilanguage: true,
                        fontsize: 14,
                        inter: true,
                        maxline: 6,
                        fontwaight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: IntlPhoneField(
                        disableLengthCheck: true,
                        textAlignVertical: TextAlignVertical.center,
                        autovalidateMode: AutovalidateMode.disabled,
                        controller: numberController,
                        style: const TextStyle(
                          fontSize: 16,
                          color: white,
                        ),
                        showCountryFlag: false,
                        pickerDialogStyle: PickerDialogStyle(
                          backgroundColor: colorPrimary,
                          countryNameStyle: GoogleFonts.inter(
                            color: white,
                            decorationColor: white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          countryCodeStyle: GoogleFonts.inter(
                            color: white,
                            decorationColor: white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        showDropdownIcon: false,
                        initialCountryCode: 'IN',
                        dropdownDecoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(11),
                            bottomLeft: Radius.circular(11),
                          ),
                          color: lightpurpole,
                        ),
                        dropdownTextStyle: GoogleFonts.inter(
                          color: white,
                          backgroundColor: lightpurpole,
                          decorationColor: lightpurpole,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(25, 0, 25, 0),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(11)),
                            borderSide:
                                BorderSide(width: 1, color: lightpurpole),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(11)),
                            borderSide:
                                BorderSide(width: 1, color: lightpurpole),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(11)),
                            borderSide:
                                BorderSide(width: 1, color: lightpurpole),
                          ),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(11)),
                              borderSide:
                                  BorderSide(width: 1, color: lightpurpole)),
                          filled: true,
                          fillColor: black.withOpacity(0.44),
                          hintStyle: GoogleFonts.inter(
                            color: white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          hintText: "",
                        ),
                        onChanged: (phone) {
                          log('fullnumber===> ${phone.completeNumber}');
                          log('===> ${numberController.text}');
                          mobileNumber = phone.completeNumber;
                          log('===>mobileNumber $mobileNumber');
                        },
                        onCountryChanged: (country) {
                          log('===> ${country.name}');
                          log('===> ${country.code}');
                        },
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    InkWell(
                      onTap: () {
                        if (numberController.text.toString().isEmpty) {
                          Utils().showSnackbar(context, "pleaseenternumber");
                        } else if (isChecked == false) {
                          Utils().showSnackbar(
                              context, "pleaseaccepttemscondition");
                        } else if (numberController.text.toString().length !=
                            10) {
                          Utils().showSnackbar(context, "pleaseentertendigit");
                        } else {
                          codeSend();
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
                            text: "sendotp",
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: lightpurpole,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: MSHCheckbox(
                            size: 20,
                            value: isChecked,
                            isDisabled: isDisabled,
                            colorConfig:
                                MSHColorConfig.fromCheckedUncheckedDisabled(
                              uncheckedColor: white,
                            ),
                            style: style,
                            onChanged: (selected) {
                              setState(() {
                                isChecked = selected;
                              });
                              log("ischack=$isChecked");
                            },
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isChecked = true;
                            });
                          },
                          child: RichText(
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.left,
                            textDirection: TextDirection.ltr,
                            softWrap: true,
                            maxLines: 2,
                            text: TextSpan(
                              text: 'By continuing you accept ',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  color: white,
                                  fontSize: 12),
                              children: [
                                TextSpan(
                                  text: 'Privacy Policy ',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return CommonPage(
                                              url: pagesProvider.getpagesModel
                                                      .result?[1].url
                                                      .toString() ??
                                                  "",
                                              title: "privacypolicy",
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w400,
                                      color: red,
                                      decoration: TextDecoration.underline,
                                      fontSize: 12),
                                ),
                                TextSpan(
                                  text: '& ',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w400,
                                      color: white,
                                      fontSize: 12),
                                ),
                                TextSpan(
                                  text: 'TNC.',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return CommonPage(
                                              url: pagesProvider.getpagesModel
                                                      .result?[2].url
                                                      .toString() ??
                                                  "",
                                              title: "termscondition",
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w400,
                                      color: red,
                                      decoration: TextDecoration.underline,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            foregroundDecoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  white.withOpacity(0.6),
                                  colorPrimaryDark.withOpacity(1),
                                ],
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        MyText(
                            color: gray,
                            text: "or",
                            textalign: TextAlign.center,
                            fontsize: 12,
                            multilanguage: true,
                            inter: true,
                            fontwaight: FontWeight.w500,
                            maxline: 1,
                            overflow: TextOverflow.ellipsis,
                            fontstyle: FontStyle.normal),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 1,
                            foregroundDecoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  white.withOpacity(0.6),
                                  colorPrimaryDark.withOpacity(1),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    InkWell(
                      onTap: () {
                        if (isChecked == true) {
                          gmailLogin();
                        } else {
                          Utils().showSnackbar(
                              context, "pleaseaccepttemscondition");
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 55,
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: lightblue,
                            )),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MyImage(
                                width: 30,
                                height: 30,
                                imagePath: "ic_google.png"),
                            const SizedBox(width: 20),
                            MyText(
                                color: white,
                                text: "google",
                                textalign: TextAlign.center,
                                fontsize: 14,
                                multilanguage: true,
                                inter: true,
                                maxline: 1,
                                fontwaight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Platform.isIOS
                        ? InkWell(
                            onTap: () async {
                              if (isChecked == true) {
                                signInWithApple();
                              } else {
                                Utils().showSnackbar(
                                    context, "pleaseaccepttemscondition");
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: lightblue,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  MyImage(
                                      width: 30,
                                      height: 30,
                                      imagePath: "ic_apple.png"),
                                  const SizedBox(width: 20),
                                  MyText(
                                      color: white,
                                      text: "apple",
                                      textalign: TextAlign.center,
                                      fontsize: 14,
                                      multilanguage: true,
                                      inter: true,
                                      maxline: 1,
                                      fontwaight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                      fontstyle: FontStyle.normal),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                Positioned.fill(
                  top: 50,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        focusColor: white.withOpacity(0.40),
                        onTap: () {
                          widget.ishome == true
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const Bottombar();
                                    },
                                  ),
                                )
                              : Navigator.of(context).pop();
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
          ),
        ),
      ),
    );
  }

  codeSend() async {
    Utils().showProgress(context, "Please Wait");
    await phoneSignIn(phoneNumber: mobileNumber.toString());
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OTP(
          verificationid: verificationId,
          mobilenumber: mobileNumber.toString(),
        ),
      ),
    );
  }

  _onCodeTimeout(String verificationId) {
    log("_onCodeTimeout verificationId =======> $verificationId");
    this.verificationId = verificationId;
    Utils().hideProgress(context);
    return null;
  }

  // Login With Google
  Future<void> gmailLogin() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    GoogleSignInAccount user = googleUser;

    debugPrint('GoogleSignIn ===> id : ${user.id}');
    debugPrint('GoogleSignIn ===> email : ${user.email}');
    debugPrint('GoogleSignIn ===> displayName : ${user.displayName}');
    debugPrint('GoogleSignIn ===> photoUrl : ${user.photoUrl}');

    if (!mounted) return;
    Utils().showProgress(context, "Please Wait");

    UserCredential userCredential;
    try {
      GoogleSignInAuthentication googleSignInAuthentication =
          await user.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      userCredential = await auth.signInWithCredential(credential);
      assert(await userCredential.user?.getIdToken() != null);
      debugPrint("User Name: ${userCredential.user?.displayName}");
      debugPrint("User Email ${userCredential.user?.email}");
      debugPrint("User photoUrl ${userCredential.user?.photoURL}");
      debugPrint("uid ===> ${userCredential.user?.uid}");
      String firebasedid = userCredential.user?.uid ?? "";
      debugPrint('firebasedid :===> $firebasedid');
      // Call Login Api
      if (!mounted) return;
      Utils().showProgress(context, "Please Wait");
      loginApi("2", "", user.email);
    } on FirebaseAuthException catch (e) {
      debugPrint('===>Exp${e.code.toString()}');
      debugPrint('===>Exp${e.message.toString()}');
      Utils().hideProgress(context);
    }
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User?> signInWithApple() async {
    debugPrint("Click Apple");
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      debugPrint(appleCredential.authorizationCode);

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final authResult = await auth.signInWithCredential(oauthCredential);

      final displayName =
          '${appleCredential.givenName} ${appleCredential.familyName}';

      final firebaseUser = authResult.user;
      debugPrint("=================");

      final userEmail = '${firebaseUser?.email}';
      debugPrint("userEmail =====> $userEmail");
      debugPrint(firebaseUser?.email.toString());
      debugPrint(firebaseUser?.displayName.toString());
      debugPrint(firebaseUser?.photoURL.toString());
      debugPrint(firebaseUser?.uid);
      debugPrint("=================");

      final firebasedId = firebaseUser?.uid;
      debugPrint("firebasedId ===> $firebasedId");

      checkAndNavigate(userEmail, displayName.toString(), "2");
    } catch (exception) {
      debugPrint("Apple Login exception =====> $exception");
    }
    return null;
  }

  checkAndNavigate(String mail, String displayName, String type) async {
    appleEmail = mail;
    String userName = displayName;
    log('checkAndNavigate email ==>> $email');
    log('checkAndNavigate userName ==>> $userName');
    loginApi("2", "", appleEmail);
  }

  loginApi(String type, String mobile, String email) async {
    final homeprovider = Provider.of<HomeProvider>(context, listen: false);
    final loginItem = Provider.of<GeneralProvider>(context, listen: false);
    Utils().showProgress(context, pleaseWait);
    await loginItem.getlogin(type, "", email);

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
