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
        Map<Id, Pedido__c> pedidosMap = new Map<Id, Pedido__c>([SELECT Id, (SELECT Id FROM Produtos__r WHERE Pendencia__c = TRUE) FROM Pedido__c WHERE Id IN :records]);
        
        for (Pedido__c record : (List<Pedido__c>) records) {
            if (!pedidosMap.get(record.Id).Produtos__r.isEmpty()) {
                record.addError('Nop.');
            }
        }
    }
}
