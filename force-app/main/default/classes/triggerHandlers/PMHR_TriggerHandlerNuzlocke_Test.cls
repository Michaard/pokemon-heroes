@IsTest
private class PMHR_TriggerHandlerNuzlocke_Test {
    @TestSetup static void setup() {
        PMHR_Hero__c hero = new PMHR_HeroBuilder()
                .save();
        PMHR_Nuzlocke__c nuzlocke = new PMHR_NuzlockeBuilder()
                .setHero(hero.Id)
                .save();
    }

    static testMethod void shouldNotFinishNuzlocke_WithStatusSuccess() {
        //given
        PMHR_Nuzlocke__c nuzlocke = [SELECT Id FROM PMHR_Nuzlocke__c LIMIT 1];
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
        System.assert(!nuzlocke.IsFinished__c);
        System.assert(errorOccurred);
    }

    static testMethod void shouldFinishNuzlocke_WithStatusFailure() {
        //given
        PMHR_Nuzlocke__c nuzlocke = [SELECT Id FROM PMHR_Nuzlocke__c LIMIT 1];
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
        System.assert(nuzlocke.IsFinished__c);
        System.assertEquals(nuzlocke.Status__c, PMHR_NuzlockeBuilder.END_STATUS_FAILED);
        System.assert(!errorOccurred);
    }

    static testMethod void shouldFinishNuzlocke_WithStatusSuccess() {
        //given
        PMHR_Nuzlocke__c nuzlocke = [SELECT Id FROM PMHR_Nuzlocke__c LIMIT 1];
        Boolean errorOccurred = false;

        //when
        Test.startTest();
        try {
            PMHR_FinalTeam__c newFinalTeam = new PMHR_FinalTeamBuilder()
                    .setNuzlocke(nuzlocke.Id)
                    .save();
        } catch (Exception ex) {
            errorOccurred = true;
        }
        Test.stopTest();

        //then
        nuzlocke = [SELECT Id, IsFinished__c, Status__c FROM PMHR_Nuzlocke__c WHERE Id = :nuzlocke.Id];
        System.assert(nuzlocke.IsFinished__c);
        System.assertEquals(PMHR_NuzlockeBuilder.END_STATUS_SUCCESS, nuzlocke.Status__c);
        System.assert(!errorOccurred);
    }

    static testMethod void shouldDeleteNuzlockeRelatedFinalTeam() {
        PMHR_Nuzlocke__c nuzlocke = [SELECT Id FROM PMHR_Nuzlocke__c LIMIT 1];
        PMHR_FinalTeam__c newFinalTeam = new PMHR_FinalTeamBuilder()
                .setNuzlocke(nuzlocke.Id)
                .save();
        System.assertEquals(1, [SELECT Count() FROM PMHR_Nuzlocke__c]);
        System.assertEquals(1, [SELECT Count() FROM PMHR_FinalTeam__c]);

        //when
        Test.startTest();
        delete nuzlocke;
        Test.stopTest();

        //then
        System.assertEquals(0, [SELECT Count() FROM PMHR_Nuzlocke__c]);
        System.assertEquals(0, [SELECT Count() FROM PMHR_FinalTeam__c]);
    }
}