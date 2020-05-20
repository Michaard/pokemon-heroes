public with sharing class PMHR_PokemonAdditionalVariantBuilder extends PMHR_PokemonDataBuilder {
    protected override Pokemon_Data__c defaultData() {
        return new Pokemon_Data__c(
                Primary_Type__c = TYPE_NORMAL,
                Region_Specific_Variant__c = PMHR_Utilities.REGION_VARIANT_ALOLAN,
                RecordTypeId = PMHR_Utilities.getRecordTypeIdByName(SObjectType.Pokemon_Data__c, PMHR_PokemonDataBuilder.RT_ADDITIONAL_VARIANT)
        );
    }

    public PMHR_PokemonAdditionalVariantBuilder() {
        super();
    }

    public PMHR_PokemonAdditionalVariantBuilder(Pokemon_Data__c pokemonDataRecord) {
        super(pokemonDataRecord);
    }
}