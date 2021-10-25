class StakingListItemModel {
  String gid;
  String name;
  String account;
  num supportKSM;
  int votersNumber;

  StakingListItemModel();

  StakingListItemModel.fromJson(json) {
    this.gid = json['gid'];
    this.name = json['name'];
    this.account = json['account'];
    this.supportKSM = json['support_ksm'];
    this.votersNumber = json['voters_number'];
  } 
}

class StakingCandidateModel extends StakingListItemModel {
  bool isChecked;

  StakingCandidateModel();

  StakingCandidateModel.fromJson(json) {
    this.gid = json['gid'];
    this.name = json['name'];
    this.account = json['account'];
    this.supportKSM = json['support_ksm'];
    this.votersNumber = json['voters_number'];
    this.isChecked = json['is_checked'] ?? false;
  }  
}

class StakingVerifierModel extends StakingListItemModel {
  StakingVerifierModel();

  StakingVerifierModel.fromJson(json) {
    this.gid = json['gid'];
    this.name = json['name'];
    this.account = json['account'];
    this.supportKSM = json['support_ksm'];
    this.votersNumber = json['voters_number'];
  }  
}