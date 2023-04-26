public with sharing class ProdutoPedido_ValidatePedidoCompleto extends SObjectTrigger {
    public static Boolean disableTrigger = false;
    private static Boolean running = false;
    
    public override String getRunningClassName() {
        return ProdutoPedido_ValidatePedidoCompleto.class.getName();
    }

    public override Boolean getIsToProcess(SObject oldRecord, SObject newRecord) {
        if (disableTrigger || disableTriggerSettings || running) {
            return false;
        }

        running = true;
        
        Decimal quantidade = (Decimal) newRecord.get(ProdutoPedido__c.Quantidade__c);
        
        return quantidade > 3;
    }

    public override void executeTrigger(List<SObject> records) {
        //lógica de validação pedido completo
    }
}