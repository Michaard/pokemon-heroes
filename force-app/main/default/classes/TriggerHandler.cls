public class TriggerHandler {
    public static void execute(ITrigger triggerHandler) {
        if (Trigger.isBefore) {
            triggerHandler.bulkBefore();

            if (Trigger.isInsert) {
                for (SObject so : Trigger.new) {
                    triggerHandler.beforeInsert(so);
                }
            } else if (Trigger.isUpdate) {
                for (SObject so : Trigger.old) {
                    triggerHandler.beforeUpdate(so, Trigger.newMap.get(so.Id));
                }
            }
//            else if (Trigger.isDelete) {
//                for (SObject so : Trigger.old) {
//                    triggerHandler.beforeDelete(so);
//                }
//            }
        } else {
            triggerHandler.bulkAfter();

            if (Trigger.isInsert) {
                for (SObject so : Trigger.new) {
                    triggerHandler.afterInsert(so);
                }
            }
            else if (Trigger.isUpdate) {
                for (SObject so : Trigger.old) {
                    triggerHandler.afterUpdate(so, Trigger.newMap.get(so.Id));
                }
            }
            else if (Trigger.isDelete) {
                for (SObject so : Trigger.old) {
                    triggerHandler.afterDelete(so);
                }
            }
//            else if (Trigger.isUndelete) {
//                for (SObject so : Trigger.new) {
//                    triggerHandler.afterUndelete(so);
//                }
//            }
        }

        triggerHandler.andFinally();
    }
}