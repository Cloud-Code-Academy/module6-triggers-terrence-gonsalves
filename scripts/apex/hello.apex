// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

Account bankingAccts = [select Id from Account where Industry = 'Banking'];
List<Opportunity> bankingOpps = [select Id, Name, StageName from Opportunity where AccountId = :bankingAccts.Id];

List<Opportunity> closedWonOppsOnly = new List<Opportunity>();

for (Opportunity o : bankingOpps) {
    if (o.StageName == 'Closed Won') {
        closedWonOppsOnly.add(o);
    }
}

System.debug(closedWonOppsOnly);