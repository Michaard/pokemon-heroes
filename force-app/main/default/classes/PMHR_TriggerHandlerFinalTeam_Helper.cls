public class PMHR_TriggerHandlerFinalTeam_Helper {
    public static Map<Id, PMHR_Nuzlocke__c> getRelatedNuzlockes(List<PMHR_FinalTeam__c> finalTeams) {
        Set<Id> nuzlockeIds = (Set<Id>)PMHR_Utilities.fetchSObjectListToIdSet(finalTeams, PMHR_FinalTeam__c.Nuzlocke__c, false);
        return new Map<Id, PMHR_Nuzlocke__c>(PMHR_NuzlockeQueryService.getNuzlockesWithFinalTeamsByIds(nuzlockeIds));
    }
}