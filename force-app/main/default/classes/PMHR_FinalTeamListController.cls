public class PMHR_FinalTeamListController {

    @AuraEnabled
    public static List<PMHR_FinalTeamListControllerHelper.FinalTeam> getFinalTeamInfo(Id nuzlockeId) {
        List<Final_Team__c> finalTeams = PMHR_FinalTeamQueryService.getFinalTeamsWithMembersByNuzlockeId(nuzlockeId);
        return PMHR_FinalTeamListControllerHelper.getInstance().parseFinalTeams(finalTeams);
    }
}