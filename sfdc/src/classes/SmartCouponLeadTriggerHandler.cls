public with sharing class SmartCouponLeadTriggerHandler {
    public static void handleAfterInsert(List<Lead> newLeads) {
      SmartCouponLeadTriggerHandler.evaluateLeads(newLeads);
    }

    public static void handleAfterUpdate(List<Lead> newLeads) {
      SmartCouponLeadTriggerHandler.evaluateLeads(newLeads);
    }

    public static void evaluateLeads(List<Lead> newLeads) {
      Map<Id, Lead> leadMap = new Map<Id, Lead>();
      Set<String> campaignMemberCompositeId = new Set<String>();
      List<Web3CamapignGoal__c> goals = [SELECT Id, Web3_Campaign__c, Amount__c, Web3_Campaign_Reward__c, Type__c FROM Web3CamapignGoal__c WHERE Web3_Campaign__r.Status__c = 'Active'];
      for (Lead l : newLeads) {
        leadMap.put(l.Id, l);
        for (Web3CamapignGoal__c goal : goals) {
          campaignMemberCompositeId.add(goal.Web3_Campaign__c+String.valueOf(l.Id));
        }
      }
      List<Web3CampaignMember__c> members = [SELECT Id, Web3_Campaign__c, Web3_Address__c, Lead__c, (SELECT ID, Web3_Campaign_Goal__c	FROM Web3_Campaign_Results__r) FROM Web3CampaignMember__c WHERE CompositeId__c IN :campaignMemberCompositeId ];
      for (Web3CampaignMember__c member : members) {
        for (Web3CamapignGoal__c goal : goals) {
          if (member.Web3_Campaign__c == goal.Web3_Campaign__c) {
            Lead l = leadMap.get(member.Lead__c);
            Boolean existing = false;
            for (Web3CampaignResult__c result : member.Web3_Campaign_Results__r) {
              if (result.Web3_Campaign_Goal__c == goal.Id) {
                existing = true;
              }
            }
            if (goal.Type__c == 'Linking' && !existing) {
              Set<Id> dataList = new Set<Id>();
              dataList.add(goal.Web3_Campaign_Reward__c);
              dataList.add(member.Id);
              dataList.add(goal.Id);
              SmartCouponRewards.submitReward(dataList);
            } else if (
              goal.Type__c == 'Confirmation' && !existing && 
              (
                l.World_Coin__c != ''
              )
            ) {
              Set<Id> dataList = new Set<Id>();
              dataList.add(goal.Web3_Campaign_Reward__c);
              dataList.add(member.Id);
              dataList.add(goal.Id);
              SmartCouponRewards.submitReward(dataList);
            } else if (
              goal.Type__c == 'Enrichment' && !existing && 
              (
                l.Discord__c != '' || 
                l.Twitter__c	!= ''
              )
            ) {
              Set<Id> dataList = new Set<Id>();
              dataList.add(goal.Web3_Campaign_Reward__c);
              dataList.add(member.Id);
              dataList.add(goal.Id);
              SmartCouponRewards.submitReward(dataList);
            }
          }
        }
      }

      
      
    }
}