trigger ProdutosPedidosTrigger on ProdutoPedido__c(before insert, after insert, before update, after update, before delete, after delete) {
    new TriggerHandler(ProdutoPedido__c.SObjectType).manage();
}