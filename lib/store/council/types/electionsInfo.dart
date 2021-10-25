class ElectionsInfo extends _ElectionsInfo {
  static ElectionsInfo fromJson(Map<String, dynamic> json) {
    ElectionsInfo data = ElectionsInfo()
      ..candidacyBond = json['candidacyBond']
      ..candidateCount = json['candidateCount']
      ..desiredSeats = json['desiredSeats']
      ..termDuration = json['termDuration']
      ..votingBond = json['votingBond'];
    return data;
  }

  Map toJson() {
    Map res;
    res['candidacyBond'] = this.candidacyBond;
    res['candidateCount'] = this.candidacyBond;
    res['desiredSeats'] = this.candidacyBond;
    res['termDuration'] = this.candidacyBond;
    res['votingBond'] = this.candidacyBond;
    return res;
  }
}

abstract class _ElectionsInfo {
  int candidacyBond;
  int candidateCount;
  int desiredSeats;
  int termDuration;
  int votingBond;
}