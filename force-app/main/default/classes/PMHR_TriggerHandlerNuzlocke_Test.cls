@IsTest
private class PMHR_TriggerHandlerNuzlocke_Test {
    @TestSetup static void setup() {
        Hero__c hero = new PMHR_HeroBuilder()
                .save();
        Nuzlocke__c nuzlocke = new PMHR_NuzlockeBuilder()
                .setHero(hero.Id)
                .save();
    }

    static testMethod void shouldNotFinishNuzlocke_WithStatusSuccess() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        Boolean errorOccurred = false;

        //when
        Test.startTest();
        try {
            nuzlocke = new PMHR_NuzlockeBuilder(nuzlocke)
                    .setEndDate(Date.today())
                    .setEndStatus(PMHR_NuzlockeBuilder.END_STATUS_SUCCESS)
                    .save();
        } catch (Exception ex) {
            errorOccurred = true;
        }
        Test.stopTest();

        //then
        nuzlocke = PMHR_NuzlockeQueryService.getNuzlockeById(nuzlocke.Id);
        System.assert(!nuzlocke.Is_Finished__c);
        System.assert(errorOccurred);
    }

    static testMethod void shouldFinishNuzlocke_WithStatusFailure() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        Boolean errorOccurred = false;

        //when
        Test.startTest();
        try {
            nuzlocke = new PMHR_NuzlockeBuilder(nuzlocke)
                    .setEndDate(Date.today())
                    .setEndStatus(PMHR_NuzlockeBuilder.END_STATUS_FAILED)
                    .save();
        } catch (Exception ex) {
            errorOccurred = true;
        }
        Test.stopTest();

        //then
        nuzlocke = PMHR_NuzlockeQueryService.getNuzlockeById(nuzlocke.Id);
        System.assert(nuzlocke.Is_Finished__c);
        System.assertEquals(nuzlocke.End_Status__c, PMHR_NuzlockeBuilder.END_STATUS_FAILED);
        System.assert(!errorOccurred);
    }

    static testMethod void shouldFinishNuzlocke_WithStatusSuccess() {
        //given
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        Boolean errorOccurred = false;

        //when
        Test.startTest();
        try {
            Final_Team__c newFinalTeam = new PMHR_FinalTeamBuilder()
                    .setNuzlocke(nuzlocke.Id)
                    .save();
        } catch (Exception ex) {
            errorOccurred = true;
        }
        Test.stopTest();

        //then
        nuzlocke = [SELECT Id, Is_Finished__c, End_Status__c FROM Nuzlocke__c WHERE Id = :nuzlocke.Id];
        System.assert(nuzlocke.Is_Finished__c);
        System.assertEquals(PMHR_NuzlockeBuilder.END_STATUS_SUCCESS, nuzlocke.End_Status__c);
        System.assert(!errorOccurred);
    }

    static testMethod void shouldDeleteNuzlockeRelatedFinalTeam() {
        Nuzlocke__c nuzlocke = [SELECT Id FROM Nuzlocke__c LIMIT 1];
        Final_Team__c newFinalTeam = new PMHR_FinalTeamBuilder()
                .setNuzlocke(nuzlocke.Id)
                .save();
        System.assertEquals(1, [SELECT Count() FROM Nuzlocke__c]);
        System.assertEquals(1, [SELECT Count() FROM Final_Team__c]);

        //when
        Test.startTest();
        delete nuzlocke;
        Test.stopTest();

        //then
        System.assertEquals(0, [SELECT Count() FROM Nuzlocke__c]);
        System.assertEquals(0, [SELECT Count() FROM Final_Team__c]);
    }
}