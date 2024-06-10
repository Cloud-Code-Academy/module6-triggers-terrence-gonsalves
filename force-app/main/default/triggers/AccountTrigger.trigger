trigger AccountTrigger on Account (before insert) {
    if (trigger.isInsert) {
        for (Account a : trigger.new) {
            
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
}