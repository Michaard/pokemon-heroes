({
    onInit : function(component, event, helper) {
        helper.retrievePictureInformation(component);
    },

    onRecordChange : function(component, event, helper) {
        let changeType = event.getParams().changeType;
        if (changeType === "CHANGED") {
            helper.refreshRecord(component);
            helper.retrievePictureInformation(component);
        }
    }
})