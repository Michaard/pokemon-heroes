public class PMHR_TriggerHandlerNuzlocke_Helper {
    public static Map<Id, Nuzlocke__c> getNuzlockesWithFinalTeamsList(Set<Id> nuzlockesIds) {
        return new Map<Id, Nuzlocke__c>(PMHR_NuzlockeQueryService.getNuzlockesWithFinalTeamsByIds(nuzlockesIds));
    }

    public static void validateFinishingNuzlocke(Nuzlocke__c oldVersion, Nuzlocke__c newVersion) {
        if (oldVersion.End_Status__c != newVersion.End_Status__c
                && newVersion.End_Status__c == PMHR_NuzlockeBuilder.END_STATUS_SUCCESS
                && oldVersion.Final_Teams__r.isEmpty()) {
            newVersion.addError(Label.Toast_Error_Nuzlocke_Finished_With_Success_Without_Final_Team);
        }
    }

    public static void markNuzlockeAsFinishedWithSuccess(Nuzlocke__c nuzlocke) {
        if (!nuzlocke.Multiple_Elite_Four_Fights__c) {
            setNuzlockeEndData(nuzlocke, Date.today(), PMHR_NuzlockeBuilder.END_STATUS_SUCCESS);
        }
    }

    public static void markNuzlockeAsNotFinished(Nuzlocke__c nuzlocke) {
        if (nuzlocke.Final_Teams__r.isEmpty() && nuzlocke.Is_Finished__c) {
            setNuzlockeEndData(nuzlocke, null, null);
        }
    }

    private static void setNuzlockeEndData(Nuzlocke__c nuzlocke, Date endDate, String endStatus) {
        nuzlocke = new PMHR_NuzlockeBuilder(nuzlocke)
                .setEndDate(endDate)
                .setEndStatus(endStatus)
                .build();
    }
}