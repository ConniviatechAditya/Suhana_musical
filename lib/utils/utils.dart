import 'dart:developer';
import 'dart:io';
import 'dart:math' as number;
import 'package:dtpocketfm/pages/bottombar.dart';
import 'package:dtpocketfm/pages/login.dart';
import 'package:dtpocketfm/pages/musicdetails.dart';
import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/constant.dart';
import 'package:dtpocketfm/utils/sharedpre.dart';
import 'package:dtpocketfm/widget/myimage.dart';
import 'package:dtpocketfm/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:html/parser.dart' show parse;
import 'package:screen_protector/screen_protector.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static void enableScreenCapture() async {
    await ScreenProtector.preventScreenshotOn();
    if (Platform.isIOS) {
      await ScreenProtector.protectDataLeakageWithBlur();
    } else if (Platform.isAndroid) {
      await ScreenProtector.protectDataLeakageOn();
    }
  }

  ProgressDialog? prDialog;

  static void openLogin(
      {required BuildContext context,
      required bool isHome,
      required bool isReplace}) async {
    currentlyPlaying.value = null;
    await audioPlayer.pause();
    await audioPlayer.stop();
    if (context.mounted) {
      debugPrint("setState");
      if (isReplace) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Login(ishome: isHome);
            },
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Login(ishome: isHome);
            },
          ),
        );
      }
    }
  }

  showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: colorAccent,
        textColor: black,
        fontSize: 14);
  }

  static Widget pageLoader() {
    return const Align(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: colorAccent,
      ),
    );
  }

  void getCurrencySymbol() async {
    SharedPre sharedPref = SharedPre();
    Constant.currencySymbol = await sharedPref.read("currency_code") ?? "";
    log('Constant currencySymbol ==> ${Constant.currencySymbol}');
  }

  static String formateDate(String date, String format) {
    String finalDate = "";
    DateFormat inputDate = DateFormat("yyyy-MM-dd");
    DateFormat outputDate = DateFormat(format);

    log('date => $date');
    DateTime inputTime = inputDate.parse(date);
    log('inputTime => $inputTime');

    finalDate = outputDate.format(inputTime);
    log('finalDate => $finalDate');

    return finalDate;
  }

  myappbar(String image, String title, var onTap) {
    return AppBar(
      centerTitle: false,
      automaticallyImplyLeading: false,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: colorPrimaryDark,
      ),
      backgroundColor: colorPrimaryDark,
      title: Row(
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
                padding: const EdgeInsets.all(7),
                child: MyImage(width: 20, height: 20, imagePath: image)),
          ),
          const SizedBox(width: 10),
          MyText(
            color: white,
            text: title,
            fontsize: 16,
            multilanguage: true,
            fontwaight: FontWeight.w600,
            maxline: 1,
            overflow: TextOverflow.ellipsis,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
            inter: true,
          ),
        ],
      ),
    );
  }

  static BoxDecoration textFieldBGWithBorder() {
    return BoxDecoration(
      color: white,
      border: Border.all(
        color: gray,
        width: .2,
      ),
      borderRadius: BorderRadius.circular(4),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration r4BGWithBorder() {
    return BoxDecoration(
      color: white,
      border: Border.all(
        color: gray,
        width: .5,
      ),
      borderRadius: BorderRadius.circular(4),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration setGradientBGWithCenter(
      Color colorStart, Color colorCenter, Color colorEnd, double radius) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: <Color>[colorStart, colorCenter, colorEnd],
      ),
      borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration r4DarkBGWithBorder() {
    return BoxDecoration(
      color: colorPrimaryDark,
      border: Border.all(
        color: colorPrimaryDark,
        width: .5,
      ),
      borderRadius: BorderRadius.circular(4),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration r10BGWithBorder() {
    return BoxDecoration(
      color: white,
      border: Border.all(
        color: gray,
        width: .5,
      ),
      borderRadius: BorderRadius.circular(10),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration setBackground(Color color, double radius) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration setBGWithBorder(
      Color color, Color borderColor, double radius, double border) {
    return BoxDecoration(
      color: color,
      border: Border.all(
        color: borderColor,
        width: border,
      ),
      borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration primaryDarkButton() {
    return BoxDecoration(
      color: colorPrimaryDark,
      borderRadius: BorderRadius.circular(4),
      shape: BoxShape.rectangle,
    );
  }

  static Widget buildBackBtn(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      focusColor: gray.withOpacity(0.5),
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: MyImage(
          height: 17,
          width: 17,
          imagePath: "back.png",
          fit: BoxFit.contain,
          color: white,
        ),
      ),
    );
  }

  static Widget buildBackBtnDesign(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: MyImage(
        height: 17,
        width: 17,
        imagePath: "back.png",
        fit: BoxFit.contain,
        color: white,
      ),
    );
  }

  static AppBar myAppBar(
      BuildContext context, String appBarTitle, bool multilanguage) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: colorPrimaryDark,
      centerTitle: true,
      title: MyText(
        color: white,
        text: appBarTitle,
        multilanguage: multilanguage,
        fontsize: 16,
        maxline: 1,
        overflow: TextOverflow.ellipsis,
        fontwaight: FontWeight.bold,
        textalign: TextAlign.center,
        fontstyle: FontStyle.normal,
      ),
    );
  }

  static AppBar myAppBarWithBack(
      BuildContext context, String appBarTitle, bool multilanguage) {
    return AppBar(
      elevation: 5,
      backgroundColor: colorPrimaryDark,
      centerTitle: true,
      leading: IconButton(
        autofocus: true,
        focusColor: white.withOpacity(0.5),
        onPressed: () {
          Navigator.pop(context);
        },
        icon: MyImage(
          imagePath: "back.png",
          fit: BoxFit.contain,
          height: 17,
          width: 17,
          color: white,
        ),
      ),
      title: MyText(
        text: appBarTitle,
        multilanguage: multilanguage,
        fontsize: 16,
        fontstyle: FontStyle.normal,
        fontwaight: FontWeight.bold,
        textalign: TextAlign.center,
        color: white,
      ),
    );
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        content: MyText(
          text: message,
          fontsize: 14,
          multilanguage: true,
          inter: true,
          fontstyle: FontStyle.normal,
          fontwaight: FontWeight.normal,
          color: white,
          textalign: TextAlign.center,
        ),
      ),
    );
  }

  static void showSnackbarNew(BuildContext context, String showFor,
      String message, bool multilanguage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: showFor == "fail"
            ? failureBG
            : showFor == "info"
                ? infoBG
                : showFor == "success"
                    ? successBG
                    : colorAccent,
        content: MyText(
          text: message,
          fontsize: 14,
          multilanguage: multilanguage,
          fontstyle: FontStyle.normal,
          fontwaight: FontWeight.w500,
          color: white,
          textalign: TextAlign.center,
        ),
      ),
    );
  }

  void showProgress(BuildContext context, String message) async {
    prDialog = ProgressDialog(context);
    prDialog = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: false, showLogs: false);

    prDialog?.style(
      message: message.toString(),
      borderRadius: 5,
      progressWidget: Container(
        padding: const EdgeInsets.all(8),
        child: const CircularProgressIndicator(),
      ),
      maxProgress: 100,
      progressTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: white,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: const TextStyle(
        color: black,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    );

    await prDialog!.show();
  }

  void hideProgress(BuildContext context) async {
    prDialog = ProgressDialog(context);
    if (prDialog!.isShowing()) {
      prDialog!.hide();
    }
  }

