trigger AccountTrigger on Account (before insert, after insert) {
    AccountTriggerHandler handler = new AccountTriggerHandler(trigger.isExecuting, trigger.size);

    switch on trigger.operationType {
        when BEFORE_INSERT {
            handler.beforeInsert(trigger.new);
        }

        when AFTER_INSERT {
            handler.afterInsert(trigger.new, trigger.newMap);
        }
    }
}