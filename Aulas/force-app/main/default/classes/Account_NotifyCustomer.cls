public with sharing class Account_NotifyCustomer extends SObjectTrigger {
    public static Boolean disableTrigger = false;
    private static Boolean running = false;
    
    public override String getRunningClassName() {
        return Account_NotifyCustomer.class.getName();
    }

    //right now, this class is being invoked only by AFTER UPDATE
    public override Boolean getIsToProcess(SObject oldRecord, SObject newRecord) {
        if (disableTrigger || disableTriggerSettings || running) {
            return false;
        }
        
        running = true;
        Boolean oldNotify = (Boolean) oldRecord.get('NotifyNewOrder__c');
        Boolean newNotify = (Boolean) newRecord.get('NotifyNewOrder__c');
        return !oldNotify && newNotify;
    }

    public override void executeTrigger(List<SObject> records) {
        List<Account> accs = new List<Account>();
        for (Account record : (List<Account>) records) {
            

            accs.add(new Account(Id = record.Id, NotifyNewOrder__c = false)); //uncheck the field
        }

        update accs;
    }
}