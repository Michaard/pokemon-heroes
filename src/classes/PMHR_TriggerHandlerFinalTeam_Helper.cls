public class PMHR_TriggerHandlerFinalTeam_Helper {
    public static Map<Id, Nuzlocke__c> getRelatedNuzlockes(List<Final_Team__c> finalTeams) {
        Set<Id> nuzlockeIds = new Set<Id>();

        for (Final_Team__c finalTeam : finalTeams) {
            nuzlockeIds.add(finalTeam.Nuzlocke__c);
        }

        return new Map<Id, Nuzlocke__c>([SELECT Id, Is_Finished__c, Multiple_Elite_Four_Fights__c, (SELECT Id FROM Final_Teams__r) FROM Nuzlocke__c WHERE Id IN :nuzlockeIds]);
    }
}