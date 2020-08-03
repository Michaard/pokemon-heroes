({
    init : function(component, event, helper) {
        helper.initData(component);
    },

    onRecordChange : function(component, event, helper) {
        let changeType = event.getParams().changeType;
        if (changeType === "CHANGED") {
            let recordLoader = component.find("recordLoader");
            if (recordLoader) {
                recordLoader.reloadRecord();
            }
        }
    }
})