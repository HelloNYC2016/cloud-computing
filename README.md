Thie project will integrate data from many heterogenous cloud systems and a mobile system.


1. PAAS: Use Salesforce maintain a custom object: Note
2. SAAS: Use zohoCRM to maintain data exported from salesforce.
3. IAAS: Use Heroku to store a synchronous replication of Note.
4. NoSql: Use IBM cloudant as a document oriented database that has a copy of all the data and is kept up to date.
5. Mobile app: Develop an ios app using Salesforce mobile SDK, enable users to Login(Anthorize). Then they can create, read, update and delete note on their iphones. The Changes of data will be reflected in all systems, synchronous or Asynchronous.