import 'package:flutter/material.dart';

class SearchParams {
  String searchMatch;
  String category = "";
  int page = 1;
  int size = 10;
  SearchParams(
      {@required this.searchMatch,
      @required this.category,
      @required this.page,
      @required this.size});

  Map<String, dynamic> toJson() => {
        "search_match": searchMatch,
        "category": category,
        "page": page,
        "size": size,
      };
}
