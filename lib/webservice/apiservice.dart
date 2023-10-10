import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_logger/dio_logger.dart';
import 'package:dtpocketfm/model/addaudioplaymodel.dart';
import 'package:dtpocketfm/model/addcontinuewatchingmodel.dart';
import 'package:dtpocketfm/model/addrating.dart';
import 'package:dtpocketfm/model/addreviewmodel.dart';
import 'package:dtpocketfm/model/deleteaccountmodel.dart';
import 'package:dtpocketfm/model/getaudiobycategorymodel.dart';
import 'package:dtpocketfm/model/bannermodel.dart';
import 'package:dtpocketfm/model/bookmarklistmodel.dart';
import 'package:dtpocketfm/model/bookmarkmodel.dart';
import 'package:dtpocketfm/model/categorymodel.dart';
import 'package:dtpocketfm/model/continuewatchingmodel.dart';
import 'package:dtpocketfm/model/detailmodel.dart';
import 'package:dtpocketfm/model/generalsettingmodel.dart';
import 'package:dtpocketfm/model/getaudiobylanguagemodel.dart';
import 'package:dtpocketfm/model/getcastbyaudioidmodel.dart';
import 'package:dtpocketfm/model/getcommentbyaudioidmodel.dart';
import 'package:dtpocketfm/model/getepisodebyaudioidmodel.dart';
import 'package:dtpocketfm/model/getnotificatiomodel.dart';
import 'package:dtpocketfm/model/getpagesmodel.dart';
import 'package:dtpocketfm/model/getrelatedaudiobyaudioidmodel.dart';
import 'package:dtpocketfm/model/gettopplaymodel.dart';
import 'package:dtpocketfm/model/languagemodel.dart';
import 'package:dtpocketfm/model/loginmodel.dart';
import 'package:dtpocketfm/model/newreleasemodel.dart';
import 'package:dtpocketfm/model/paymentoptionmodel.dart';
import 'package:dtpocketfm/model/premiumaudiomodel.dart';
import 'package:dtpocketfm/model/premiummodel.dart';
import 'package:dtpocketfm/model/profilemodel.dart';
import 'package:dtpocketfm/model/readnotificationmodel.dart';
import 'package:dtpocketfm/model/removecontinuewatchingmodel.dart';
import 'package:dtpocketfm/model/searchmodel.dart';
import 'package:dtpocketfm/model/topratingaudiomodel.dart';
import 'package:dtpocketfm/model/topsearchmodel.dart';
import 'package:dtpocketfm/model/transectionmodel.dart';
import 'package:dtpocketfm/model/updateprofilemodel.dart';
import 'package:dtpocketfm/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ApiService {
  String baseurl = Constant().baseurl;
  late Dio dio;

  ApiService() {
    dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.interceptors.add(dioLoggerInterceptor);
  }

  Future<GeneralsettingModel> generalsetting() async {
    GeneralsettingModel generalsettingModel;
    String generalsetting = "general_setting";
    Response response = await dio.post('$baseurl$generalsetting');

    generalsettingModel = GeneralsettingModel.fromJson(response.data);
    return generalsettingModel;
  }

  Future<LoginModel> login(type, mobile, email) async {
    LoginModel loginModel;
    String login = "login";
    Response response = await dio.post('$baseurl$login',
        data: FormData.fromMap({
          'type': MultipartFile.fromString(type),
          'mobile_number': MultipartFile.fromString(mobile),
          'email': MultipartFile.fromString(email),
        }));

    loginModel = LoginModel.fromJson(response.data);
    return loginModel;
  }

  Future<ProfileModel> profile(String userid) async {
    ProfileModel profilemodel;
    String getprofile = "get_profile";
    Response response = await dio.post('$baseurl$getprofile',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
        }));

    profilemodel = ProfileModel.fromJson(response.data);
    return profilemodel;
  }

  Future<UpdateprofileModel> updateprofile(String userid, String fullname,
      String number, String bio, String email, File image) async {
    UpdateprofileModel updateprofileModel;
    String updateprofile = "update_profile";
    Response response = await dio.post('$baseurl$updateprofile',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'full_name': MultipartFile.fromString(fullname),
          'mobile_number': MultipartFile.fromString(number),
          'bio': MultipartFile.fromString(bio),
          'email': MultipartFile.fromString(email),
          if (image.path.isNotEmpty)
            "image": await MultipartFile.fromFile(image.path,
                filename: basename(image.path)),
        }));

    updateprofileModel = UpdateprofileModel.fromJson(response.data);
    return updateprofileModel;
  }

  Future<BannerModel> banner(
      String ishomepage, String type, String userid) async {
    debugPrint("ishomepage=> $ishomepage");
    debugPrint("type=> $type");
    BannerModel bannerModel;
    String banner = "get_banner";
    Response response = await dio.post('$baseurl$banner',
        data: FormData.fromMap({
          'is_home_page': MultipartFile.fromString(ishomepage),
          'type': MultipartFile.fromString(type),
          'user_id': MultipartFile.fromString(userid),
        }));

    bannerModel = BannerModel.fromJson(response.data);
    return bannerModel;
  }

  Future<CategoryModel> category(String pageno) async {
    CategoryModel categoryModel;
    String category = "get_category";
    Response response = await dio.post('$baseurl$category',
        data: FormData.fromMap({
          'page_no': MultipartFile.fromString(pageno),
        }));
    categoryModel = CategoryModel.fromJson(response.data);
    return categoryModel;
  }

  Future<PremiumModel> package(String userid) async {
    PremiumModel premiumModel;
    String premium = "get_package";
    Response response = await dio.post('$baseurl$premium',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
        }));
    premiumModel = PremiumModel.fromJson(response.data);
    return premiumModel;
  }

  // get_payment_option API
  Future<PaymentOptionModel> getPaymentOption() async {
    PaymentOptionModel paymentOptionModel;
    String paymentOption = "get_payment_option";
    log("paymentOption API :==> $baseurl$paymentOption");
    Response response = await dio.post('$baseurl$paymentOption');

    paymentOptionModel = PaymentOptionModel.fromJson(response.data);
    return paymentOptionModel;
  }

  Future<TopplayModel> topplay(
      String ishomepage, String type, String pageno) async {
    TopplayModel topplayModel;
    String gettopplay = "get_top_play_audio";
    Response response = await dio.post('$baseurl$gettopplay',
        data: FormData.fromMap({
          'is_home_page': MultipartFile.fromString(ishomepage),
          'type': MultipartFile.fromString(type),
          'page_no': MultipartFile.fromString(pageno),
        }));

    topplayModel = TopplayModel.fromJson(response.data);
    return topplayModel;
  }

  Future<TopratingaudioModel> topratingaudio(
      String ishomepage, String type, String pageno) async {
    TopratingaudioModel topratingaudioModel;
    String gettopratingaudio = "get_top_rating_audio";
    Response response = await dio.post('$baseurl$gettopratingaudio',
        data: FormData.fromMap({
          'is_home_page': MultipartFile.fromString(ishomepage),
          'type': MultipartFile.fromString(type),
          'page_no': MultipartFile.fromString(pageno),
        }));

    topratingaudioModel = TopratingaudioModel.fromJson(response.data);
    return topratingaudioModel;
  }

  Future<NewreleaseModel> newrelease(
      String ishomepage, String type, String pageno) async {
    NewreleaseModel newreleaseModel;
    String newrelease = "get_new_release";
    Response response = await dio.post('$baseurl$newrelease',
        data: FormData.fromMap({
          'is_home_page': MultipartFile.fromString(ishomepage),
          'type': MultipartFile.fromString(type),
          'page_no': MultipartFile.fromString(pageno),
        }));

    newreleaseModel = NewreleaseModel.fromJson(response.data);
    return newreleaseModel;
  }

  Future<ContinuewatchingModel> continuewatching(
      String userid, String pageno) async {
    ContinuewatchingModel continuewatchingModel;
    String getcontinuewatching = "get_continue_watching";
    Response response = await dio.post('$baseurl$getcontinuewatching',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'page_no': MultipartFile.fromString(pageno),
        }));

    continuewatchingModel = ContinuewatchingModel.fromJson(response.data);
    return continuewatchingModel;
  }

  Future<SearchModel> search(String userid, String title) async {
    SearchModel searchmodel;
    String search = "search_audio";
    Response response = await dio.post('$baseurl$search',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'title': MultipartFile.fromString(title),
        }));

    searchmodel = SearchModel.fromJson(response.data);
    return searchmodel;
  }

  Future<DetailModel> audiodetail(String audioid, String userid) async {
    DetailModel detailModel;
    String audiodetail = "audio_detail";
    Response response = await dio.post('$baseurl$audiodetail',
        data: FormData.fromMap({
          'audio_id': MultipartFile.fromString(audioid),
          'user_id': MultipartFile.fromString(userid),
        }));

    detailModel = DetailModel.fromJson(response.data);
    return detailModel;
  }

  Future<GetepisodebyaudioidModel> episodebyaudioid(
      String userid, String audioid, String pageno) async {
    GetepisodebyaudioidModel getepisodebyaudioidModel;
    String getepisodebyaudio = "get_episode_by_audio";
    Response response = await dio.post('$baseurl$getepisodebyaudio',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'audio_id': MultipartFile.fromString(audioid),
          'page_no': MultipartFile.fromString(pageno),
        }));

    getepisodebyaudioidModel = GetepisodebyaudioidModel.fromJson(response.data);
    return getepisodebyaudioidModel;
  }

  Future<GetcommentbyaudioidModel> commentbyaudioid(
      String userid, String audioid, String pageno) async {
    GetcommentbyaudioidModel getcommentbyaudioidModel;
    String getepisodebyaudio = "get_comment";
    Response response = await dio.post('$baseurl$getepisodebyaudio',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'audio_id': MultipartFile.fromString(audioid),
          'page_no': MultipartFile.fromString(pageno),
        }));

    getcommentbyaudioidModel = GetcommentbyaudioidModel.fromJson(response.data);
    return getcommentbyaudioidModel;
  }

  Future<GetrelatedaudiobyaudioidModel> relatedaudiobyaudioid(
      String audioid, String pageno, String categoryid) async {
    GetrelatedaudiobyaudioidModel getrelatedaudiobyaudioidModel;
    String getepisodebyaudio = "get_related_audio";
    Response response = await dio.post('$baseurl$getepisodebyaudio',
        data: FormData.fromMap({
          'audio_id': MultipartFile.fromString(audioid),
          'page_no': MultipartFile.fromString(pageno),
          'category_id': MultipartFile.fromString(categoryid),
        }));

    getrelatedaudiobyaudioidModel =
        GetrelatedaudiobyaudioidModel.fromJson(response.data);
    return getrelatedaudiobyaudioidModel;
  }

  Future<GetcastbyaudioidModel> castbyaudioid(
      String audioid, String pageno) async {
    GetcastbyaudioidModel getcastbyaudioidModel;
    String getepisodebyaudio = "get_cast_by_audio";
    Response response = await dio.post('$baseurl$getepisodebyaudio',
        data: FormData.fromMap({
          'audio_id': MultipartFile.fromString(audioid),
          'page_no': MultipartFile.fromString(pageno),
        }));

    getcastbyaudioidModel = GetcastbyaudioidModel.fromJson(response.data);
    return getcastbyaudioidModel;
  }

  Future<BookmarkModel> bookmark(String userid, String audioid) async {
    BookmarkModel bookmarkModel;
    String bookmark = "add_remove_bookmark";
    Response response = await dio.post('$baseurl$bookmark',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'audio_id': MultipartFile.fromString(audioid),
        }));

    bookmarkModel = BookmarkModel.fromJson(response.data);
    return bookmarkModel;
  }

  Future<GetaudiobycategoryModel> audiobycategory(
      String categoryid, String type, String pageno) async {
    GetaudiobycategoryModel getaudiobycategoryModel;
    String audiobycategory = "get_audio_by_category";
    Response response = await dio.post('$baseurl$audiobycategory',
        data: FormData.fromMap({
          'category_id': MultipartFile.fromString(categoryid),
          'type': MultipartFile.fromString(type),
          'page_no': MultipartFile.fromString(pageno),
        }));

    getaudiobycategoryModel = GetaudiobycategoryModel.fromJson(response.data);
    return getaudiobycategoryModel;
  }

  Future<GetaudiobylanguageModel> audiobylanguage(
      String languageid, String type, String pageno) async {
    debugPrint("Pageno =>$pageno");
    log("type =>$type");
    log("languageid =>$languageid");
    log("pageno =>$pageno");
    GetaudiobylanguageModel getaudiobylanguageModel;
    String audiobylanguage = "get_audio_by_language";
    Response response = await dio.post('$baseurl$audiobylanguage',
        data: FormData.fromMap({
          'language_id': MultipartFile.fromString(languageid),
          'type': MultipartFile.fromString(type),
          'page_no': MultipartFile.fromString(pageno),
        }));

    getaudiobylanguageModel = GetaudiobylanguageModel.fromJson(response.data);
    return getaudiobylanguageModel;
  }

  Future<TopsearchModel> topsearch(String pageno) async {
    TopsearchModel topsearchModel;
    String topsearch = "get_top_search";
    Response response = await dio.post('$baseurl$topsearch',
        data: FormData.fromMap({
          'page_no': MultipartFile.fromString(pageno),
        }));

    topsearchModel = TopsearchModel.fromJson(response.data);
    return topsearchModel;
  }

  Future<LanguageModel> language(String pageno) async {
    LanguageModel languageModel;
    String language = "get_language";
    Response response = await dio.post('$baseurl$language',
        data: FormData.fromMap({
          'page_no': MultipartFile.fromString(pageno),
        }));

    languageModel = LanguageModel.fromJson(response.data);
    return languageModel;
  }

  Future<BookmarklistModel> bookmarklist(String userid, String pageno) async {
    BookmarklistModel bookmarklistModel;
    String bookmarklist = "get_bookmark_audio";
    Response response = await dio.post('$baseurl$bookmarklist',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'page_no': MultipartFile.fromString(pageno),
        }));

    bookmarklistModel = BookmarklistModel.fromJson(response.data);
    return bookmarklistModel;
  }

  Future<TransectionModel> transection(
      String userid,
      String packageid,
      String paymentid,
      String amount,
      String discription,
      String currencycode) async {
    TransectionModel transectionModel;
    String transection = "add_transaction";
    Response response = await dio.post('$baseurl$transection',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'package_id': MultipartFile.fromString(packageid),
          'payment_id': MultipartFile.fromString(paymentid),
          'amount': MultipartFile.fromString(amount),
          'description': MultipartFile.fromString(discription),
          'currency_code': MultipartFile.fromString(currencycode),
        }));

    transectionModel = TransectionModel.fromJson(response.data);
    return transectionModel;
  }

  Future<PremiumaudioModel> premiumaudio(
      String ishomepage, String type, String pageno) async {
    PremiumaudioModel premiumaudioModel;
    String premiumaudio = "get_premium_audio";
    Response response = await dio.post('$baseurl$premiumaudio',
        data: FormData.fromMap({
          'is_home_page': MultipartFile.fromString(ishomepage),
          'type': MultipartFile.fromString(type),
          'page_no': MultipartFile.fromString(pageno),
        }));

    premiumaudioModel = PremiumaudioModel.fromJson(response.data);
    return premiumaudioModel;
  }

  Future<AddreviewModel> addreview(
      String userid, String audioid, String comment) async {
    AddreviewModel addreviewModel;
    String addreview = "add_review";
    Response response = await dio.post('$baseurl$addreview',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'audio_id': MultipartFile.fromString(audioid),
          'comment': MultipartFile.fromString(comment),
        }));

    addreviewModel = AddreviewModel.fromJson(response.data);
    return addreviewModel;
  }

  Future<AddratingModel> addrating(
      String userid, String audioid, String rating) async {
    AddratingModel addratingModel;
    String addrating = "add_rating";
    Response response = await dio.post('$baseurl$addrating',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'audio_id': MultipartFile.fromString(audioid),
          'rating': MultipartFile.fromString(rating),
        }));

    addratingModel = AddratingModel.fromJson(response.data);
    return addratingModel;
  }

  Future<Addaudioplaymodel> addaudioplay(String userid, String audioid) async {
    Addaudioplaymodel addaudioplaymodel;
    String continuewatching = "add_audio_play";
    Response response = await dio.post('$baseurl$continuewatching',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'audio_id': MultipartFile.fromString(audioid),
        }));

    addaudioplaymodel = Addaudioplaymodel.fromJson(response.data);
    return addaudioplaymodel;
  }

  Future<DeleteaccountModel> deleteaccount(String userid) async {
    DeleteaccountModel deleteaccountModel;
    String deleteaccount = "delete_account";
    Response response = await dio.post('$baseurl$deleteaccount',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
        }));

    deleteaccountModel = DeleteaccountModel.fromJson(response.data);
    return deleteaccountModel;
  }

  Future<GetnotificationModel> notification(String userid, pageno) async {
    GetnotificationModel getnotificationModel;
    String notification = "get_notification";
    Response response = await dio.post('$baseurl$notification',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'page_no': MultipartFile.fromString(pageno),
        }));

    getnotificationModel = GetnotificationModel.fromJson(response.data);
    return getnotificationModel;
  }

  Future<ReadnotificationModel> readnotification(
      String userid, notificationid) async {
    ReadnotificationModel readnotificationModel;
    String readnotification = "read_notification";
    Response response = await dio.post('$baseurl$readnotification',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'notification_id': MultipartFile.fromString(notificationid),
        }));

    readnotificationModel = ReadnotificationModel.fromJson(response.data);
    return readnotificationModel;
  }

  Future<AddcontinuewatchingModel> addcontinuewatching(
      String userid, String audioid, String episodeid, String stoptime) async {
    AddcontinuewatchingModel addcontinuewatchingModel;
    String continuewatching = "add_continue_watching";
    Response response = await dio.post('$baseurl$continuewatching',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'audio_id': MultipartFile.fromString(audioid),
          'episode_id': MultipartFile.fromString(episodeid),
          'stop_time': MultipartFile.fromString(stoptime),
        }));

    addcontinuewatchingModel = AddcontinuewatchingModel.fromJson(response.data);
    return addcontinuewatchingModel;
  }

  Future<RemovecontinuewatchingModel> removecontinuewatching(
      String userid, String audioid, String episodeid) async {
    RemovecontinuewatchingModel removecontinuewatchingModel;
    String removecontinuewatching = "remove_continue_watching";
    Response response = await dio.post('$baseurl$removecontinuewatching',
        data: FormData.fromMap({
          'user_id': MultipartFile.fromString(userid),
          'audio_id': MultipartFile.fromString(audioid),
          'episode_id': MultipartFile.fromString(episodeid),
        }));

    removecontinuewatchingModel =
        RemovecontinuewatchingModel.fromJson(response.data);
    return removecontinuewatchingModel;
  }

  Future<GetpagesModel> getpages() async {
    GetpagesModel getpagesModel;
    String getpages = "get_pages";
    Response response = await dio.post('$baseurl$getpages');
    getpagesModel = GetpagesModel.fromJson(response.data);
    return getpagesModel;
  }
}
