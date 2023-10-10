import 'package:dtpocketfm/model/bookmarklistmodel.dart';
import 'package:dtpocketfm/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class LibraryProvider extends ChangeNotifier {
  BookmarklistModel bookmarklistModel = BookmarklistModel();
  bool loading = false;

  getBookmarklist(String userid,String pageno) async {
    loading = true;
    bookmarklistModel = await ApiService().bookmarklist(userid,pageno);
    loading = false;
    notifyListeners();
  }
}
