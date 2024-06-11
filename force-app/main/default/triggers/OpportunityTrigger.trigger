trigger OpportunityTrigger on Opportunity (before update) {
    OpportunityTriggerHandler handler = new OpportunityTriggerHandler(trigger.isExecuting, trigger.size);

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            // handler.beforeInsert(Trigger.new);
        } 

        when BEFORE_UPDATE {

            /* Question #5 */

            // I cannot seem to get this to work inside the OpportunityTriggerHandler class
            for (Opportunity o : Trigger.new) {
                if (o.Amount < 5000) {
                    o.addError('Opportunity amount must be greater than 5000');
                }
            }
            
            /* Question #7 */

            Set<Id> accountIds = new Set<Id>();

            for (Opportunity o : Trigger.new) {
                if (o.AccountId != null) {
                    accountIds.add(o.AccountId);
                }
            }

            // get contacts that have same AccountId as the Opportunity
            if (!accountIds.isEmpty()) {
                Map<Id, Contact> accountToContactMap = new Map<Id, Contact>();

                for (Contact c : [select Id, FirstName, Title, AccountId from Contact where AccountId in :accountIds and Title = 'CEO']) {
                    if (!accountToContactMap.containsKey(c.AccountId)) {
                        accountToContactMap.put(c.AccountId, c);
                    }
                }

                // loop Opportunities and set Primary Contact

                for (Opportunity o : Trigger.new) {
                    o.Primary_Contact__c = accountToContactMap.get(o.AccountId).Id;
                }
                for (Opportunity o : Trigger.new) {
                    if (o.AccountId != null && o.Primary_Contact__c == null) {
                        o.Primary_Contact__c = accountToContactMap.get(o.AccountId).Id;
                    }
                }
            }
        }

        when BEFORE_DELETE {

            /* Question #6 */

            Set<Id> accountIds = new Set<Id>();

            // collect Account IDs for Opportunities that are 'Closed Won'
            for (Opportunity o : Trigger.old) {
                if (o.StageName == 'Closed Won' && o.AccountId != null) {
                    accountIds.add(o.AccountId);
                }
            }
            
            if (!accountIds.isEmpty()) {
                Map<Id, Account> accountMap = new Map<Id, Account>([select Id, Industry from Account where Id in :accountIds]);
                
                for (Opportunity o : Trigger.old) {
                    if (o.StageName == 'Closed Won' && o.AccountId != null) {
                        Account a = accountMap.get(o.AccountId);
                        
                        if (a != null && a.Industry == 'Banking') {
                            o.addError('Cannot delete closed opportunity for a banking account that is won');
                        }
                    }
                }
            }
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