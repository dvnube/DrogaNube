trigger PedidosTrigger on Pedido__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            PedidosTriggerHandler.beforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            PedidosTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    } else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            PedidosTriggerHandler.afterInsert(Trigger.new, Trigger.oldMap);
        } else if (Trigger.isUpdate) {
            PedidosTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }


    List<Pedido__c> novosRegistros = Trigger.new;
    Map<Id, Pedido__c> velhosRegistrosMap = Trigger.oldMap;

    Boolean isBefore = Trigger.isBefore;
    Boolean isInsert = Trigger.isInsert;
    Boolean isUpdate = Trigger.isUpdate;

    if (isBefore && isInsert) {
        System.debug('to no contexto before insert:');
        System.debug('novosregistros: ' + novosRegistros);
        System.debug('velhosRegistrosMap: ' + velhosRegistrosMap);
    } else if (isBefore && isUpdate) {
        for (Pedido__c novoRegistro : novosRegistros) {
            Pedido__c velhoRegistro = velhosRegistrosMap.get(novosRegistro.Id);
            if (novosRegistro.Status__c != velhosRegistro.Status__c) {
                //VC SABE QUE O STATUS FOI ALTERADO
            }
        }
        System.debug('to no contexto update');
        System.debug('novosregistros: ' + novosRegistros);
        System.debug('velhosRegistrosMap: ' + velhosRegistrosMap);
    }
    

    // for (Pedido__c pedido : Trigger.new) {
    //     velhosRegistrosMap.get(pedido.Id)
    //     if (pedido.Status__c == 'Finalizado') {
    //         pedido.DataFinalizado__c = Datetime.now();
    //     }
    // }
}