/**
  * I did not like how I set up my Triggers so I looked into Trigger Framework and came across the SFDC trigger framework.
  * Reading over the 'Trigger Framework in Salesforce' article I implemented the SFDC trigger framework class to remove all
  * the code from my trigger and into a trigger handler. (No need to recreate the wheel when it works perfectly).
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
public with sharing class OpportunityTriggerHandler extends TriggerHandler {
    private List<Opportunity> newOpp;
    private List<Opportunity> oldOpp;
    private Map<Id, Opportunity> newOppMap;
    private Map<Id, Opportunity> oldOppMap;

    public OpportunityTriggerHandler() {
        this.oldOpp = (List<Opportunity>) Trigger.old;
        this.newOpp = (List<Opportunity>) Trigger.new;
        this.newOppMap = (Map<Id, Opportunity>) Trigger.newMap;
        this.oldOppMap = (Map<Id, Opportunity>) Trigger.oldMap;
    }

    public override void beforeUpdate() {

        /* Question #5 */

        for (Opportunity o : newOpp) {
            if (o.Amount < 5000) {
                o.addError('Opportunity amount must be greater than 5000');
            }
        }

        /* Question #7 */

        Set<Id> accountIds = new Set<Id>();

        for (Opportunity o : newOpp) {
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
            for (Opportunity o : newOpp) {
                o.Primary_Contact__c = accountToContactMap.get(o.AccountId).Id;
            }
            for (Opportunity o : newOpp) {
                if (o.AccountId != null && o.Primary_Contact__c == null) {
                    o.Primary_Contact__c = accountToContactMap.get(o.AccountId).Id;
                }
            }
        }
    }

    public override void beforeDelete() {

        /* Question #6 */

        Set<Id> accountIds = new Set<Id>();

        // collect Account IDs for Opportunities that are 'Closed Won'
        for (Opportunity o : oldOpp) {
            if (o.StageName == 'Closed Won' && o.AccountId != null) {
                accountIds.add(o.AccountId);
            }
        }
            
        if (!accountIds.isEmpty()) {
            Map<Id, Account> accountMap = new Map<Id, Account>([select Id, Industry from Account where Id in :accountIds]);
            
            for (Opportunity o : oldOpp) {
                if (o.StageName == 'Closed Won' && o.AccountId != null) {
                    Account a = accountMap.get(o.AccountId);
                    
                    if (a != null && a.Industry == 'Banking') {
                        o.addError('Cannot delete closed opportunity for a banking account that is won');
                    }
                }
            }
        }
    }
}