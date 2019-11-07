@IsTest
private class PMHR_NewFinalTeamButtonController_Test {
    private static final String finalTeamName = 'Test Final Team';
    @TestSetup static void setup() {
        Hero__c hero = PMHR_TestDataFactory.createHeroObject('Trainer', PMHR_Utilities.HERO_GAME_VERSION_RED);
        insert hero;
        Nuzlocke__c nuzlocke = PMHR_TestDataFactory.createNuzlockeObject('Test Nuzlocke', Date.today(), hero.Id);
        insert nuzlocke;
    }

    static testMethod void shouldCreateNewFinalTeam() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];

        //when
        Test.startTest();
        PMHR_NewFinalTeamButtonController.createFinalTeam(nuzlocke.Id, finalTeamName);
        Test.stopTest();

        //then
        Final_Team__c finalTeam = [SELECT Id, Nuzlocke__c, Name FROM Final_Team__c WHERE Nuzlocke__c = :nuzlocke.Id LIMIT 1];
        System.assertNotEquals(null, finalTeam);
        System.assertEquals(finalTeamName, finalTeam.Name);
        System.assertEquals(nuzlocke.Id, finalTeam.Nuzlocke__c);
    }

    static testMethod void shouldNotCreateNewFinalTeam() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        String error;

        //when
        Test.startTest();
        try {
            PMHR_NewFinalTeamButtonController.createFinalTeam(nuzlocke.Id, finalTeamName);
            PMHR_NewFinalTeamButtonController.createFinalTeam(nuzlocke.Id, finalTeamName + '2');
        } catch (Exception ex) {
            error = ex.getMessage();
        }
        Test.stopTest();

        //then
        System.assertNotEquals(null, error);
    }

    static testMethod void shouldCreateNewFinalTeams() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        nuzlocke.Multiple_Elite_Four_Fights__c = true;
        update nuzlocke;

        //when
        Test.startTest();
        PMHR_NewFinalTeamButtonController.createFinalTeam(nuzlocke.Id, finalTeamName);
        PMHR_NewFinalTeamButtonController.createFinalTeam(nuzlocke.Id, finalTeamName + '2');
        Test.stopTest();

        //then
        nuzlocke = [SELECT Id, (SELECT Name FROM Final_Teams__r) FROM Nuzlocke__c WHERE Id = :nuzlocke.Id LIMIT 1];
        System.assertEquals(2, nuzlocke.Final_Teams__r.size());
    }
}