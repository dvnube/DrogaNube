trigger ProdutosPedidosTrigger on ProdutoPedido__c (before insert) {

    //usando fórmmula (StatusPedido__c)
    // 5 linhas - 1 for - 0 SOQL - 1 variável criada - 1 if
    for (ProdutoPedido__c record : Trigger.new) {
        if (record.StatusPedido__c == 'Concluído') {
            record.addError('Nope!');
        }
    }
    
    //sem fórmula, tem que buscar o Status lá no Pedido, pois , na trigger de ProdutoPedido__c , não temos acesso a "record.Pedido__r.Status__c"
    // 10 linhas - 2 for - 1 SOQL - 4 variáveis criadas - 1 if 
    Set<Id> pedidosIds = new Set<Id>();
    for (ProdutoPedido__c record : Trigger.new) {
        pedidosIds.add(record.Pedido__c);
    }
    Map<Id, Pedido__c> pedidosMap = new Map<Id, Pedido__c>([SELECT Id, Status__c FROM Pedido__c WHERE Id IN :pedidosIds]);
    for (ProdutoPedido__c record : Trigger.new) {
        if (pedidosMap.get(record.Pedido__c).Status__c == 'Concluído') {
            record.addError('Nope!');
        }
    }
}