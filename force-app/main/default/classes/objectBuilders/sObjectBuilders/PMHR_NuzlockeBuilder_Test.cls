@IsTest
private class PMHR_NuzlockeBuilder_Test {
    static testMethod void shouldBuildNuzlocke() {
        //given
        String name = 'Nuzlocke';
        PMHR_Hero__c hero = new PMHR_HeroBuilder()
                .save();
        Date startDate = Date.today().addDays(-1);
        Date endDate = Date.today();
        Boolean isMultipleEliteFourFights = false;

        //when
        PMHR_Nuzlocke__c nuzlocke = new PMHR_NuzlockeBuilder()
                .setName(name)
                .setHero(hero.Id)
                .setStartDate(startDate)
                .setAllwoedCatchMethodsPerArea(new List<String> {PMHR_NuzlockeBuilder.POKEMON_CATCH_METHOD_EVENT})
                .setLegendariesRule(PMHR_NuzlockeBuilder.LEGENDARIES_RULE_KILL)
                .setSafariZoneRule(PMHR_NuzlockeBuilder.SAFARI_ZONE_RULE_ONE_PER_AREA)
                .setMultipleEliteFourFights(isMultipleEliteFourFights)
                .save();

        nuzlocke = new PMHR_NuzlockeBuilder(nuzlocke)
                .setEndDate(endDate)
                .setEndStatus(PMHR_NuzlockeBuilder.END_STATUS_FAILED)
                .save();

        //then
        nuzlocke = PMHR_NuzlockeQueryService.getNuzlockeById(nuzlocke.Id);
        System.assertEquals(name, nuzlocke.Name);
        System.assertEquals(hero.Id, nuzlocke.Hero__c);
        System.assertEquals(startDate, nuzlocke.StartDate__c);
        System.assertEquals(PMHR_NuzlockeBuilder.POKEMON_CATCH_METHOD_EVENT, nuzlocke.AllowedCatchingMethodsPerArea__c);
        System.assertEquals(PMHR_NuzlockeBuilder.LEGENDARIES_RULE_KILL, nuzlocke.LegendariesRule__c);
        System.assertEquals(PMHR_NuzlockeBuilder.SAFARI_ZONE_RULE_ONE_PER_AREA, nuzlocke.SafariZoneRule__c);
        System.assertEquals(isMultipleEliteFourFights, nuzlocke.Multiple_Elite_Four_Fights__c);
        System.assertEquals(endDate, nuzlocke.EndDate__c);
        System.assertEquals(PMHR_NuzlockeBuilder.END_STATUS_FAILED, nuzlocke.Status__c);
    }

    static testMethod void shouldThrowExceptionNullAllowedCatchMethods() {
        //given
        Boolean errorOccurred = false;

        //when
        try {
            PMHR_Nuzlocke__c nuzlocke = new PMHR_NuzlockeBuilder()
                    .setAllwoedCatchMethodsPerArea(null)
                    .build();
        } catch (PMHR_NuzlockeBuilder.NullAllowedCatchMethodsException ex) {
            errorOccurred = true;
        }

        //then
        System.assert(errorOccurred);
    }
}