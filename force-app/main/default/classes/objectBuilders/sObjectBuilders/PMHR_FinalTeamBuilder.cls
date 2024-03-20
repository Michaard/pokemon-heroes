public with sharing class PMHR_FinalTeamBuilder {
    private PMHR_FinalTeam__c record;

    private PMHR_FinalTeam__c defaultData() {
        return new PMHR_FinalTeam__c(
                Name = 'Default Final Team'
        );
    }

    public PMHR_FinalTeamBuilder() {
        this.record = this.defaultData();
    }

    public PMHR_FinalTeamBuilder reset() {
        this.record = this.defaultData();
        return this;
    }

    public PMHR_FinalTeam__c build() {
        PMHR_FinalTeam__c record = this.record;
        this.reset();
        return record;
    }

    public PMHR_FinalTeam__c save() {
        PMHR_FinalTeam__c record = this.build();
        upsert record;
        return record;
    }

    public PMHR_FinalTeamBuilder setName(String name) {
        this.record.Name = name;
        return this;
    }

    public PMHR_FinalTeamBuilder setNuzlocke(Id nuzlockeId) {
        this.record.Nuzlocke__c = nuzlockeId;
        return this;
    }
}