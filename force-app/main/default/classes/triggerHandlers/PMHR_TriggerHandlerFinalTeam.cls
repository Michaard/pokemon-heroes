public without sharing class PMHR_TriggerHandlerFinalTeam implements ITrigger {
    private Map<Id, PMHR_Nuzlocke__c> relatedNuzlockes;
    private List<PMHR_FinalTeam__c> finalTeams;

    public void bulkBefore() {}

    public void bulkAfter() {
        if (Trigger.isInsert) {
            finalTeams = Trigger.new;
        } else if (Trigger.isDelete) {
            finalTeams = Trigger.old;
        }

        if (finalTeams != null && !finalTeams.isEmpty()) {
            relatedNuzlockes = PMHR_TriggerHandlerFinalTeam_Helper.getRelatedNuzlockes(finalTeams);
        }
    }

    public void beforeInsert(SObject so) {}

    public void afterInsert(SObject so) {
        PMHR_FinalTeam__c finalTeam = (PMHR_FinalTeam__c) so;

        if (relatedNuzlockes != null && !relatedNuzlockes.isEmpty()) {
            PMHR_TriggerHandlerNuzlocke_Helper.markNuzlockeAsFinishedWithSuccess(relatedNuzlockes.get(finalTeam.Nuzlocke__c));
        }
    }

    public void beforeUpdate(SObject oldSo, SObject so) {}

    public void afterUpdate(SObject oldSo, SObject so) {}

    public void afterDelete(SObject so) {
        PMHR_FinalTeam__c finalTeam = (PMHR_FinalTeam__c) so;

        if (relatedNuzlockes != null && !relatedNuzlockes.isEmpty()) {
            PMHR_TriggerHandlerNuzlocke_Helper.markNuzlockeAsNotFinished(relatedNuzlockes.get(finalTeam.Nuzlocke__c));
        }
    }

    public void andFinally() {
        if (Trigger.isAfter) {
            if (Trigger.isInsert || Trigger.isDelete) {
                if (relatedNuzlockes != null && !relatedNuzlockes.isEmpty()) {
                    update relatedNuzlockes.values();
                }
            }
        }
    }
}