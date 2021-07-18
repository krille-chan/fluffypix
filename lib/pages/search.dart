import 'package:flutter/material.dart';

import 'views/search_view.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageController createState() => SearchPageController();
}

class SearchPageController extends State<SearchPage> {
  @override
  Widget build(BuildContext context) => SearchPageView(this);
}