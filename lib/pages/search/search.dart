import 'package:flutter/material.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/model/resource.dart';
import 'package:ipsewallet/pages/home.dart';
import 'package:ipsewallet/pages/search/search_results.dart';
import 'package:ipsewallet/store/ipse.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  Search(this._ipseStore);
  final IpseStore _ipseStore;
  static String route = "/search";
  @override
  _SearchState createState() => _SearchState(_ipseStore);
}

class _SearchState extends State<Search> {
  _SearchState(
    this._ipseStore,
  );
  TextEditingController _queryTextController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  IpseStore _ipseStore;
  List<String> _history = <String>[];
  SharedPreferences _sharedPreferences;
  String lastSearchString;
  bool isFormVideo = false;
  String query = "";
  int count = 0;

  getHistory() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    if (mounted)
      setState(() {
        _history = _sharedPreferences.getStringList("history_search") ?? [];
      });
  }

  setHistory(String item) {
    _history.insert(0, item);
    if (_history.length > 1000) _history.sublist(0, 1000);
    _sharedPreferences.setStringList("history_search", _history);
  }

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName(Home.route));
            },
            icon: Image.asset('assets/images/a/back.png'),
          ),
          title: TextField(
            controller: _queryTextController,
            focusNode: _focusNode,
            onChanged: (v) {
              setState(() {
                query = v.trim();
              });
            },
            autofocus: true,
            textInputAction: TextInputAction.search,
            onSubmitted: (String _) {
              showResults(context);
            },
            decoration: InputDecoration(
                fillColor: Config.bgColor,
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        tooltip: 'Clear',
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _queryTextController.text = "";
                            query = '';
                          });
                        },
                      )
                    : null,
                hintText: I18n.of(context).ipse['search_whatever'],
                hintStyle: TextStyle(fontWeight: FontWeight.w300)),
          ),
          actions: [
            IconButton(
              tooltip: 'Search',
              icon: Icon(Icons.search),
              onPressed: () {
                showResults(context);
              },
            )
          ]),
      body: buildSuggestions(context),
    );
  }

  Widget buildSuggestions(BuildContext context) {
    int len = _history.length;
    len = len > 6 ? 6 : len;
    final Iterable<String> suggestionsIterable = query.isEmpty
        ? _history.sublist(0, len)
        : _history.where((String i) => '$i'.startsWith(query));

    List suggestions =
        suggestionsIterable.map<String>((String i) => '$i').toList();
    final ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: theme.textTheme.subtitle1
                  .copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: theme.textTheme.subtitle1,
                ),
              ],
            ),
          ),
          onTap: () {
            query = suggestion.trim();
            lastSearchString = query;
            showResults(context);
          },
        );
      },
    );
  }

  showResults(BuildContext context) {
    if (query.isNotEmpty && _history.indexOf(query) == -1) {
      setHistory(query);
    }
    if (query.isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => SearchResults(_ipseStore, query)));
    }
  }

}

class ResourceSearchEvent {
  final String query;
  const ResourceSearchEvent(this.query);
}

class ResourceSearchState {
  final bool isLoading;
  final List<Resource> resourceList;
  final bool hasError;

  const ResourceSearchState({this.isLoading, this.resourceList, this.hasError});

  factory ResourceSearchState.initial() {
    return ResourceSearchState(
      resourceList: [],
      isLoading: false,
      hasError: false,
    );
  }

  factory ResourceSearchState.loading() {
    return ResourceSearchState(
      resourceList: [],
      isLoading: true,
      hasError: false,
    );
  }

  factory ResourceSearchState.success(List<Resource> resourceList) {
    return ResourceSearchState(
      resourceList: resourceList,
      isLoading: false,
      hasError: false,
    );
  }

  factory ResourceSearchState.error() {
    return ResourceSearchState(
      resourceList: [],
      isLoading: false,
      hasError: true,
    );
  }

  @override
  String toString() =>
      'ResourceSearchState {resourceList: ${resourceList.toString()}, isLoading: $isLoading, hasError: $hasError }';
}
