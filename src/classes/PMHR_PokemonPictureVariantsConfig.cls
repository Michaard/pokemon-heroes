public class PMHR_PokemonPictureVariantsConfig {
    private static PMHR_PokemonPictureVariantsConfig instance;
    private static Map<String, List<String>> regionVariantToFieldsApiNamesMap;

    private PMHR_PokemonPictureVariantsConfig() {
        regionVariantToFieldsApiNamesMap = new Map<String, List<String>>();
        String pictureUrlFieldApiName = Pokemon_Data__c.Picture_Url__c.getDescribe().getName();
        String typeFieldApiName = Pokemon_Data__c.Type__c.getDescribe().getName();
        for (PicklistEntry variant : PMHR_Utilities.POKEMON_REGIONAL_VARIANT) {
            String variantName = variant.getValue();
            String pictureApiName = variantName == PMHR_Utilities.REGION_VARIANT_STANDARD ? pictureUrlFieldApiName : String.join(new List<String>{variantName, pictureUrlFieldApiName}, '_');
            String typeApiName = variantName == PMHR_Utilities.REGION_VARIANT_STANDARD ? typeFieldApiName : String.join(new List<String>{variantName, typeFieldApiName}, '_');
            regionVariantToFieldsApiNamesMap.put(variantName, new List<String>{pictureApiName, typeApiName});
        }
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