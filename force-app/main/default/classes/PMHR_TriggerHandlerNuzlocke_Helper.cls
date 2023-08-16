public class PMHR_TriggerHandlerNuzlocke_Helper {
    public static Map<Id, PMHR_Nuzlocke__c> getNuzlockesWithFinalTeamsList(Set<Id> nuzlockesIds) {
        return new Map<Id, PMHR_Nuzlocke__c>(PMHR_NuzlockeQueryService.getNuzlockesWithFinalTeamsByIds(nuzlockesIds));
    }

    public static void validateFinishingNuzlocke(PMHR_Nuzlocke__c oldVersion, PMHR_Nuzlocke__c newVersion) {
        if (oldVersion.Status__c != newVersion.Status__c
                && newVersion.Status__c == PMHR_NuzlockeBuilder.END_STATUS_SUCCESS
                && oldVersion.FinalTeams__r.isEmpty()) {
            newVersion.addError(Label.Toast_Error_Nuzlocke_Finished_With_Success_Without_Final_Team);
        }
    }

    public static void markNuzlockeAsFinishedWithSuccess(PMHR_Nuzlocke__c nuzlocke) {
        if (!nuzlocke.Multiple_Elite_Four_Fights__c) {
            setNuzlockeEndData(nuzlocke, Date.today(), PMHR_NuzlockeBuilder.END_STATUS_SUCCESS);
        }
    }

    public static void markNuzlockeAsNotFinished(PMHR_Nuzlocke__c nuzlocke) {
        if (nuzlocke.FinalTeams__r.isEmpty() && nuzlocke.IsFinished__c) {
            setNuzlockeEndData(nuzlocke, null, null);
        }
    }

    private static void setNuzlockeEndData(PMHR_Nuzlocke__c nuzlocke, Date endDate, String endStatus) {
        nuzlocke = new PMHR_NuzlockeBuilder(nuzlocke)
                .setEndDate(endDate)
                .setEndStatus(endStatus)
                .build();
    }
}