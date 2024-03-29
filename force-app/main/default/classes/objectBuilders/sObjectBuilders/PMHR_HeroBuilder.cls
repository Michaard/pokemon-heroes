public with sharing class PMHR_HeroBuilder {
    public static final String GAME_VERSION_RED = 'Red';

    public static final String REGION_KANTO = 'Kanto';

    private PMHR_Hero__c record;

    private PMHR_Hero__c defaultData() {
        return new PMHR_Hero__c(
                Name = 'Default Hero',
                GameVersion__c = GAME_VERSION_RED,
                Region__c = REGION_KANTO
        );
    }

    public PMHR_HeroBuilder() {
        this.record = this.defaultData();
    }

    public PMHR_HeroBuilder reset() {
        this.record = this.defaultData();
        return this;
    }

    public PMHR_Hero__c build() {
        PMHR_Hero__c record = this.record;
        this.reset();
        return record;
    }

    public PMHR_Hero__c save() {
        PMHR_Hero__c record = this.build();
        upsert record;
        return record;
    }

    public PMHR_HeroBuilder setName(String name) {
        this.record.Name = name;
        return this;
    }

    public PMHR_HeroBuilder setNickname(String nickname) {
        this.record.Nickname__c = nickname;
        return this;
    }

    public PMHR_HeroBuilder setRivalName(String rivalName) {
        this.record.RivalName__c = rivalName;
        return this;
    }

    public PMHR_HeroBuilder setGender(String gender) {
        this.record.Gender__c = gender;
        return this;
    }

    public PMHR_HeroBuilder setGameVersion(String gameVersion) {
        this.record.GameVersion__c = gameVersion;
        return this;
    }

    public PMHR_HeroBuilder setRegion(String region) {
        this.record.Region__c = region;
        return this;
    }
}