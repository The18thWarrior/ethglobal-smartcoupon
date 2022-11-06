trigger SmartCouponReward on Web3CampaignReward__c (after insert, after update) {
    for (Web3CampaignReward__c reward : Trigger.new) {
    if (String.isBlank(reward.Contract_Address__c)) {
        SmartCouponRewards.createReward(reward.Id);
      }
    }
}