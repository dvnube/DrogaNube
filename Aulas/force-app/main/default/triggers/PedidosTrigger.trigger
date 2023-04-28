trigger PedidosTrigger on Pedido__c(before insert, after insert, before update, after update, before delete, after delete) {
    new TriggerHandler(Pedido__c.SObjectType).manage();
}