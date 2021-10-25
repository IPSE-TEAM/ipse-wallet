class TreasuryBalance {
    String accountId;
		int accountNonce;
		String freeBalance;
		int frozenFee;
		int frozenMisc;
		int reservedBalance;
		String votingBalance;

    TreasuryBalance();

    TreasuryBalance.fromJson(Map data) {
      this.accountId = data['accountId'];
      this.accountNonce = data['accountNonce'];
      this.freeBalance = data['freeBalance'].toString();
      this.frozenFee = data['frozenFee'];
      this.frozenMisc = data['frozenMisc'];
      this.reservedBalance = data['reservedBalance'];
      this.votingBalance = data['votingBalance'].toString();
    }
}