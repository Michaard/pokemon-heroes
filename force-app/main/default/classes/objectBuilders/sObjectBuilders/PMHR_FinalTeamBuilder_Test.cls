@IsTest
private class PMHR_FinalTeamBuilder_Test {
    static testMethod void shouldBuildFinalTeam() {
        //given
        PMHR_Hero__c hero = new PMHR_HeroBuilder()
                .save();
        PMHR_Nuzlocke__c nuzlocke = new PMHR_NuzlockeBuilder()
                .setHero(hero.Id)
                .save();
        String name = 'The Bests';

        //when
        PMHR_FinalTeam__c finalTeam = new PMHR_FinalTeamBuilder()
                .setName(name)
                .setNuzlocke(nuzlocke.Id)
                .save();

        //then
        finalTeam = PMHR_FinalTeamQueryService.getFinalTeamById(finalTeam.Id);
        System.assertEquals(name, finalTeam.Name);
        System.assertEquals(nuzlocke.Id, finalTeam.Nuzlocke__c);
    }
}