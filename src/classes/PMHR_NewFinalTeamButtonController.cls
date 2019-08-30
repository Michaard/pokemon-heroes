public class PMHR_NewFinalTeamButtonController {

    @AuraEnabled
    public static void createFinalTeam(String nuzlockeId, String finalTeamName) {
        try {
            Final_Team__c finalTeam = new Final_Team__c(Nuzlocke__c = nuzlockeId, Name = finalTeamName);
            insert finalTeam;
        } catch (DmlException ex) {
            throw new AuraHandledException(ex.getDmlMessage(0));
        }
    }
}