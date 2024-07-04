/**
  * I did not like how I set up my Triggers so I looked into Trigger Framework and came across the SFDC trigger framework.
  * Reading over the 'Trigger Framework in Salesforce' article I implemented the SFDC trigger framework class to remove all
  * the code from my trigger and into a trigger handler.
  *
  * I have not fully looked over all the code within that class but will be doing so over the period of this course and beyond to ensure I fully
  * understand the framework.
  *
  * RESOURCES: 
  * - Trigger Framework in Salesforce: https://www.apexhours.com/trigger-framework-in-salesforce/
  * - SFDC Trigger Framework: https://github.com/kevinohara80/sfdc-trigger-framework/tree/master
  *
  * author: Terrence Gonsalves
  */
public with sharing class AccountTriggerHandler extends TriggerHandler {
    private List<Account> newAcct;
    private List<Account> oldAcct;
    private Map<Id, Account> newAcctMap;
    private Map<Id, Account> oldAcctMap;

    public AccountTriggerHandler() {
        this.oldAcct = (List<Account>) Trigger.old;
        this.newAcct = (List<Account>) Trigger.new;
        this.newAcctMap = (Map<Id, Account>) Trigger.newMap;
        this.oldAcctMap = (Map<Id, Account>) Trigger.oldMap;
    }

    public override void beforeInsert() {
        for (Account a : newAcct) {
            
            /*Question #1*/

            // check if Type is empty
            if (a.Type == '' || a.Type == null) {
                a.Type = 'Prospect';
            }

            /*Questions #2*/

            // copy shipping to billing address checking fields are not empty
            if (a.ShippingStreet != null || a.ShippingStreet != '') {
                a.BillingStreet = a.ShippingStreet;
            }

            if (a.ShippingCity != null || a.ShippingCity != '') {
                a.BillingCity = a.ShippingCity;
            }

            if (a.ShippingPostalCode != null || a.ShippingPostalCode != '') {
                a.BillingPostalCode = a.ShippingPostalCode;
            }

            if (a.ShippingState != null || a.ShippingState != '') {
                a.BillingState = a.ShippingState;
            }

            if (a.ShippingCountry != null || a.ShippingCountry != '') {
                a.BillingCountry = a.ShippingCountry;
            }

            /*Questions #3*/

            if (!String.isBlank(a.Phone) && !String.isBlank(a.Fax) && !String.isBlank(a.Website)) {
                a.Rating = 'Hot';
            }
        }
    }

    public override void afterInsert() {

        /*Question #4*/

        List<Contact> contactObjects = new List<Contact>();

        for (Account a : newAcct) {
            Contact con = new Contact(LastName = 'DefaultContact', Email = 'default@email.com', AccountId = a.Id);
            contactObjects.add(con);
        }

        insert contactObjects;
    }
}
