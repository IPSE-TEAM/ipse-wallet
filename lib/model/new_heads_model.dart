
//{"parentHash":"0xeeb870a1a614b5f846ea5871b363166da51eafbce609dd8fde220fedcaafe568","number":8358,"stateRoot":"0xcec0c4b5560a92e47ca6b44eaf42215dffdaa846789858bfb5cf68c7b68658ff","extrinsicsRoot":"0xeb28ea270bb654d1ef5a8be0ee785a1bcfc9e6592dfb244196b2fdabf0e1e9ef","digest":{"logs":[{"PreRuntime":[1161969986,"0x010000000031b3fd07000000003c8f406bd1116a4a08506222234f9a50ca007643fafa7560d58c56bd320c1e275b3c46c0295dcde8571c5496a3b964b7910cd60192549c0a9697387d933c780ae3c78f9a244edf4804870d6bddde94b9fe9acc1a45037f81515e5665c6b34a05"]},{"Seal":[1161969986,"0x4a854ee94dbfb8d0b952809364160e88cc9544cc6eb1bb745dcd36a9a9ff241c80510902fe411599a3c223114be9ffcf27a8e8f29370e7a47ee3e13a0ad43a8b"]}]}}
class NewHeadsModel {
  String parentHash;
  String hash;
  int number;
  NewHeadsModel({this.parentHash,this.hash,this.number});
  NewHeadsModel.fromJson(json):
  parentHash=json['parentHash'],
  hash=json['hash'],
  number=json['number'];

}