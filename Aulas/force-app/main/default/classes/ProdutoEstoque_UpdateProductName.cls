public with sharing class ProdutoEstoque_UpdateProductName extends SObjectTrigger {
    public static Boolean disableTrigger = false;
    private static Boolean running = false;

    public override String getRunningClassName() {
        return ProdutoEstoque_UpdateProductName.class.getName();
    }

    //right now, this class is being invoked only by BEFORE INSERT
    public override Boolean getIsToProcess(SObject oldRecord, SObject newRecord) {
        if (disableTrigger || disableTriggerSettings || running) {
            return false;
        }

        running = true;

        return true;
    }

    public override void executeTrigger(List<SObject> records) {
        Map<Id, Product2> products = new Map<Id, Product2>(
            [SELECT Id, Name FROM Product2 WHERE Id IN :Utils.buildMapByIdField(records, ProdutoEstoque__c.Produto__c).keySet()]
        );

        executeTrigger(records, products);
    }
    
    private void executeTrigger(List<SObject> records, Map<Id, Product2> products) {
        for (ProdutoEstoque__c record : (List<ProdutoEstoque__c>) records) {
            record.ProductName__c = products.get(record.Produto__c).Name;
        }
    }
}