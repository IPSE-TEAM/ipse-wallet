import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:scan/scan.dart';

class ScanPage extends StatefulWidget {
  static final String route = '/scan';
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  ScanController controller = ScanController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context,'',isBackFFF:true, backgroundColor: Colors.black, actions: [
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.image),
          onPressed: () async {
            List<Media> res = await ImagesPicker.pick();
            if (res != null) {
              String qrcode = await Scan.parse(res[0].path);
              print(qrcode);
              if (qrcode == null) {
                controller.resume();
                showErrorMsg(I18n.of(context).my['noValidQR']);
                return;
              }
              Navigator.pop(context, qrcode);
            }
          },
        )
      ]),
      body: Stack(
        children: [
          Container(
            child: ScanView(
              controller: controller,
              scanAreaScale: .6,
              scanLineColor: Theme.of(context).primaryColor,
              onCapture: (qrcode) {
                Navigator.pop(context, qrcode);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  child: Text(I18n.of(context).my['flashlight']),
                  onPressed: () {
                    controller.toggleTorchMode();
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
