public without sharing class Twitter {
    
  // Class to store twitter users information
  public class users {
    public String id;	
    public String id_str;	
    public String name;	//Saurabh
    public String screen_name;	
    public String location;	
    public String description;	
    public Integer followers_count;	//28
    public Integer friends_count;	//189
    public Integer listed_count;	//0
    public String profile_image_url;	
    public String profile_image_url_https;	
    
    public List<users> parse(String json) {
        return (List<users>) System.JSON.deserialize(json, List<users>.class);
    }
  }

  // Method to get twitter user's information and desearlize into above class

  public users getTwitterInfo(string twitterHandle) {
    HttpRequest req=new HttpRequest();
    req.setEndpoint('https://api.twitter.com/2/users/by/username/'+twitterHandle);
    req.setMethod('GET');
    String bearerAuthorizationHeader='Bearer '  + System.Label.Twitter_Bearer_Token; // Insert bearer token
    req.setHeader('Authorization',bearerAuthorizationHeader);
    
    Http http=new Http();
    System.debug('Twitter Request :- ' + req);
    HttpResponse res=http.send(req);
    if(res.getStatusCode()!=200)
    {
      System.debug('Twitter Response :- ' + res.getBody());
      return null;
    }
    String sBody=res.getBody();
    System.debug('Twitter sBody :- ' + sBody);
    
    Map <String, users> TwitterResultsMap = new Map<String, users> ();
    users tObj=new users();
    List<users> tresult=tObj.parse(sBody);
    
    for(users t: tresult) {
      TwitterResultsMap.put(t.screen_name,t);
    }
    System.debug('TwitterResultsMap :- ' + TwitterResultsMap);
    return TwitterResultsMap.get(twitterHandle);        
  }

}
