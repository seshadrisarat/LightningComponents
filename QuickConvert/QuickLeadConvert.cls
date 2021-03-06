public class QuickLeadConvert {
    public static Boolean isConverted;
    
    @AuraEnabled
    public static String convertIt(String recordId) {
        Lead lead = [SELECT Id ,LastName,Company,Status, OwnerId,
                     ConvertedContactId,ConvertedAccountId,ConvertedOpportunityId  
                     FROM Lead WHERE Id =:recordId LIMIT 1];
        isConverted = false;
        Database.LeadConvert ldconvert = new Database.LeadConvert(); 
        ldconvert.setLeadId(lead.id);
        ldconvert.setOwnerId(lead.OwnerId);
        ldconvert.ConvertedStatus = 'Closed - Converted';
        ldconvert.setSendNotificationEmail(true);
        try{
            
            Database.LeadConvertResult result = Database.convertLead(ldconvert); 
            System.Debug('Conversion Result: ' + result.isSuccess());
            if(result.isSuccess()){
                isConverted = true;
               
               //ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), UserInfo.getUserId(), ConnectApi.FeedElementType.FeedItem, 'Lead '+ lead.LastName+' is Converetd Successfully!');
            }
            
        }
        
        catch(DmlException e){
            
            System.debug(e.getCause()); 
        }
        Lead convLead = [SELECT Id,ConvertedContactId,ConvertedAccountId,ConvertedOpportunityId  
                         FROM Lead WHERE Id =:recordId LIMIT 1];
        System.Debug(convLead.ConvertedAccountId);
        return String.valueOf(convLead.ConvertedAccountId);
    }
}