public with sharing class PMHR_NuzlockeBuilder {
    public static final String END_STATUS_SUCCESS = 'Success';
    public static final String END_STATUS_FAILED = 'Failed';

    public static final String POKEMON_CATCH_METHOD_EVENT = 'Event';

    public static final String LEGENDARIES_RULE_KILL = 'Kill';

    public static final String SAFARI_ZONE_RULE_ONE_PER_AREA = 'One/Area';

    private Nuzlocke__c record;

    private Nuzlocke__c defaultData() {
        return new Nuzlocke__c(
                Name = 'Default Nuzlocke',
                Start_Date__c = Date.today(),
                Allowed_Catching_Methods_Per_Area__c = POKEMON_CATCH_METHOD_EVENT,
                Legendaries_Rule__c = LEGENDARIES_RULE_KILL
        );
    }

    public PMHR_NuzlockeBuilder() {
        this.record = this.defaultData();
    }

    public PMHR_NuzlockeBuilder(Nuzlocke__c nuzlocke) {
        this.record = nuzlocke;
    }

    public PMHR_NuzlockeBuilder reset() {
        this.record = this.defaultData();
        return this;
    }

    public Nuzlocke__c build() {
        Nuzlocke__c record = this.record;
        this.reset();
        return record;
    }

    public Nuzlocke__c save() {
        Nuzlocke__c record = this.build();
        upsert record;
        return record;
    }

    public PMHR_NuzlockeBuilder setName(String name) {
        this.record.Name = name;
        return this;
    }

    public PMHR_NuzlockeBuilder setHero(Id heroId) {
        this.record.Hero__c = heroId;
        return this;
    }

    public PMHR_NuzlockeBuilder setAllwoedCatchMethodsPerArea(List<String> allowedCatchMethods) {
        if (allowedCatchMethods == null) {
            throw new NullAllowedCatchMethodsException();
        }
        this.record.Allowed_Catching_Methods_Per_Area__c = String.join(allowedCatchMethods, ';');
        return this;
    }

    public PMHR_NuzlockeBuilder setStartDate(Date startDate) {
        this.record.Start_Date__c = startDate;
        return this;
    }

    public PMHR_NuzlockeBuilder setLegendariesRule(String legendariesRule) {
        this.record.Legendaries_Rule__c = legendariesRule;
        return this;
    }

    public PMHR_NuzlockeBuilder setSafariZoneRule(String safariZoneRule) {
        this.record.Safari_Zone_Rule__c = safariZoneRule;
        return this;
    }

    public PMHR_NuzlockeBuilder setEndDate(Date endDate) {
        this.record.End_Date__c = endDate;
        return this;
    }

    public PMHR_NuzlockeBuilder setEndStatus(String status) {
        this.record.End_Status__c = status;
        return this;
    }

    public PMHR_NuzlockeBuilder setMultipleEliteFourFights(Boolean isMultipleEliteFourFight) {
        this.record.Multiple_Elite_Four_Fights__c = isMultipleEliteFourFight;
        return this;
    }

    public class NullAllowedCatchMethodsException extends Exception{}
}