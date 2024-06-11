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
}