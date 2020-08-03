public class PMHR_NewFinalTeamButtonController {

    @AuraEnabled
    public static void createFinalTeam(String nuzlockeId, String finalTeamName) {
        new PMHR_FinalTeamBuilder()
                .setNuzlocke(nuzlockeId)
                .setName(finalTeamName)
                .save();
    }
}