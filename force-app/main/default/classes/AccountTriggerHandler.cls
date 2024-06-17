public without sharing class AccountTriggerHandler {
    private Boolean triggerIsExecuting;
    private Integer triggerSize;
    //private String operationType;

    public AccountTriggerHandler(Boolean triggerIsExecuting, Integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    /*
    private void switchOnType(String operationType) {
        switch on trigger.operationType {
            when BEFORE_INSERT {
                beforeInsert(trigger.new);
            }
    
            when BEFORE_UPDATE {
                beforeUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
            }
    
            when AFTER_UPDATE {
                afterUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
            }
    
            when AFTER_INSERT {
                afterInsert(trigger.new, trigger.newMap);
            }
    
            when AFTER_DELETE {
                afterDelete(trigger.old, trigger.oldMap);
            }
    
            when AFTER_UNDELETE {
                afterUndelete(trigger.new, trigger.newMap);
            }
        }
    }
    */

    /*Before Insert*/
    public void beforeInsert(List<Account> newAccounts) {
        for (Account a : newAccounts) {
            
            /*Question #1*/

            // check if Type is empty
            if (a.Type == '' || a.Type == null) {
                a.Type = 'Prospect';
            }

            /*Questions #2*/

            // copy shipping to billing address checking fields are not empty
            if (a.ShippingStreet == null || a.ShippingStreet == '') {
                a.BillingStreet = a.ShippingStreet;
            }

            if (a.ShippingCity == null || a.ShippingCity == '') {
                a.BillingCity = a.ShippingCity;
            }

            if (a.ShippingPostalCode == null || a.ShippingPostalCode == '') {
                a.BillingPostalCode = a.ShippingPostalCode;
            }

            if (a.ShippingState == null || a.ShippingState == '') {
                a.BillingState = a.ShippingState;
            }

            if (a.ShippingCountry == null || a.ShippingCountry == '') {
                a.BillingCountry = a.ShippingCountry;
            }

            /*Questions #3*/

            if (!String.isBlank(a.Phone) && !String.isBlank(a.Fax) && !String.isBlank(a.Website)) {
                a.Rating = 'Hot';
            }
        }
    }

    /*After Insert*/
    public void afterInsert(List<Account> newAccounts, Map<ID, SObject> newAccountMap) {

        /*Question #4*/

        List<Contact> contactObjects = new List<Contact>();

        for (Account a : newAccounts) {
            Contact con = new Contact(LastName = 'DefaultContact', Email = 'default@email.com', AccountId = a.Id);
            contactObjects.add(con);
        }

        insert contactObjects;
    }
}