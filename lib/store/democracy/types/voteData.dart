
class VoteData {
  String accountId;
  bool isDelegating;
  Map registry;
  String vote;
  String balance;

  VoteData();

  VoteData.fromJson(Map data) {
    this.accountId = data['accountId'];
    this.isDelegating = data['isDelegating'];
    this.registry = data['registry'];
    this.vote = data['vote'];
    this.balance = data['balance'].toString();
  }
}