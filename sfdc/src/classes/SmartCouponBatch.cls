public class SmartCouponBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Address__c FROM Web3Address__c');
    }
    public void execute(Database.BatchableContext bc, List<Web3Address__c> web3Addresses) {
        for (Web3Address__c web3Address : web3Addresses) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String endPoint = 'https://api.covalenthq.com/v1/{0}/address/{1}/transactions_v2/?&key={2}';
            List<Object> parameters = new List<Object>{ 1, web3Address.Address__c, 'ckey_643acdb391d34c19a4241f60207' };
            request.setEndpoint(String.format(endPoint, parameters));
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            // If the request is successful, parse the JSON response.
            if (response.getStatusCode() == 200) {
                // Deserialize the JSON string into collections of primitive data types.
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                System.debug(results);
            } else {
                System.debug('Status: ' + response.getStatusCode() + ', ' + response.getStatus());
            }
        }
    }
    public void finish(Database.BatchableContext bc) {
        // execute any post-processing operations
    }
}

/**
 * get transaction info from covalenthq
 * get token balances from covalenthq upsert by wallet address and contract address
 */