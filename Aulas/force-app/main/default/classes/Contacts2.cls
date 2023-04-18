public with sharing class Contacts2 {
    public static List<Contact> createMembers(String firstName, String lastName) {
        List<Contact> members = new List<Contact>();

        for (Account family : [SELECT Id, Name FROM Account WHERE Name IN :getFamilies(lastName)]) {
            members.add(new Contact(FirstName = firstName, LastName = lastName, AccountId = family.Id));
        }

        return members;
    }

    private static Contact generateRecord(String firstName, String lastName, Id familyId) {
        return new Contact(FirstName = firstName, LastName = lastName, AccountId = familyId);
    }

    private static List<String> getFamilies(String lastName) {
        List<String> families = new List<String>();
        List<String> lastNames = lastName.split(' ');
        Integer lastNamesQuantity = lastNames.size();

        for (Integer i = 0; i < lastNamesQuantity; i++) {
            families.addAll(buildLastNames(lastNames, lastNamesQuantity, i));
        }

        return families;
    }

    private static List<String> buildLastNames(List<String> lastNames, Integer lastNamesQuantity, Integer startingIndex) {
        List<String> lastNameTemp = new List<String>();
        String currentLastName = '';
        for (Integer j = startingIndex; j < lastNamesQuantity; j++) {
            if (j > startingIndex) {
                currentLastName += ' ';
            }
            currentLastName += lastNames[j];
            lastNameTemp.add(currentLastName);
        }
        return lastNameTemp;
    }
}