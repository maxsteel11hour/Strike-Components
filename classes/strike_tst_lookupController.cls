/* --------------------------------------------------
Strike by Appiphony

Version: 0.10.0
Website: http://www.lightningstrike.io
GitHub: https://github.com/appiphony/Strike-Components
License: BSD 3-Clause License
-------------------------------------------------- */
/*
@Author : Prashant Menon
@name : strike_lookupController
@CreateDate : 04-Nov-2019
@Description : 
@Version : 1.0
@reference : N/A
@Modification Log :
Developer             Date                    Description
*/
@isTest(SeeAllData=false)
private class strike_tst_lookupController {

    @isTest static void test_getRecentRecords() {
        String jsonString = '{"searchField":"Name", "object": "Account", "filter": "Name = \'Test Account\'"}';

        Test.startTest();
        	String responseString = strike_lookupController.getRecentRecords(jsonString);
        Test.stopTest();

        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
        Map<string, Object> results = (Map<String, Object>)response.get('results');

        System.assertEquals(true, response.get('isSuccess'));
    }

    @isTest static void test_getRecordLabel() {
        Account a = new Account(Name='Test Account');
        insert a;

        String jsonString = '{"searchField":"Name", "object": "Account", "filter": "Name = \'Test Account\'"}';

        Test.startTest();
        String responseString = strike_lookupController.getRecordLabel(jsonString);
        Test.stopTest();

        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
        Map<string, Object> results = (Map<String, Object>)response.get('results');
        String objectLabel = String.valueOf(results.get('objectLabel'));

        System.assertEquals('Account', objectLabel);
    }

    @isTest static void test_getData() {
        Account a = new Account(Name='Test Account');
        insert a;

        String jsonString = '{"searchField":"Name", "object": "Account", "filter": "Name = \'Test Account\'", "order": "Name", "limit": "5", "searchTerm": "Test"}';

        Test.startTest();
        String responseString = strike_lookupController.getRecords(jsonString);
        Test.stopTest();

        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
        Map<string, Object> results = (Map<String, Object>)response.get('results');
        List<Object> data =(List<Object>)results.get('data');

        System.assertEquals(1, data.size());

        Map<String, Object> record = (Map<String, Object>)data.get(0);

        System.assertEquals(a.Id, record.get('value'));
    }

    @isTest static void test_getData_subtitleField() {
        Account a = new Account(Name='Test Account');
        insert a;

        String jsonString = '{"searchField":"Name", "subtitleField": "Name", "object": "Account", "filter": "Name = \'Test Account\'", "searchTerm": "Test"}';

        Test.startTest();
        String responseString = strike_lookupController.getRecords(jsonString);
        Test.stopTest();

        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
        Map<string, Object> results = (Map<String, Object>)response.get('results');
        List<Object> data =(List<Object>)results.get('data');

        System.assertEquals(1, data.size());

        Map<String, Object> record = (Map<String, Object>)data.get(0);

        System.assertEquals(a.Id, record.get('value'));
    }

    @isTest static void test_getData_addressField() {
        Account a = new Account(
            Name='Test Account',
            BillingStreet='Test Street',
            BillingCity='Test City',
            BillingState='Test State',
            BillingCountry='Test Country',
            BillingPostalCode='Test Postal Code');
        insert a;

        String jsonString = '{"searchField":"Name", "subtitleField": "BillingAddress", "object": "Account", "filter": "Name = \'Test Account\'", "searchTerm": "Test"}';

        Test.startTest();
        String responseString = strike_lookupController.getRecords(jsonString);
        Test.stopTest();

        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
        Map<string, Object> results = (Map<String, Object>)response.get('results');
        List<Object> data =(List<Object>)results.get('data');

        System.assertEquals(1, data.size());

        Map<String, Object> record = (Map<String, Object>)data.get(0);

        System.assertEquals(a.Id, record.get('value'));
    }

    @isTest static void test_getData_reference() {
        Account a = new Account(Name='Test Account');
        insert a;

        Contact c = new Contact(
            LastName='Contact',
            FirstName='Test',
            AccountId = a.Id);
        insert c;

        String jsonString = '{"searchField":"FirstName", "subtitleField": "Account.Name", "object": "Contact", "filter": "Name = \'Test Contact\'", "searchTerm": "Test"}';

        Test.startTest();
        String responseString = strike_lookupController.getRecords(jsonString);
        Test.stopTest();

        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
        Map<string, Object> results = (Map<String, Object>)response.get('results');
        List<Object> data =(List<Object>)results.get('data');

        System.assertEquals(1, data.size());

        Map<String, Object> record = (Map<String, Object>)data.get(0);

        System.assertEquals(c.Id, record.get('value'));
    }
    
    @isTest static void test_getData_SOSL() {
        Account a = new Account(Name='Test Account');
        insert a;

        String jsonString = '{"searchField":"Name", "object": "Account", "filter": "Name = \'Test Account\'", "order": "Name", "limit": "5", "searchTerm": "Test", "flagSOSL": "true"}';

        //SOSL in Test returns Empty
        //Source: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_testing_SOSL.htm
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = a.id;
//System.Debug('static -'+fixedSearchResults[0] );       
        Test.setFixedSearchResults(fixedSearchResults);
//System.Debug([FIND 'Test' IN ALL FIELDS RETURNING Account(id, name)]);
        
        Test.startTest();
            String responseString = strike_lookupController.getRecords(jsonString);
//System.Debug('Response ='+responseString);
        Test.stopTest();

        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
        Map<string, Object> results = (Map<String, Object>)response.get('results');
        List<Object> data =(List<Object>)results.get('data');

        System.assertEquals(1, data.size());
        Map<String, Object> record = (Map<String, Object>)data.get(0);
        System.assertEquals(a.Id, record.get('value'));
    }

}
/* --------------------------------------------------
Copyright 2017 Appiphony, LLC

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the 
following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following 
disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following 
disclaimer in the documentation and/or other materials provided with the distribution.
3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote 
products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, 
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-------------------------------------------------- */