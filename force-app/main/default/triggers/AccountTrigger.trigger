trigger AccountTrigger on Account (before insert, after insert) {
    AccountTriggerHandler handler = new AccountTriggerHandler(trigger.isExecuting, trigger.size);

    switch on trigger.operationType {
        when BEFORE_INSERT {
            handler.beforeInsert(trigger.new);
        }

        when BEFORE_UPDATE {
            handler.beforeUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
        }

        when AFTER_UPDATE {
            handler.afterUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
        }

        when AFTER_INSERT {
            handler.afterInsert(trigger.new, trigger.newMap);
        }

        when AFTER_DELETE {
            handler.afterDelete(trigger.old, trigger.oldMap);
        }

        when AFTER_UNDELETE {
            handler.afterUndelete(trigger.new, trigger.newMap);
        }
    }
}