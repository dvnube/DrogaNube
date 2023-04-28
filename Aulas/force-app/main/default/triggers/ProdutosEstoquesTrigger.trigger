trigger ProdutosEstoquesTrigger on ProdutoEstoque__c(before insert, after insert, before update, after update, before delete, after delete) {
    new TriggerHandler(ProdutoEstoque__c.SObjectType).manage();
}