public with sharing class PMHR_PokemonAdditionalVariantBuilder extends PMHR_PokemonDataBuilder {
    protected override PMHR_PokemonData__c defaultData() {
        return new PMHR_PokemonData__c(
                PrimaryType__c = TYPE_NORMAL,
                RegionalVariant__c = PMHR_Utilities.REGION_VARIANT_ALOLAN,
                RecordTypeId = PMHR_Utilities.getRecordTypeIdByName(SObjectType.PMHR_PokemonData__c, PMHR_PokemonDataBuilder.RT_ADDITIONAL_VARIANT),
                EvolvesFromVariant__c = PMHR_Utilities.REGION_VARIANT_STANDARD
        );
    }

    public PMHR_PokemonAdditionalVariantBuilder() {
        super();
    }

    public PMHR_PokemonAdditionalVariantBuilder(PMHR_PokemonData__c pokemonDataRecord) {
        super(pokemonDataRecord);
    }
}