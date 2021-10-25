import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/model/resource.dart';
import 'package:ipsewallet/model/search_params.dart';
import 'package:ipsewallet/pages/search/video.dart';
import 'package:ipsewallet/store/ipse.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/widgets/loading_widget.dart';
import 'package:ipsewallet/widgets/no_data.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchResults extends StatefulWidget {
  SearchResults(this.ipseStore, this.query);
  final String query;
  final IpseStore ipseStore;
  static String route = "/search_result";
  @override
  _SearchResultsState createState() => _SearchResultsState(ipseStore, query);
}

class _SearchResultsState extends State<SearchResults> {
  _SearchResultsState(this._ipseStore, this.query);
  String query;
  IpseStore _ipseStore;
  int _page = 1;
  int _size = 10; 
  Future<void> _onRefresh() async {
    SearchParams params =
        SearchParams(searchMatch: query, category: "", page: 1, size: _size);

    _ipseStore.getsearchResults(params);
  }

  Future<void> _onLoadMore() async {
    if (_page * _size <= _ipseStore.count) {
      setState(() {
        _page = _page + 1;
      });
      SearchParams params = SearchParams(
          searchMatch: query, category: "", page: _page, size: _size);

      await _ipseStore.getsearchResults(params);
    }
  }

  @override
  void initState() {
    super.initState();
    SearchParams params =
        SearchParams(searchMatch: query, category: "", page: 1, size: 10);

    _ipseStore.getsearchResults(params);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset('assets/images/a/back.png'),
          ),
          title: GestureDetector(
            child: Container(
              padding: EdgeInsets.all(12.0),
              color: Config.bgColor,
              child: Text(
                query,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
              ),
            ),
            onTap: () async {
              Navigator.pop(context);
            },
          ),
          actions: [Text('')],
        ),
        body: RefreshLoadmore(
          onRefresh: _onRefresh,
          onLoadmore: _onLoadMore,
          child: resultCard(context),
          isLastPage: _ipseStore.count != null
              ? (_page * _size > _ipseStore.count)
              : false,
        ),
      );
    });
  }

  Widget resultCard(
    BuildContext context,
  ) {
    return Observer(builder: (_) {
      if (_ipseStore.searchResults == null) {
        return Padding(
            padding: EdgeInsets.only(top: 50), child: LoadingWidget());
      } else if (_ipseStore.searchResults.isEmpty) {
        return NoData();
      } else {
        // return ListView.builder(
        //   itemCount: _ipseStore.searchResults.length,
        //   itemBuilder: (context, index) {
        //     return new ListTile(
        //       title: new Text('${_ipseStore.searchResults[0]}'),
        //     );
        //   },
        // );
        return Column(
          children: _ipseStore.searchResults
              .map(
                (e) => itemBuild(context, e),
              )
              .toList(),
        );
      }
    });
  }

  Widget itemBuild(
    BuildContext context,
    Resource item,
  ) {
    String baseurl = _ipseStore.url;
    String url = baseurl + item.hash;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      color: Colors.white,
      child: ListTile(
        onTap: () async {
          if (item.category == "video") {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    Video(_ipseStore, item, url)));
          } else {
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              showErrorMsg('Could not launch $url');
            }
          }
        },
        contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 13.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(Adapt.px(5)),
              decoration: BoxDecoration(
                  color: showColor(item.category),
                  borderRadius: BorderRadiusDirectional.circular(Adapt.px(10))),
              child: Text(
                "${item.category}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Adapt.px(18),
                ),
              ),
            ),
            SizedBox(width: 5.0),
            Expanded(
              child: Text(
                "${item.label}",
                style: TextStyle(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        subtitle: Wrap(
          runSpacing: 3.0,
          children: <Widget>[
            Text(
              "${item.describe != "None" ? item.describe : ''}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "${item.hash}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(color: Config.color999,fontSize: Adapt.px(25)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        Image.asset('assets/images/ipse/time.png'),
                        SizedBox(width: 3),
                        Text(
                          "${item.addtime}",
                          style: TextStyle(color: Config.color999,fontSize: Adapt.px(25)),
                        ),
                        SizedBox(width: 15),
                        Image.asset('assets/images/ipse/size.png'),
                        SizedBox(width: 3),
                        Text(
                          "${sizefilter(item.size)}",
                          style: TextStyle(color: Config.color999,fontSize: Adapt.px(25)),
                        ),
                      ],
                    ),
                  ],
                ),
                // pictures
                item.pcid.isNotEmpty
                    ? Image.network(
                        baseurl + item.pcid,
                        fit: BoxFit.cover,
                        width: 100.0,
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
