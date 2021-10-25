class ImageData {
  int at;
  int balance;
  Map proposal;
  String proposer;

  ImageData();

  ImageData.fromJson(Map data) {
    this.at = data['at'];
    this.balance = data['balance'];
    this.proposal = data['proposal'];
    this.proposer = data['proposer'];
  }
}