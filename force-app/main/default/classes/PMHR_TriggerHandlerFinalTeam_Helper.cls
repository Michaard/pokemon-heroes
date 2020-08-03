public class PMHR_TriggerHandlerFinalTeam_Helper {
    public static Map<Id, Nuzlocke__c> getRelatedNuzlockes(List<Final_Team__c> finalTeams) {
        Set<Id> nuzlockeIds = (Set<Id>)PMHR_Utilities.fetchSObjectListToIdSet(finalTeams, Final_Team__c.Nuzlocke__c, false);
        return new Map<Id, Nuzlocke__c>(PMHR_NuzlockeQueryService.getNuzlockesWithFinalTeamsByIds(nuzlockeIds));
    }
}