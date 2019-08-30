({
    init : function(component, event, helper) {
        helper.getNextAvailableForms(component);
    },

    levelUp : function(component, event, helper) {
        let index = event.getSource().get("v.name");
        let nextFormId = component.get("v.nextAvailableForms")[index].Id;
        helper.setPokemonForm(component, nextFormId);
    }
})