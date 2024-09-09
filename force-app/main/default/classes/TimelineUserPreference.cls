public without sharing class TimelineUserPreference {
    
    @AuraEnabled(cacheable=true)
    public static String getUserPreferences(String type, String key) {
        // Retrieve preferences for the current user
        String userId = UserInfo.getUserId();
        Timeline_User_Preference__c existingPref = [
            SELECT  timeline__Value__c 
            FROM    Timeline_User_Preference__c 
            WHERE   CreatedById = :userId 
            AND     timeline__Type__c = :type
            AND     timeline__Key__c = :key 
            LIMIT   1
        ];
        
        if (existingPref != null) {
            return existingPref.timeline__Value__c;
        } else {
            return null;
        }
    }

    @AuraEnabled
    public static void saveUserPreference(String type, String key, String value) {
        String userId = UserInfo.getUserId();
        
        // Check if the preference already exists
        List<Timeline_User_Preference__c> existingPref = new List<Timeline_User_Preference__c>();
        existingPref = [
                            SELECT  Id 
                            FROM    Timeline_User_Preference__c 
                            WHERE   CreatedById = :userId 
                            AND     timeline__Type__c = :type
                            AND     timeline__Key__c = :key 
                            LIMIT   1
                        ];
        
        if (existingPref.size() > 0) {
            // Update existing preference
            existingPref[0].timeline__Value__c = value;
            update existingPref;
        } else {
            // Create a new preference
            Timeline_User_Preference__c newPref = new Timeline_User_Preference__c();
            newPref.timeline__Key__c = key;
            newPref.timeline__Type__c = 'Filter';
            newPref.timeline__Value__c = value;
            insert newPref;
        }
    }

    @AuraEnabled
    public static void deleteUserPreference(String type, String key) {
        String userId = UserInfo.getUserId();
        
        // Find and delete the preference
        Timeline_User_Preference__c prefToDelete = [
            SELECT  Id 
            FROM    Timeline_User_Preference__c 
            WHERE   CreatedById = :userId
            AND     timeline__Type__c = :type 
            AND     timeline__Key__c = :key 
            LIMIT   1
        ];
        
        if (prefToDelete != null) {
            delete prefToDelete;
        }
    }
}
