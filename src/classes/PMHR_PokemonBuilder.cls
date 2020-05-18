public with sharing class PMHR_PokemonBuilder {
    public static final String CATCH_METHOD_EVENT = 'Event';

    public static final String REGION_VARIANT_ALOLAN = 'Alolan';

    private Pokemon__c record;

    private Pokemon__c defaultData() {
        return new Pokemon__c(
                Name = 'Default Pokemon',
                Gender__c = PMHR_Utilities.GENDER_MALE,
                Catch_Method__c = 'Route 1'
        );
    }

    public PMHR_PokemonBuilder() {
        this.record = this.defaultData();
    }

    public PMHR_PokemonBuilder(Pokemon__c record) {
        this.record = record;
    }

    public PMHR_PokemonBuilder reset() {
        this.record = this.defaultData();
        return this;
    }

    public Pokemon__c build() {
        Pokemon__c record = this.record;
        this.reset();
        return record;
    }

    public Pokemon__c save() {
        Pokemon__c record = this.build();
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
        this.record.Caught_Form__c = pokemonId;
        return this;
    }

    public PMHR_PokemonBuilder setForm(Id pokemonId) {
        this.record.Form__c = pokemonId;
        return this;
    }

    public PMHR_PokemonBuilder setCatchMethod(String catchMethod) {
        this.record.Catch_Method__c = catchMethod;
        return this;
    }

    public PMHR_PokemonBuilder setCatchLocation(String catchLocation) {
        this.record.Location__c = catchLocation;
        return this;
    }

    public PMHR_PokemonBuilder setDeath(Boolean isDead) {
        this.record.Death__c = isDead;
        return this;
    }

    public PMHR_PokemonBuilder setDeathCause(String cause) {
        this.record.Cause_of_Death__c = cause;
        return this;
    }

    public PMHR_PokemonBuilder setDeathLevel(Integer deathLevel) {
        this.record.Death_Level__c = Decimal.valueOf(deathLevel);
        return this;
    }

    public PMHR_PokemonBuilder setGender(String gender) {
        this.record.Gender__c = gender;
        return this;
    }

    public PMHR_PokemonBuilder setRegionSpecificVariant(String variant) {
        this.record.Region_Specific_Variant__c = variant;
        return this;
    }
}