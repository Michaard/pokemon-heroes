public class PMHR_PokemonPictureVariantsConfig {
    private static PMHR_PokemonPictureVariantsConfig instance;
    private static Map<String, List<String>> regionVariantToFieldsApiNamesMap;

    private PMHR_PokemonPictureVariantsConfig() {
        regionVariantToFieldsApiNamesMap = new Map<String, List<String>> {
                PMHR_Utilities.REGION_VARIANT_STANDARD => new List<String> {'Picture_Url__c', 'Type__c'},
                PMHR_Utilities.REGION_VARIANT_ALOLAN => new List<String> {'Alolan_Picture_Url__c', 'Alolan_Type__c'},
                PMHR_Utilities.REGION_VARIANT_GALARIAN => new List<String> {'Galarian_Picture_Url__c', 'Galarian_Type__c'}
        };
    }

    public static PMHR_PokemonPictureVariantsConfig getInstance() {
        if (instance == null) {
            instance = new PMHR_PokemonPictureVariantsConfig();
        }
        return instance;
    }

    public String getPictureFieldApiName(String variant) {
        return regionVariantToFieldsApiNamesMap.get(variant).get(0);
    }

    public String getTypeFieldApiName(String variant) {
        return regionVariantToFieldsApiNamesMap.get(variant).get(1);
    }
}