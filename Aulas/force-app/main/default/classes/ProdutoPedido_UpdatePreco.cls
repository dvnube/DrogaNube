public with sharing class ProdutoPedido_UpdatePreco extends SObjectTrigger {
    public static Boolean disableTrigger = false;
    private static Boolean running = false;
    
    public override String getRunningClassName() {
        return ProdutoPedido_UpdatePreco.class.getName();
    }

    public override Boolean getIsToProcess(SObject oldRecord, SObject newRecord) {
        if (disableTrigger || disableTriggerSettings || running) {
            return false;
        }

        running = true;
        
        return true;
    }

    public override void executeTrigger(List<SObject> records) {
        //ao inserir um produto do pedido, 
        //buscar o preço de catálogo, e atualizar o campo Valor__c no objeto ProdutoPedido__c
    }
}