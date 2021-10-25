import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/model/ipse_register_status_model.dart';
import 'package:ipsewallet/pages/my/add_label/add_label.dart';
import 'package:ipsewallet/pages/my/tx_confirm_page.dart';
import 'package:ipsewallet/service/request_service.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/loading.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/utils/result_data.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/rounded_button.dart';

class CreateOrder extends StatefulWidget {
  CreateOrder(this.appStore);
  final AppStore appStore;
  static String route = "/my/CreateOrder";
  @override
  _CreateOrderState createState() => _CreateOrderState(appStore);
}

class _CreateOrderState extends State<CreateOrder> {
  _CreateOrderState(this.store);
  final AppStore store;

  final Api api = webApi;
  int kib;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _labelCtrl = new TextEditingController();
  final TextEditingController _daysCtrl = new TextEditingController();
  final TextEditingController _descCtrl = new TextEditingController();

  final FocusNode _descNode = FocusNode();
  final FocusNode _labelNode = FocusNode();
  final FocusNode _daysNode = FocusNode();
  bool _enableBtn = false;
  
  IpseRegisterStatusModel miner;
  String category;
  String fileName;
  String hash;
  int size;
  String filePath;
  BigInt amount;
  bool isAmountLow = false;
  double available = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        miner = ModalRoute.of(context).settings.arguments;
      });
    });
  }

  Future<void> _onSave() async {
    if (_formKey.currentState.validate()) {

      Loading.showLoading(context);
      String url = miner.url;
      String address = store.account.currentAddress;
      int days = int.parse(_daysCtrl.text.trim());
      print(days);
      ResultData res = await RequestService.addLabelToMiner(
          fileName,
          url,
          address,
          hash,
          _labelCtrl.text.trim(),
          category,
          _descCtrl.text.trim(),
          days);
      print(res.data);
      if (res.code == 111) {
        Loading.hideLoading(context);
        return;
      }
// miner, label, hash, size, url, days, unit_price
      var args = {
        "title": I18n.of(context).ipse['add_label'],
        "txInfo": {
          "module": 'ipse',
          "call": 'createOrder',
        },
        "detail": jsonEncode({
          "miner": miner.accountId,
          "label": _labelCtrl.text.trim(),
          "hash": hash,
          "size": size*1024,
          "url": url,
          "days": days,
          "unit_price": miner.unitPrice.toString()
        }),
        "params": [
          miner.accountId,
          _labelCtrl.text.trim(),
          hash,
          size*1024,
          url,
          days,
          miner.unitPrice.toString()
        ],
        'onFinish': (BuildContext txPageContext, Map res) {
          Navigator.popUntil(
              txPageContext, ModalRoute.withName(AddLabel.route));
        }
      };
      Loading.hideLoading(context);
      Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args);
    }
  }

  @override
  void dispose() {
    _labelCtrl.dispose();

    _daysCtrl.dispose();
    _descCtrl.dispose();
    _descNode.dispose();
    _labelNode.dispose();

    _daysNode.dispose();
    super.dispose();
  }


  String _selectFileType(String type) {
    String returnType = 'other';
    type = type?.toLowerCase();
    if (type.indexOf(new RegExp(
            r'(png)|(jpg)|(jpeg)|(webp)|(bmp)|(gif)|(tif)|(svg)|(tga)|(eps)|(exr)')) !=
        -1) {
      returnType = 'image';
    } else if (type.indexOf(new RegExp(
            r'(avi)|(mov)|(mp4)|(rmvb)|(rm)|(flv)|(3gp)|(flash)|(wmv)|(mpeg)|(realvideo)')) !=
        -1) {
      returnType = 'video';
    } else if (type
            .indexOf(new RegExp(r'(wma)|(aac)|(mp3)|(amr)|(3gp)|(wav)')) !=
        -1) {
      returnType = 'audio';
    } else if (type.indexOf('htm') != -1) {
      returnType = 'html';
    } else if (type.indexOf(new RegExp(
            r'(rar)|(zip)|(7z)|(cab)|(arj)|(lzh)|(tar)|(gz)|(ace)|(uue)|(bz2)|(jar)|(iso)')) !=
        -1) {
      returnType = 'package';
    }
    return returnType;
  }


  Future<void> _upload() async {
    FilePickerResult result;
    PlatformFile file;
    try {
      result = await FilePicker.platform.pickFiles();
    } on PlatformException catch (e) {
      print(e);
      if (e.message != null) showErrorMsg(e.message);
      return;
    }

    if (result == null) return;
    file = result.files.first;
    print("size:");
    print(file.size);
    print("categary:");
    print(file.extension);

    if (file.size < 1000) {
      return showErrorMsg(I18n.of(context).ipse['over_size']);
    }
    if (mounted) {
      setState(() {
        filePath = file.path;
        size = int.parse((file.size/1000).toStringAsFixed(0));
      });
    }
    computAmount();

    String type = _selectFileType(file.extension);
    print(type);
    List nameList = file.name.split('/');
    if (mounted) {
      setState(() {
        fileName = nameList.last;
        category = type;
      });
    }

    File uploadFile = new File(filePath);
    var option = Options(
      method: "POST",
      contentType: Headers.formUrlEncodedContentType,
      headers: {
        // HttpHeaders.contentTypeHeader: ContentType.binary,
        HttpHeaders.contentLengthHeader: uploadFile.lengthSync(),
      },
    ); 
    Dio dio = new Dio();
    String address = store.account.currentAddress;
    Loading.showLoading(context);
    try {
      var res = await dio.post(
        "${miner.url}/api/v0/order/$address",
        data: uploadFile.openRead(),
        options: option,
        onSendProgress: (int sent, int total) {
          print( (sent / total * 100).toStringAsFixed(0) + "%");
        },
      );

      Loading.hideLoading(context);
   
      if (res != null &&
          res.data != null &&
          (res.data as Map)['hash'] != null &&
          mounted) {
        setState(() {
          hash = (res.data as Map)['hash'];
        });
      }
    } catch (e) {
      Loading.hideLoading(context);
      showErrorMsg(I18n.of(context).ipse["upload_retry"]+e.toString());
    }
  }


  void computAmount() {
    if (mounted &&
        miner != null &&
        _daysCtrl.text.trim().isNotEmpty &&
        size != null) {
      int decimals = store.settings.networkState.tokenDecimals;

      BigInt dayPrice = miner.unitPrice * BigInt.from(size) * BigInt.from(1024);
      BigInt totalPrice = dayPrice * BigInt.parse(_daysCtrl.text.trim());

      setState(() {
        amount = totalPrice;
        isAmountLow = Fmt.bigIntToDouble(amount, decimals) >= available;
      });
    } else {
      setState(() {
        amount = null;
        isAmountLow = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).ipse;
    var assetDic = I18n.of(context).assets;
    String symbol = store.settings.networkState.tokenSymbol;
    int decimals = store.settings.networkState.tokenDecimals;

    if (store.assets.balances[symbol] != null) {
      setState(() {
        available = Fmt.bigIntToDouble(
            store.assets.balances[symbol].transferable, decimals);
      });
    }
    return Scaffold(
      appBar: myAppBar(context, I18n.of(context).ipse['add_label']),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: () => setState(() => _enableBtn =
                    _formKey.currentState.validate() &&
                        category != null &&
                        miner != null &&
                        hash != null &&
                        !isAmountLow),
                child: ListView(
                  padding: EdgeInsets.all(Adapt.px(30)),
                  children: <Widget>[
                    Center(
                      child: GestureDetector(
                        onTap: _upload,
                        child: Column(
                          children: [
                            Icon(
                              Icons.cloud_upload,
                              size: Adapt.px(140),
                            ),
                            Text(
                              dic['click_upload'],
                              style: TextStyle(color: Config.color666),
                            ),
                            SizedBox(height: 5),
                            Text(
                              filePath ?? '',
                              style: TextStyle(
                                  color: Config.color999,
                                  fontSize: Adapt.px(20)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    hash == null
                        ? Container()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "hash:",
                                style: TextStyle(
                                    color: Config.color666,
                                    fontSize: Adapt.px(28)),
                              ),
                              SizedBox(height: 8),
                              Text(
                                hash ?? '',
                                style: TextStyle(
                                    color: Config.color666,
                                    fontSize: Adapt.px(22)),
                              ),
                              SizedBox(height: 15),
                              Text(
                                dic["size"] + ": $size KB",
                                style: TextStyle(
                                    color: Config.color666,
                                    fontSize: Adapt.px(28)),
                              ),
                              SizedBox(height: 15),
                              Text(
                                dic["category"] + ": ${category ?? ''}",
                                style: TextStyle(
                                    color: Config.color666,
                                    fontSize: Adapt.px(28)),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        hintText: dic['label'],
                      ),
                      focusNode: _labelNode,
                      onFieldSubmitted: (v) {
                        _daysNode.requestFocus();
                      },
                      maxLength: 18,
                      validator: (v) {
                        if (v.trim().isEmpty) {
                          return I18n.of(context).home['required'];
                        }

                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      controller: _labelCtrl,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        hintText: dic['days'],
                      ),
                      focusNode: _daysNode,
                      onFieldSubmitted: (v) {
                        _descNode.requestFocus();
                      },
                      onChanged: (v) {
                        computAmount();
                      },
                      maxLength: 6,
                      validator: (v) {
                        if (v.trim().isEmpty) {
                          return I18n.of(context).home['required'];
                        }

                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      controller: _daysCtrl,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        labelText: dic['description_p'],
                        hintText: dic['description'],
                      ),
                      focusNode: _descNode,
                      onFieldSubmitted: (v) {
                        if (_enableBtn) {
                          _onSave();
                        }
                      },
                      maxLength: 140,
                      validator: (v) {
                        if (v.trim().isNotEmpty && v.trim().length < 2) {
                          return I18n.of(context).my['formatMistake'];
                        }

                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      controller: _descCtrl,
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${dic['estimated_cost']} (${assetDic['balance']}: ${Fmt.priceFloor(
                      available,
                      lengthMax: 3,
                    )} $symbol)',
                    style: TextStyle(color: Config.color666),
                  ),
                  SizedBox(height: 10),
                  Text(amount == null
                      ? ''
                      : "${Fmt.token(amount, decimals, length: decimals)} $symbol"),
                  isAmountLow
                      ? Text(
                          assetDic['amount.low'],
                          style: TextStyle(color: Config.errorColor),
                        )
                      : Container(),
                  SizedBox(height: 10),
                  RoundedButton(
                    text: I18n.of(context).ipse['submit'],
                    onPressed: _enableBtn ? _onSave : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
