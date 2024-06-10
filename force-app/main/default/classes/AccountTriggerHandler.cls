public without sharing class AccountTriggerHandler {
    private Boolean triggerIsExecuting;
    private Integer triggerSize;
    //private Enum operationType {BEFORE_INSERT, BEFORE_UPDATE, AFTER_UPDATE, AFTER_INSERT, AFTER_DELETE, AFTER_UNDELETE};

    public AccountTriggerHandler(Boolean triggerIsExecuting, Integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        //this.operationType = operationType;
    }

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
            if (!String.isBlank(a.ShippingStreet)) {
                a.BillingStreet = a.ShippingStreet;
            }

            if (!String.isBlank(a.ShippingCity)) {
                a.BillingCity = a.ShippingCity;
            }

            if (!String.isBlank(a.ShippingPostalCode)) {
                a.BillingPostalCode = a.ShippingPostalCode;
            }

            if (!String.isBlank(a.ShippingState)) {
                a.BillingState = a.ShippingState;
            }

            if (!String.isBlank(a.ShippingCountry)) {
                a.BillingCountry = a.ShippingCountry;
            }

            /*Questions #3*/

            if (!String.isBlank(a.Phone) && !String.isBlank(a.Fax) && !String.isBlank(a.Website)) {
                a.Rating = 'Hot';
            }
        }
    }

    /*Before Update*/
    public void beforeUpdate(List<Account> oldAccounts, List<Account> newAccounts, Map<ID, SObject> oldAccountMap, Map<ID, SObject> newAccountMap) {
        // helper.doTask3();
        // helper.doTask4();
    }

    /*Before Delete*/
    public void beforeDelete(List<Account> oldAccounts, Map<ID, SObject> oldAccountMap) {
        // helper.doTask5();
        // helper.doTask1();
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

    /*After Update*/
    public void afterUpdate(List<Account> oldAccounts, List<Account> newAccounts, Map<ID, SObject> oldAccountMap, Map<ID, SObject> newAccountMap) {
        // helper.doTask4();
        // helper.doTask5();
    }

    /*After Delete*/
    public void afterDelete(List<Account> oldAccounts, Map<ID, SObject> oldAccountMap) {
        // helper.doTask3();
        // helper.doTask1();
    }

    /*After Undelete*/
    public void afterUndelete(List<Account> newAccounts, Map<ID, SObject> newAccountMap) {
        // helper.doTask4();
        // helper.doTask2();
    }
}