public with sharing class Pedido_NotifyCustomer extends SObjectTrigger {
    public static Boolean disableTrigger = false;
    private static Boolean running = false;
    
    public override String getRunningClassName() {
        return Pedido_NotifyCustomer.class.getName();
    }

    //right now, this class is being invoked only by AFTER INSERT
    public override Boolean getIsToProcess(SObject oldRecord, SObject newRecord) {
        if (disableTrigger || disableTriggerSettings || running) {
            return false;
        }
        
        running = true;
        
        return true;
    }

    public override void executeTrigger(List<SObject> records) {
        List<Account> accs = new List<Account>();
        
        for (Account record : (List<Account>) records) {
            Messaging.SingleEmailMessage sem = new Messaging.SingleEmailMessage();
            sem.setPlainTextBody('bla');
            sem.setToAddresses(record.Email__c);


            accs.add(new Account(Id = record.Id, NotifyNewOrder__c = true));
        }

        update accs;
    }
}