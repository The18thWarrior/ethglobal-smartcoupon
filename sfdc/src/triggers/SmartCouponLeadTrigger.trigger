trigger SmartCouponLeadTrigger on Lead(after insert, after update) {
    if (Trigger.isInsert) {
        SmartCouponLeadTriggerHandler.handleAfterInsert(Trigger.new);
    } else if (Trigger.isUpdate) {
        SmartCouponLeadTriggerHandler.handleAfterUpdate(Trigger.new);
    }
}