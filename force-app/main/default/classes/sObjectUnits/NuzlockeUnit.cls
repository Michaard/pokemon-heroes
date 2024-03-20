public with sharing class NuzlockeUnit {
    public enum Status {
        InProgress, Success, Failed, Cancelled
    }

    public static Boolean isStatusEqual(String statusString, NuzlockeUnit.Status status) {
        return statusString == status.name();
    }

    public static void setNuzlockeEndData(PMHR_Nuzlocke__c nuzlocke, Date endDate, NuzlockeUnit.Status status) {
        nuzlocke = new PMHR_NuzlockeBuilder(nuzlocke)
                .setEndDate(endDate)
                .setEndStatus(status)
                .build();
    }
}