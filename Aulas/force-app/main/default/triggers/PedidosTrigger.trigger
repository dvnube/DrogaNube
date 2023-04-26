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
}