// KMB Text Generator Method
  static String kmbGenerator(int num) {
    if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (num > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else {
      return num.toString();
    }
  }

  // Duration Format
  static String formatDuration(double time) {
    Duration duration = Duration(milliseconds: time.round());

    return [duration.inHours, duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  static String timeAgoCustom(DateTime d) {
    // <-- Custom method Time Show  (Display Example  ==> 'Today 7:00 PM')     // WhatsApp Time Show Status Shimila
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    }
    if (diff.inDays > 0) {
      return DateFormat.E().add_jm().format(d);
    }
    if (diff.inHours > 0) return "Today ${DateFormat('jm').format(d)}";
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    }
    return "just now";
  }

  static String dateFormat(String date, String format) {
    String finalDate = "";
    DateFormat inputDate = DateFormat("yyyy-MM-dd");
    DateFormat outputDate = DateFormat(format);

    DateTime inputTime = inputDate.parse(date);

    finalDate = outputDate.format(inputTime);

    return finalDate;
  }

  static BoxDecoration setGradBGTTBWithBorder(Color colorStart, Color colorEnd,
      Color borderColor, double radius, double border) {
    return BoxDecoration(
      border: Border.all(
        color: borderColor,
        width: border,
      ),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[colorStart, colorEnd],
      ),
      borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
    );
  }

  static convertMinute(String milisecond) {
    String min = "0 min";
    var duration = Duration(milliseconds: int.parse(milisecond));
    var minutes = duration.inMinutes % 60;
    if (minutes != 0) {
      log('$minutes min');
      min = "$minutes min";
      return min;
    } else {
      log("0 min");
      return min;
    }
  }

  static googleFontStyle(
      int i, int j, FontStyle normal, Color gray, FontWeight w400) {}

  //Convert Html to simple String
  static String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  static Future<String> getFileUrl(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/$fileName";
  }

  static Future<File?> saveImageInStorage(imgUrl) async {
    try {
      var response = await http.get(Uri.parse(imgUrl));
      Directory? documentDirectory;
      if (Platform.isAndroid) {
        documentDirectory = await getExternalStorageDirectory();
      } else {
        documentDirectory = await getApplicationDocumentsDirectory();
      }
      File file = File(path.join(documentDirectory?.path ?? "",
          '${DateTime.now().millisecondsSinceEpoch.toString()}.png'));
      file.writeAsBytesSync(response.bodyBytes);
      // This is a sync operation on a real
      // app you'd probably prefer to use writeAsByte and handle its Future
      return file;
    } catch (e) {
      debugPrint("saveImageInStorage Exception ===> $e");
      return null;
    }
  }

  // static Html htmlTexts(var strText) {
  //   return Html(
  //     data: strText,
  //     style: {
  //       "body": Style(
  //         color: gray,
  //         fontSize: FontSize(15),
  //         fontWeight: FontWeight.w500,
  //       ),
  //       "link": Style(
  //         color: colorAccent,
  //         fontSize: FontSize(15),
  //         fontWeight: FontWeight.w500,
  //       ),
  //     },
  //     onLinkTap: (url, _, __, ___) async {
  //       if (await canLaunchUrl(Uri.parse(url!))) {
  //         await launchUrl(
  //           Uri.parse(url),
  //           mode: LaunchMode.platformDefault,
  //         );
  //       } else {
  //         throw 'Could not launch $url';
  //       }
  //     },
  //     shrinkWrap: false,
  //   );
  // }

  static Future<void> shareVideo(context, videoTitle) async {
    try {
      String? shareMessage, shareDesc;
      shareDesc =
          "Hey I'm watching $videoTitle . Check it out now on ${Constant.appName}! and more.";
      if (Platform.isAndroid) {
        shareMessage = "$shareDesc\n${Constant.androidAppUrl}";
      } else {
        shareMessage = "$shareDesc\n${Constant.iosAppUrl}";
      }
      await FlutterShare.share(
        title: Constant.appName ?? "Storydek",
        linkUrl: shareMessage,
      );
    } catch (e) {
      debugPrint("shareFile Exception ===> $e");
      return;
    }
  }

  static Future<void> redirectToUrl(String url) async {
    debugPrint("_launchUrl url ===> $url");
    if (await canLaunchUrl(Uri.parse(url.toString()))) {
      await launchUrl(
        Uri.parse(url.toString()),
        mode: LaunchMode.platformDefault,
      );
    } else {
      throw "Could not launch $url";
    }
  }

  static Future<void> redirectToStore() async {
    final appId =
        Platform.isAndroid ? Constant.appPackageName : Constant.appleAppId;
    final url = Uri.parse(
      Platform.isAndroid
          ? "market://details?id=$appId"
          : "https://apps.apple.com/app/id$appId",
    );
    debugPrint("_launchUrl url ===> $url");
    if (await canLaunchUrl(Uri.parse(url.toString()))) {
      await launchUrl(
        Uri.parse(url.toString()),
        mode: LaunchMode.platformDefault,
      );
    } else {
      throw "Could not launch $url";
    }
  }

  static Future<void> shareApp(shareMessage) async {
    try {
      await FlutterShare.share(
        title: Constant.appName ?? "",
        linkUrl: shareMessage,
      );
    } catch (e) {
      debugPrint("shareFile Exception ===> $e");
      return;
    }
  }

  /* ***************** generate Unique OrderID START ***************** */
  static String generateRandomOrderID() {
    int getRandomNumber;
    String? finalOID;
    debugPrint("fixFourDigit =>>> ${Constant.fixFourDigit}");
    debugPrint("fixSixDigit =>>> ${Constant.fixSixDigit}");

    number.Random r = number.Random();
    int ran5thDigit = r.nextInt(9);
    debugPrint("Random ran5thDigit =>>> $ran5thDigit");

    int randomNumber = number.Random().nextInt(9999999);
    debugPrint("Random randomNumber =>>> $randomNumber");
    if (randomNumber < 0) {
      randomNumber = -randomNumber;
    }
    getRandomNumber = randomNumber;
    debugPrint("getRandomNumber =>>> $getRandomNumber");

    finalOID = "${Constant.fixFourDigit.toInt()}"
        "$ran5thDigit"
        "${Constant.fixSixDigit.toInt()}"
        "$getRandomNumber";
    debugPrint("finalOID =>>> $finalOID");

    return finalOID;
  }
  /* ***************** generate Unique OrderID END ***************** */

  /* ***************** Download ***************** */
  static Future<String> prepareSaveDir() async {
    String localPath = (await _getSavedDir())!;
    log("localPath ------------> $localPath");
    final savedDir = Directory(localPath);
    log("savedDir -------------> $savedDir");
    log("is exists ? ----------> ${savedDir.existsSync()}");
    if (!(await savedDir.exists())) {
      await savedDir.create(recursive: true);
    }
    return localPath;
  }

  static Future<String?> _getSavedDir() async {
    String? externalStorageDirPath;

    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      try {
        externalStorageDirPath = "${directory?.absolute.path}/downloads/";
      } catch (err, st) {
        log('failed to get downloads path: $err, $st');
        externalStorageDirPath = "${directory?.absolute.path}/downloads/";
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath = (await getApplicationDocumentsDirectory()).path;
    }
    log("externalStorageDirPath ------------> $externalStorageDirPath");
    return externalStorageDirPath;
  }

  static Future<String> prepareShowSaveDir(
      String showName, String seasonName) async {
    log("showName -------------> $showName");
    log("seasonName -------------> $seasonName");
    String localPath = (await _getShowSavedDir(showName, seasonName))!;
    final savedDir = Directory(localPath);
    log("savedDir -------------> $savedDir");
    log("savedDir path --------> ${savedDir.path}");
    if (!savedDir.existsSync()) {
      await savedDir.create(recursive: true);
    }
    return localPath;
  }

  static Future<String?> _getShowSavedDir(
      String showName, String seasonName) async {
    String? externalStorageDirPath;

    if (Platform.isAndroid) {
      try {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath =
            "${directory?.path}/downloads/${showName.toLowerCase()}/${seasonName.toLowerCase()}";
      } catch (err, st) {
        log('failed to get downloads path: $err, $st');
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath =
            "${directory?.path}/downloads/${showName.toLowerCase()}/${seasonName.toLowerCase()}";
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          "${(await getApplicationDocumentsDirectory()).absolute.path}/downloads/${showName.toLowerCase()}/${seasonName.toLowerCase()}";
    }
    return externalStorageDirPath;
  }

  static Future<void> setDownloadComplete(
      BuildContext context,
      String downloadType,
      int? itemId,
      int? videoType,
      int? typeId,
      int? otherId) async {
    // final showDetailsProvider =
    //     Provider.of<ShowDetailsProvider>(context, listen: false);
    // showDetailsProvider.setDownloadComplete(
    //   context,
    //   itemId,
    //   videoType,
    //   typeId,
    //   otherId,
    // );
  }
  /* ***************** Download ***************** */

  static Future<File?> saveAudioInStorage(audioUrl, audioTitle) async {
    try {
      var response = await http.get(Uri.parse(audioUrl));
      Directory? documentDirectory;
      if (Platform.isAndroid) {
        documentDirectory = await getExternalStorageDirectory();
      } else {
        documentDirectory = await getApplicationDocumentsDirectory();
      }
      File file = File(path.join(documentDirectory?.path ?? "",
          '${audioTitle.toString().replaceAll(" ", "").toLowerCase()}.aac'));
      file.writeAsBytesSync(response.bodyBytes);
      debugPrint("saveAudioInStorage file ===> ${file.path}");
      Fluttertoast.showToast(
        msg: "Download Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: white,
        textColor: black,
        fontSize: 14,
      );
      return file;
    } catch (e) {
      debugPrint("saveAudioInStorage Exception ===> $e");
      return null;
    }
  }

  static Future<File> moveFile(File sourceFile, String extension) async {
    Directory? documentDirectory;
    if (Platform.isAndroid) {
      documentDirectory = await getExternalStorageDirectory();
    } else {
      documentDirectory = await getApplicationDocumentsDirectory();
    }
    String newPath =
        "${documentDirectory?.path ?? ""}/${DateTime.now().millisecondsSinceEpoch.toString()}$extension";
    try {
      /// prefer using rename as it is probably faster
      /// if same directory path
      return await sourceFile.rename(newPath);
    } catch (e) {
      /// if rename fails, copy the source file
      final newFile = await sourceFile.copy(newPath);
      return newFile;
    }
  }
}
