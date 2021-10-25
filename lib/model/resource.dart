class Resource {
   String address;
   String addtime;
   String category;
   String describe;
   String extra;
   String label;
   String pcid;
   int minetype;
   int size;
   int status;
   String videoformat;
   String hash;
   
   Resource({this.address,
    this.addtime,
    this.category,
    this.describe,
    this.extra,
    this.label,
    this.pcid,
    this.videoformat,
    this.hash,
    this.minetype,
    this.size,
    this.status,
  });

  Resource.fromJson(json):
    address=json['address'],
    addtime=json['addtime'],
    category=json['category'],
    describe=json['describe'],
    extra=json['extra'],
    label=json['label'],
    pcid=json['pcid'],
    videoformat=json['videoformat'],
    hash=json['hash'],
    minetype=json['minetype'],
    size= (json['size']),
    status=json['status'];
}