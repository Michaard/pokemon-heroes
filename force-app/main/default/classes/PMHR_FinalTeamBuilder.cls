public with sharing class PMHR_FinalTeamBuilder {
    private Final_Team__c record;

    private Final_Team__c defaultData() {
        return new Final_Team__c(
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

    public Final_Team__c build() {
        Final_Team__c record = this.record;
        this.reset();
        return record;
    }

    public Final_Team__c save() {
        Final_Team__c record = this.build();
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