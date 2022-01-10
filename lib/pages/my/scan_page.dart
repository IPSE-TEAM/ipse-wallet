import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      appBar: myAppBar(context, '',
          isBackFFF: true,
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.image),
              onPressed: () async {
                FilePickerResult result;
                PlatformFile file;
                try {
                  result =
                      await FilePicker.platform.pickFiles(type: FileType.image);
                } on PlatformException catch (e) {
                  print(e);
                  if (e.message != null) showErrorMsg(e.message);
                  return;
                }

                if (result == null) return;
                file = result.files.first;

                if (file.path != null) {
                  String qrcode = await Scan.parse(file.path);

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
