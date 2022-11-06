public class SmartCouponBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Address__c FROM Web3Address__c');
    }
    public void execute(Database.BatchableContext bc, List<Web3Address__c> web3Addresses) {
        List<Web3TransactionHistory__c> transactions = new List<Web3TransactionHistory__c>();
        List<Web3TokenBalance__c> tokenBalances = new List<Web3TokenBalance__c>();
        for (Web3Address__c web3Address : web3Addresses) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String endPoint = 'https://api.covalenthq.com/v1/{0}/address/{1}/transactions_v2/?&key={2}';
            List<Object> parameters = new List<Object>{ 1, web3Address.Address__c, 'ckey_643acdb391d34c19a4241f60207' };
            request.setEndpoint(String.format(endPoint, parameters));
            request.setMethod('GET');
            request.setTimeout(120000);
            // GET TRANSACTION HISTORY
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                // Deserialize the JSON string into collections of primitive data types.
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Object resultsData = (Object) results.get('data');
                Map<String, Object> resultsDataMap = (Map<String, Object>) resultsData;
                List<Object> resultsItems = (List<Object>) resultsDataMap.get('items');
                Web3Address__c addressReference = new Web3Address__c(Address__c = (String) resultsDataMap.get('address'));
      
                for (Object resultsItem : resultsItems) {
                    Map<String, Object> resultsItemMap = (Map<String, Object>) resultsItem;
                    Web3TransactionHistory__c resultsTransaction = new Web3TransactionHistory__c(
                        Block_Number__c = (Decimal) resultsItemMap.get('block_height'),
                        From_Address__c = (String) resultsItemMap.get('from_address'),
                        Success__c = (Boolean) resultsItemMap.get('successful'),
                        To_Address__c = (String) resultsItemMap.get('to_address'),
                        Transaction_Hash__c = (String) resultsItemMap.get('tx_hash'),
                        Web3_Address__r = addressReference,
                        Value__c = (Long) long.valueOf((String) resultsItemMap.get('value')),
                        Composite_Id__c = (String) resultsDataMap.get('address') + (String) resultsItemMap.get('tx_hash')
                    );
                    transactions.add(resultsTransaction);
                }
            } else {
                System.debug('Status: ' + response.getStatusCode() + ', ' + response.getStatus());
            }

            // GET TOKEN BALANCES
            endPoint = 'https://api.covalenthq.com/v1/{0}/address/{1}/balances_v2/?&key={2}';
            request.setEndpoint(String.format(endPoint, parameters));
            response = http.send(request);
            if (response.getStatusCode() == 200) {
                // Deserialize the JSON string into collections of primitive data types.
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Object resultsData = (Object) results.get('data');
                Map<String, Object> resultsDataMap = (Map<String, Object>) resultsData;
                List<Object> resultsItems = (List<Object>) resultsDataMap.get('items');
                for (Object resultsItem : resultsItems) {
                }
                for (Object resultsItem : resultsItems) {
                    Map<String, Object> resultsItemMap = (Map<String, Object>) resultsItem;
                    Web3Address__c addressReference = new Web3Address__c(Address__c = (String) resultsDataMap.get('address'));
                    Web3TokenBalance__c resultsTokenBalance = new Web3TokenBalance__c(
                        Balance__c = (Long) Long.valueOf((String) resultsItemMap.get('balance')),
                        Contract_Address__c = (String) resultsItemMap.get('contract_address'),
                        Contract_Logo_Url__c = (String) resultsItemMap.get('logo_url'),
                        Contract_Name__c = (String) resultsItemMap.get('contract_name'),
                        Native_Token__c = (Boolean) resultsItemMap.get('native_token'),
                        Symbol__c = (String) resultsItemMap.get('contract_ticker_symbol'),
                        Web3_Address__r = addressReference,
                        Name = (String) resultsItemMap.get('contract_name'),
                        CompositeId__c = (String) resultsDataMap.get('address') + (String) resultsItemMap.get('contract_address')
                    );
                    tokenBalances.add(resultsTokenBalance);
                }
            } else {
                System.debug('Status: ' + response.getStatusCode() + ', ' + response.getStatus());
            }
        }
        upsert transactions Composite_Id__c;
        upsert tokenBalances CompositeId__c;
    }
    public void finish(Database.BatchableContext bc) {
        // execute any post-processing operations
    }
}

/**
 * get transaction info from covalenthq
 * get token balances from covalenthq upsert by wallet address and contract address
 */