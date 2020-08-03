({
    getFinalTeamInfo : function(component) {
        let nuzlockeId = component.get("v.recordId");

        let action = component.get("c.getFinalTeamInfo");
        action.setParam("nuzlockeId", nuzlockeId);

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                let finalTeams = response.getReturnValue();
                component.set("v.finalTeams", finalTeams);
            } else if (state === "ERROR") {
                let toastEvent = $A.get("e.force:showToast");
                if (toastEvent) {
                    toastEvent.setParams({
                        "message": $A.get("$Label.c.Toast_Error_Final_Team_Info"),
                        "type": "error"
                    });
                    toastEvent.fire();
                }
            }
        });

        $A.enqueueAction(action);
    }
})