public with sharing class PMHR_PokemonBuilder {
    public static final String CATCH_METHOD_EVENT = 'Event';

    private PMHR_Pokemon__c record;

    private PMHR_Pokemon__c defaultData() {
        return new PMHR_Pokemon__c(
                Name = 'Default Pokemon',
                Gender__c = PMHR_Utilities.GENDER_MALE,
                CatchMethod__c = 'Route 1',
                RegionalVariant__c = PMHR_Utilities.REGION_VARIANT_STANDARD
        );
    }

    public PMHR_PokemonBuilder() {
        this.record = this.defaultData();
    }

    public PMHR_PokemonBuilder(PMHR_Pokemon__c record) {
        this.record = record;
    }

    public PMHR_PokemonBuilder reset() {
        this.record = this.defaultData();
        return this;
    }

    public PMHR_Pokemon__c build() {
        PMHR_Pokemon__c record = this.record;
        this.reset();
        return record;
    }

    public PMHR_Pokemon__c save() {
        PMHR_Pokemon__c record = this.build();
        upsert record;
        return record;
    }

    public PMHR_PokemonBuilder setName(String name) {
        this.record.Name = name;
        return this;
    }

    public PMHR_PokemonBuilder setNuzlocke(Id nuzlockeId) {
        this.record.Nuzlocke__c = nuzlockeId;
        return this;
    }

    public PMHR_PokemonBuilder setCaughtForm(Id pokemonId) {
        this.record.CaughtForm__c = pokemonId;
        return this;
    }

    public PMHR_PokemonBuilder setForm(Id pokemonId) {
        this.record.Form__c = pokemonId;
        return this;
    }

    public PMHR_PokemonBuilder setCatchMethod(String catchMethod) {
        this.record.CatchMethod__c = catchMethod;
        return this;
    }

    public PMHR_PokemonBuilder setCatchLocation(String catchLocation) {
        this.record.Location__c = catchLocation;
        return this;
    }

    public PMHR_PokemonBuilder setDeath(Boolean isDeceased) {
        this.record.IsDeceased__c = isDeceased;
        return this;
    }

    public PMHR_PokemonBuilder setDeathCause(String cause) {
        this.record.CauseOfDeath__c = cause;
        return this;
    }

    public PMHR_PokemonBuilder setDeathLevel(Integer deathLevel) {
        this.record.DeathLevel__c = Decimal.valueOf(deathLevel);
        return this;
    }

    public PMHR_PokemonBuilder setGender(String gender) {
        this.record.Gender__c = gender;
        return this;
    }

    public PMHR_PokemonBuilder setRegionSpecificVariant(String variant) {
        this.record.RegionalVariant__c = String.isBlank(variant) ? PMHR_Utilities.REGION_VARIANT_STANDARD : variant;
        return this;
    }
}