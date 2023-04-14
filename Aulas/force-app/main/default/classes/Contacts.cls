public with sharing class Contacts {
    public static List<Contact> createMembers(String firstName, String lastName) {
        return null;
    }

    public static List<String> getFamilies(String lastName) {
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
