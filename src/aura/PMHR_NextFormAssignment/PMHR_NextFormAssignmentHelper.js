({
    getNextAvailableForms : function(component) {
        let pokemonId = component.get("v.recordId");

        let action = component.get("c.getNextAvailableForms");
        action.setParam("pokemonId", pokemonId);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let pokemonWithNextForms = response.getReturnValue();
                component.set("v.pokemonName", pokemonWithNextForms.name);
                component.set("v.currentFormStage", pokemonWithNextForms.stage);
                component.set("v.nextAvailableForms", pokemonWithNextForms.nextForms);
            } else if (state === "ERROR") {
                let toastEvent = $A.get("e.force:showToast");
                if (toastEvent) {
                    toastEvent.setParams({
                        "message": $A.get("$Label.c.Toast_Error_Next_Available_Forms"),
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

    setPokemonForm : function(component, nextFormId) {
        let pokemonId = component.get("v.recordId");

        if (nextFormId) {
            let action = component.get("c.setPokemonForm");
            action.setParams({
                "pokemonId": pokemonId,
                "nextFormId": nextFormId
            });

            action.setCallback(this, function(response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    let toastEvent = $A.get("e.force:showToast");
                    if (toastEvent) {
                        toastEvent.setParams({
                            "message": $A.get("$Label.c.Toast_Success_Next_Form_Assigned"),
                            "type": "success"
                        });
                        toastEvent.fire();
                    }

                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                } else if (state === "ERROR") {
                    let toastEvent = $A.get("e.force:showToast");
                    if (toastEvent) {
                        toastEvent.setParams({
                            "message": $A.get("$Label.c.Toast_Error_Record_Update"),
                            "type": "error"
                        });
                        toastEvent.fire();
                    }
                }
            });

            $A.enqueueAction(action);
        } else {
            let toastEvent = $A.get("e.force:showToast");
            if (toastEvent) {
                toastEvent.setParams({
                    "message": $A.get("$Label.c.Toast_Error_Record_Update"),
                    "type": "error"
                });
                toastEvent.fire();
            }
        }
    }
})