public with sharing class SmartCouponRewards {
  public class rewardRequest  {
    public String imageUrl;
    public String type;
    public String initialSupply;
    public String symbol;
    public String name;
  }

  public class rewardSubmission  {
    public String imageUrl;
    public String amount;
    public String contractAddress;
    public String walletAddress;
    public String symbol;
    public String name;
  }

  @future(callout=true)
  public static void createReward(Id rewardId) {
    Web3CampaignReward__c reward = [SELECT Id, Image_Url__c, Type__c, Supply__c, Symbol__c, Contract_Address__c, Name FROM Web3CampaignReward__c WHERE ID =:rewardId LIMIT 1];
    HttpRequest req=new HttpRequest();
    req.setEndpoint('https://x3ywvb7ud3ml2taxw3djsj6vwq0yeeyl.lambda-url.us-west-2.on.aws/reward/'+reward.Type__c);
    req.setMethod('POST');
    req.setTimeout(120000);
    rewardRequest rewardReq = new rewardRequest();
    rewardReq.imageUrl = reward.Image_Url__c;
    rewardReq.type = reward.Type__c;
    rewardReq.initialSupply = String.valueOf(reward.Supply__c);
    rewardReq.symbol = reward.Symbol__c;
    rewardReq.name = reward.Name;
    
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');

    req.setBody(JSON.serialize(rewardReq));

    Http http=new Http();
    System.debug('Create Reward Request :- ' + req);
    HttpResponse res=http.send(req);
    if(res.getStatusCode()==200) {
      System.debug('BE Response :- ' + res.getBody());

      reward.Contract_Address__c = res.getBody();
      update reward;
    }
  }

  @future(callout=true)
  public static void submitReward(Set<Id> dataList) {
    List<Id> idList = new List<Id>(dataList);
    Id rewardId = idList.get(0);
    Id campaignMember = idList.get(1);
    Id goalId = idList.get(2);
    Web3CampaignMember__c member = [SELECT ID, Web3_Address__r.Address__c FROM Web3CampaignMember__c WHERE Id =:campaignMember LIMIT 1];
    Web3CampaignReward__c reward = [SELECT Id, Image_Url__c, Type__c, Supply__c, Symbol__c, Contract_Address__c, Name FROM Web3CampaignReward__c WHERE ID =:rewardId LIMIT 1];
    HttpRequest req=new HttpRequest();
    req.setEndpoint('https://x3ywvb7ud3ml2taxw3djsj6vwq0yeeyl.lambda-url.us-west-2.on.aws/reward/'+reward.Type__c);
    req.setMethod('PUT');
    req.setTimeout(120000);
    rewardSubmission rewardReq = new rewardSubmission();
    rewardReq.imageUrl = reward.Image_Url__c;
    rewardReq.walletAddress = member.Web3_Address__r.Address__c;
    rewardReq.contractAddress = reward.Contract_Address__c;
    rewardReq.amount = String.valueOf(reward.Supply__c);
    rewardReq.symbol = reward.Symbol__c;
    rewardReq.name = reward.Name;
    
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');

    req.setBody(JSON.serialize(rewardReq));

    Http http=new Http();
    System.debug('Create Reward Request :- ' + req);
    HttpResponse res=http.send(req);
    if(res.getStatusCode()==200) {
      System.debug('BE Response :- ' + res.getBody());
      if (res.getBody() == 'success') {
        Web3CampaignResult__c result = new Web3CampaignResult__c(
          Web3_Campaign_Member__c=campaignMember,
          Web3_Campaign_Goal__c=goalId,
          Web3_Campaign_Reward__c=rewardId
        );

        insert result;
      }
      
    }
  }
}