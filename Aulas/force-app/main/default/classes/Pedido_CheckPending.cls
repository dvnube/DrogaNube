public with sharing class Pedido_CheckPending extends SObjectTrigger {
    public static Boolean disableTrigger = false;
    private static Boolean running = false;
    
    public override String getRunningClassName() {
        return Pedido_CheckPending.class.getName();
    }

    //right now, this class is being invoked only by BEFORE DELETE
    public override Boolean getIsToProcess(SObject oldRecord, SObject newRecord) {
        if (disableTrigger || disableTriggerSettings || running) {
            return false;
        }
        
        running = true;
        
        return true;
    }

    public override void executeTrigger(List<SObject> records) {
        List<Account> accs = new List<Account>();
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Account record : (List<Account>) records) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setPlainTextBody('A new order has been created for you!');
            email.setSubject('New order \\o/');
            email.setToAddresses(new List<String>{record.Email__c});
            emails.add(email);
            
            accs.add(new Account(Id = record.Id, NotifyNewOrder__c = false)); //uncheck the field
        }
        
        Messaging.sendEmail(emails);
        update accs;
    }
}