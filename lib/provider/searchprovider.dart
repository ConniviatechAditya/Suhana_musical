import 'package:dtpocketfm/model/categorymodel.dart';
import 'package:dtpocketfm/model/languagemodel.dart';
import 'package:dtpocketfm/model/searchmodel.dart';
import 'package:dtpocketfm/model/topsearchmodel.dart';
import 'package:dtpocketfm/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  
  SearchModel searchModel = SearchModel();
  CategoryModel categoryModel = CategoryModel();
  TopsearchModel topsearchModel = TopsearchModel();
  LanguageModel languageModel = LanguageModel();
  bool loading = false;

  getSearch(String title, String userid) async {
    loading = true;
    searchModel = await ApiService().search(userid, title);
    loading = false;
    notifyListeners();
  }

   getCategory(String pageno) async {
    loading = true;
    categoryModel = await ApiService().category(pageno);
    loading = false;
    notifyListeners();
  }


  getTopSearch(String pageno) async {
    loading = true;
    topsearchModel = await ApiService().topsearch(pageno);
    loading = false;
    notifyListeners();
  }

  getLanguage(String pageno) async {
    loading = true;
    languageModel = await ApiService().language(pageno);
    loading = false;
    notifyListeners();
  }
}
