import 'package:ipsewallet/store/democracy/types/imageData.dart';

class ProposalData {
  int balance;
  List<dynamic> seconds;
  ImageData image;
  String imageHash;
  int index;
  String proposer;
  Map detail;

  ProposalData();

  ProposalData.fromJson(Map data) {
    this.balance = data['balance'];
    this.seconds = data['seconds'];

    ImageData img = ImageData.fromJson(data['image']);
    this.image = img;
    
    this.imageHash = data['imageHash'];
    this.index = data['index'];
    this.proposer = data['proposer'];
    this.detail = data['detail'];
  }

}