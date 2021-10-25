// import 'package:custom_chewie/custom_chewie.dart';
import 'package:flutter/material.dart';
// import 'package:custom_chewie/custom_chewie.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/model/resource.dart';
import 'package:ipsewallet/store/ipse.dart';
import 'package:ipsewallet/utils/UI.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';

class Video extends StatefulWidget {
  final Resource videoData;
  final String url;
  final IpseStore ipseStore;
  Video(this.ipseStore, this.videoData, this.url);
  @override
  _VideoState createState() => _VideoState(ipseStore);
}

class _VideoState extends State<Video> {
  _VideoState(this.ipseStore);
  IjkMediaController ijkMediaController;
  Orientation get orientation => MediaQuery.of(context).orientation;
  IpseStore ipseStore;
  @override
  void initState() {
    super.initState();

    ijkMediaController = IjkMediaController();
    var option1 = IjkOption(IjkOptionCategory.format, "fflags", "fastseek");

    ijkMediaController.setNetworkDataSource(
      widget.url,
      autoPlay: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    ijkMediaController.dispose();
    unlockOrientation();
    // controller.dispose();
  }

  setLandScapeLeft() async {
    await IjkManager.setLandScape();
  }

  portraitUp() async {
    await IjkManager.setPortrait();
  }

  unlockOrientation() async {
    await IjkManager.unlockOrientation();
  }

  @override
  Widget build(BuildContext context) {
    // portraitUp();
    return Observer(builder: (_) {
      if (orientation == Orientation.landscape) {
        // unlockOrientation();
        setLandScapeLeft();
        return _buildFullScreenPlayer();
      }
      unlockOrientation();

      return Scaffold(
        appBar: myAppBar(context, "${widget.videoData.label}"),
        body: Container(
          child: ListView(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1280 / 720,
                child: IjkPlayer(
                  mediaController: ijkMediaController,
                ),
              ),
              Container(
                  child: ListTile(
                title: Text(widget.videoData.label),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${widget.videoData.describe != "None" ? widget.videoData.describe : ''}",
                    ),
                    SizedBox(height: 7),
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Container(
                              width: Adapt.px(600),
                              child: Text(
                                widget.url,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                          Icon(Icons.open_in_new,
                              size: 16, color: Theme.of(context).primaryColor)
                        ],
                      ),
                      onTap: () => UI.launchURL(widget.url),
                    ),
                    Divider(),
                    Text(
                        "${widget.videoData.address} ${I18n.of(context).ipse['upload_on']} ${widget.videoData.addtime}"),
                   SizedBox(height: 10),
                    Row(
                      children: [
                        Image.asset('assets/images/ipse/size.png'),
                        SizedBox(width: 3),
                        Text("${sizefilter(widget.videoData.size)}"),
                      ],
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      );
    });
  }

  _buildFullScreenPlayer() {
    return WillPopScope(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            IjkPlayer(
              mediaController: ijkMediaController,
              controllerWidgetBuilder: (con) {
                return DefaultIJKControllerWidget(
                  controller: con,
                  currentFullScreenState: true,
                ); 
              },
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: TextButton(
                  onPressed: portraitUp,
                  child: Text(""),
                )),
          ],
        ),
      ),
      onWillPop: () async {
        if (orientation == Orientation.landscape) {
          portraitUp();
          return false;
        }
        return true;
      },
    );
  }
}
