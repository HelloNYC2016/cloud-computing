from simple_salesforce import Salesforce
# retrive data from salesforce
sf = Salesforce(username='zexing@nyu.edu', password='****', security_token='p59BlagIhfIvUYOMols0aktca')
records = sf.query("SELECT Id, Name, Content__c FROM Note__c")
records = records['records']
uploadData = []
for record in records:
    data = [record["Name"], record["Content__c"]]
    uploadData.append(data)

print uploadData
