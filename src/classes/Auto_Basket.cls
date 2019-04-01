public with sharing class Auto_Basket {
    @AuraEnabled
    public static List<OrderItem> getFromBasket() {
        List<OrderItem> productsInBasket = [SELECT Product2Id, Product2.Name, Quantity, UnitPrice, TotalPrice, Order.Status, Order.TotalAmount
            FROM OrderItem
            WHERE Order.OwnerId = :UserInfo.getUserId()
            AND Order.Status = :getCustomSettingValue('Status_Basket')];

        return productsInBasket;
    }

    @AuraEnabled
    public static List<Order> makeOrder() {
        List<Order> orders = [SELECT Id, Status FROM Order WHERE OwnerId = :UserInfo.getUserId() AND Status = :getCustomSettingValue('Status_Basket')];
         if(!orders.isEmpty()) {
             orders.get(0).Status = 'In_Progress';

             update orders.get(0);
         }


        return orders;
    }

    public static String getCustomSettingValue(String csName) {
        Auto_Part__c csItem = Auto_Part__c.getInstance(csName);
        if (csItem == null) {
            return null;
        }

        return csItem.Value__c;
    }
}