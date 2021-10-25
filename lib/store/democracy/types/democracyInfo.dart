class DemocracyInfo {
  int publicPropCount;
  int referendumCount;
  int launchPeriod;

  DemocracyInfo();

  DemocracyInfo.fromJson(Map data) {
    this.publicPropCount = data['publicPropCount'];
    this.referendumCount = data['referendumCount'];
    this.launchPeriod = data['launchPeriod'];
  }
}