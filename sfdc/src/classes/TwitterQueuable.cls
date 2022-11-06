public with sharing class TwitterQueuable implements Queueable {
  private List<Lead> leads;
  public TwitterQueuable(List<Lead> records) {
      this.leads = records;
  }

  public void execute(QueueableContext context) { 
      
  }

}
