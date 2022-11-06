public with sharing class SmartCouponCampaignMemberTriggerHandler {
    public static void handleAfterInsert(List<Web3CampaignMember__c> newMembers) {
        List<Lead> leadsToUpdate = new List<Lead>();
        for (Web3CampaignMember__c member : newMembers) {
            leadsToUpdate.add(new Lead(Id = member.Lead__c));
        }
        update leadsToUpdate;
    }
}