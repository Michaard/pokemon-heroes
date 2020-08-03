({
    retrievePictureInformation : function(component) {
        let pokemonId = component.get("v.recordId");

        let action = component.get("c.getPokemonPicture");
        action.setParam("pokemonId", pokemonId);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let pokemonPictureData = response.getReturnValue();
                component.set("v.pokemonPictureData", pokemonPictureData);
            } else if (state === "ERROR") {
                let toastEvent = $A.get("e.force:showToast");
                if (toastEvent) {
                    toastEvent.setParams({
                        "message": $A.get("$Label.c.PMHR_Error_Retrieving_Picture"),
                        "type": "error"
                    });
                    toastEvent.fire();
                }
            }
            component.set("v.displaySpinner", false);
        });

        $A.enqueueAction(action);
        component.set("v.displaySpinner", true);
    },

    refreshRecord : function(component) {
        let recordLoader = component.find("recordLoader");
        if (recordLoader) {
            recordLoader.reloadRecord();
        }
    }
})