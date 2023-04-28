public with sharing class ProdutoEstoque_CheckQuantity extends SObjectTrigger {
    public static Boolean disableTrigger = false;
    private static Boolean running = false;
    
    public override String getRunningClassName() {
        return ProdutoEstoque_CheckQuantity.class.getName();
    }

    //right now, this class is being invoked only by BEFORE INSERT
    public override Boolean getIsToProcess(SObject oldRecord, SObject newRecord) {
        if (disableTrigger || disableTriggerSettings || running) {
            return false;
        }
        
        running = true;
        
        Decimal quantity = (Decimal) newRecord.get('Quantidade__c');
        
        return quantity == null || quantity <= 0;
    }

    public override void executeTrigger(List<SObject> records) {
        for (ProdutoEstoque__c record : (List<ProdutoEstoque__c>) records) {
            executeTrigger(record);
        }
    }

    private void executeTrigger(ProdutoEstoque__c record) {
        if (record.Quantidade__c == null) {
            record.Quantidade__c.addError('Required field');
        } else if (record.Quantidade__c <= 0) {
            record.Quantidade__c.addError('It must be greater than 0');
        }
    }
}