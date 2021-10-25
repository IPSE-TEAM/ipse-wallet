class ElectionData {
  String address;
  String accountName;
  String balance;
  List<dynamic> voters;

  ElectionData();

  ElectionData.fromJson(Map data) {
    this.address = data['address'];
    this.accountName = data['accountName'];
    this.balance = data['balance'].toString();
    this.voters = data['voters'];
  }
}