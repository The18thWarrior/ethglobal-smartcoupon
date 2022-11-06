global class SmartCouponBatchScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        SmartCouponBatch b = new SmartCouponBatch();
        database.executebatch(b, 10);
    }
}