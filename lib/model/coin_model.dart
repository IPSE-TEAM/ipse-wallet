class CoinModel {
  String name;
  String symbol;
  double price;
  CoinModel({this.name,this.symbol,this.price});
  CoinModel.fromJson(json):
  name=json['name'],
  symbol=json['symbol'],
  price=json['price'];

}
// List<CoinModel> coinList