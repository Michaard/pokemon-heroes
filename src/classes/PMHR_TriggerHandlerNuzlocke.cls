public class PMHR_TriggerHandlerNuzlocke implements ITrigger {
    private Map<Id, Nuzlocke__c> oldNuzlockesWithFinalTeams;

    public void bulkBefore() {
        if (Trigger.isUpdate) {
            oldNuzlockesWithFinalTeams = PMHR_TriggerHandlerNuzlocke_Helper.getNuzlockesWithFinalTeamsList(Trigger.newMap.keySet());
        }
    }

    public void bulkAfter() {
    }

    public void beforeInsert(SObject so) {
    }

    public void afterInsert(SObject so) {
    }

    public void beforeUpdate(SObject oldSo, SObject so) {
        Nuzlocke__c oldNuzlocke = (Nuzlocke__c) oldSo;
        Nuzlocke__c newNuzlocke = (Nuzlocke__c) so;

        if (oldNuzlockesWithFinalTeams != null && !oldNuzlockesWithFinalTeams.isEmpty()) {
            PMHR_TriggerHandlerNuzlocke_Helper.validateFinishingNuzlocke(oldNuzlockesWithFinalTeams.get(oldNuzlocke.Id), newNuzlocke);
        }
    }

    public void afterDelete(SObject so) {
    }

    public void andFinally() {
    }
}