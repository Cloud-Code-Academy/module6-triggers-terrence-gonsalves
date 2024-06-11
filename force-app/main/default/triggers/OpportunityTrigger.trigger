trigger OpportunityTrigger on Opportunity (before update) {
    OpportunityTriggerHandler handler = new OpportunityTriggerHandler(trigger.isExecuting, trigger.size);

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            // handler.beforeInsert(Trigger.new);
        } 
        when BEFORE_UPDATE {

            /* Question #6 */
            
            // I cannot seem to get this to work inside the OpportunityTriggerHandler class
            for (Opportunity o : Trigger.new) {
                if (o.Amount < 5000) {
                    o.addError('Opportunity amount must be greater than 5000');
                }
            }
            //handler.beforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
        }
        when BEFORE_DELETE {
            // handler.beforeDelete(Trigger.old, Trigger.oldMap);
        }
        when AFTER_INSERT {
            // handler.afterInsert(Trigger.new, Trigger.newMap);
        }
        when AFTER_UPDATE {
            // handler.afterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
        }
        when AFTER_DELETE {
            // handler.afterDelete(Trigger.old, Trigger.oldMap);
        } 
        when AFTER_UNDELETE {
            // handler.afterUndelete(Trigger.new, Trigger.newMap);
        }
    }
}