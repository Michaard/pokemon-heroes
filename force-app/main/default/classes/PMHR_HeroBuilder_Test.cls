@IsTest
private class PMHR_HeroBuilder_Test {
    static testMethod void shouldBuildHero() {
        //given
        String name = 'Heroin';
        String nickname = 'Hero';
        String rivalName = 'Villain';

        //when
        Hero__c hero = new PMHR_HeroBuilder()
                .setName(name)
                .setNickname(nickname)
                .setRivalName(rivalName)
                .setGameVersion(PMHR_HeroBuilder.GAME_VERSION_RED)
                .setGender(PMHR_Utilities.GENDER_MALE)
                .setRegion(PMHR_HeroBuilder.REGION_KANTO)
                .save();

        //then
        hero = PMHR_HeroQueryService.getHeroById(hero.Id);
        System.assertEquals(name, hero.Name);
        System.assertEquals(nickname, hero.Nickname__c);
        System.assertEquals(rivalName, hero.Rival_Name__c);
        System.assertEquals(PMHR_HeroBuilder.GAME_VERSION_RED, hero.Game_Version__c);
        System.assertEquals(PMHR_Utilities.GENDER_MALE, hero.Gender__c);
        System.assertEquals(PMHR_HeroBuilder.REGION_KANTO, hero.Region__c);
    }
}