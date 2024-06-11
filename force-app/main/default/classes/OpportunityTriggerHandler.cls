public with sharing class OpportunityTriggerHandler {
    private Boolean triggerIsExecuting;
    private Integer triggerSize;

    public OpportunityTriggerHandler(Boolean triggerIsExecuting, Integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeUpdate(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<ID, SObject> oldOpportunityMap, Map<ID, SObject> newOpportunityMap) {
        for (Opportunity o : newOpportunities) {
            if (o.Amount < 5000) {
                o.addError('Opportunity amount must be greater than 5000');
            }
        }
    }

    public void beforeDelete(List<Account> oldAccounts, Map<ID, SObject> oldAccountMap) {
        Account bankingAccts = [select Id from Account where Industry = 'Banking'];

        /*for (Opportunity o : oldAccounts) {
            if (o.AccountId == bankingAccts.Id && o.StageName == 'Closed Won') {
                o.addError('Cannot delete closed opportunity for a banking account that is won');
            }
        }*/
    }
}