public class PMHR_Utilities {
    public static final String GENDER_MALE = 'Male';

    public static final List<PicklistEntry> POKEMON_REGIONAL_VARIANT = Pokemon__c.Region_Specific_Variant__c.getDescribe().getPicklistValues();

    public static List<String> getPokemonRegionalVariantsValues() {
        List<String> regionSpecificVariants = new List<String>();
        for (PicklistEntry variant : PMHR_Utilities.POKEMON_REGIONAL_VARIANT) {
            regionSpecificVariants.add(variant.getValue());
        }
        return regionSpecificVariants;
    }

    public static Set<Id> fetchSObjectListToIdSet(List<SObject> sObjectList, SObjectField field) {
        String fieldName = field.getDescribe().getName();
        Set<Id> result = new Set<Id>();
        for (SObject so : sObjectList) {
            result.add((Id) so.get(fieldName));
        }
        return result;
    }
}