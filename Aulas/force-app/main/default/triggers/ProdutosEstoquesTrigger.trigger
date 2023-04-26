trigger ProdutosEstoquesTrigger on ProdutoEstoque__c (after update) {
    //pq não no after insert?
    //pq esse cenário nem deveria existir.
    //deveria ter um before insert validando quantidade > 5

    Set<Estoque__c> estoques = new Set<Estoque__c>();
    for (ProdutoEstoque__c record : Trigger.new) {
        ProdutoEstoque__c oldRecord = Trigger.oldMap.get(record.Id);
        if (record.Quantidade__c != oldRecord.Quantidade__c && record.Quantidade__c < 5) {
            Estoque__c est = new Estoque__c(Id = record.Estoque__c, Status__c = 'Alerta');
            estoques.add(est);
        }
    }
    update new List<Estoque__c>(estoques);
}