public with sharing class Utils {
    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }

    public static Map<Id, SObject> buildMapByIdField(List<SObject> records, Schema.SObjectField field) {
        Map<Id, SObject> var = new Map<Id, SObject>();

        for (SObject record : records) {
            var.put(Id.valueOf(String.valueOf(record.get(field))), record);
        }

        return var;
    }
}