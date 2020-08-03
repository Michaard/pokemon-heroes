@IsTest
private class PMHR_NewFinalTeamButtonController_Test {
    private static final String finalTeamName = 'Test Final Team';

    @TestSetup static void setup() {
        Hero__c hero = new PMHR_HeroBuilder()
                .save();
        Nuzlocke__c nuzlocke = new PMHR_NuzlockeBuilder()
                .setHero(hero.Id)
                .save();
    }

    static testMethod void shouldCreateNewFinalTeam() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];

        //when
        Test.startTest();
        PMHR_NewFinalTeamButtonController.createFinalTeam(nuzlocke.Id, finalTeamName);
        Test.stopTest();

        //then
        Final_Team__c finalTeam = PMHR_FinalTeamQueryService.getFinalTeamByNuzlockeId(nuzlocke.Id);
        System.assertNotEquals(null, finalTeam);
        System.assertEquals(finalTeamName, finalTeam.Name);
        System.assertEquals(nuzlocke.Id, finalTeam.Nuzlocke__c);
    }

    static testMethod void shouldNotCreateNewFinalTeam() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        new PMHR_FinalTeamBuilder()
                .setNuzlocke(nuzlocke.Id)
                .save();
        Boolean errorOccurred = false;

        //when
        Test.startTest();
        try {
            PMHR_NewFinalTeamButtonController.createFinalTeam(nuzlocke.Id, finalTeamName);
        } catch (Exception ex) {
            errorOccurred = true;
        }
        Test.stopTest();

        //then
        System.assert(errorOccurred);
    }

    static testMethod void shouldCreateNewFinalTeams() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        nuzlocke = new PMHR_NuzlockeBuilder(nuzlocke)
                .setMultipleEliteFourFights(true)
                .save();

        new PMHR_FinalTeamBuilder()
                .setNuzlocke(nuzlocke.Id)
                .save();

        //when
        Test.startTest();
        PMHR_NewFinalTeamButtonController.createFinalTeam(nuzlocke.Id, finalTeamName);
        Test.stopTest();

        //then
        nuzlocke = PMHR_NuzlockeQueryService.getNuzlockeWithFinalTeamsById(nuzlocke.Id);
        System.assertEquals(2, nuzlocke.Final_Teams__r.size());
    }
}