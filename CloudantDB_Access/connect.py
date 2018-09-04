from cloudant.client import Cloudant
from cloudant.error import CloudantException
from simple_salesforce import Salesforce

sf = Salesforce(username='zexing@nyu.edu', password='***', security_token='p59BlagIhfIvUYOMols0aktca')
records = sf.query("SELECT Id, Name, Content__c FROM Note__c")
records = records['records']
uploadData = []
for record in records:
    data = [record["Name"], record["Content__c"]]
    uploadData.append(data)
client = Cloudant("c8e8c***bluemix", "1469d4cb***", url="https://c8e8c***.cloudant.com")
client.connect()

databaseName = "note"
# Delete old
try :
    client.delete_database(databaseName)
except CloudantException:
    print "There was a problem deleting '{0}'.\n".format(databaseName)
else:
    print "'{0}' successfully deleted.\n".format(databaseName)

myDatabase = client.create_database(databaseName)

if myDatabase.exists():
    print "'{0}' successfully created.\n".format(databaseName)

# Update database
for document in uploadData:
    # Retrieve the fields in each row.
    title = document[0]
    content = document[1]

    # Create a JSON document that represents
    # all the data in the row.
    jsonDocument = {
        "title": title,
        "content": content,
    }

    # Create a document using the Database API.
    newDocument = myDatabase.create_document(jsonDocument)

    # Check that the document exists in the database.
    if newDocument.exists():
        print "Document '{0}' successfully created."

client.disconnect()