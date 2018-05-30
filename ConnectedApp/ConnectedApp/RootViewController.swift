/*
 Copyright (c) 2015-present, salesforce.com, inc. All rights reserved.
 
 Redistribution and use of this software in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of
 conditions and the following disclaimer in the documentation and/or other materials provided
 with the distribution.
 * Neither the name of salesforce.com, inc. nor the names of its contributors may be used to
 endorse or promote products derived from this software without specific prior written
 permission of salesforce.com, inc.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import Foundation
import UIKit
import SalesforceSDKCore

class RootViewController : UITableViewController, SFRestDelegate
{
    var dataRows = [NSDictionary]()
    var titleToPass: String = "default"
    var contentToPass: String = ""
    var idToPass: String = ""
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Here we use a query that should work on either Force.com or Database.com
        let request = SFRestAPI.sharedInstance().request(forQuery:"SELECT Name, Content__c, Id FROM NOTE__c");
        SFRestAPI.sharedInstance().send(request, delegate: self);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancel(segue:UIStoryboardSegue){
        
    }
    //modify record
    @IBAction func modify(segue:UIStoryboardSegue){
        let modifyNoteVC = segue.source as! ModifyNoteViewController
        let title = modifyNoteVC.titleToDisplay
        let content = modifyNoteVC.contentToDisplay
        let noteId = modifyNoteVC.idReceive
        let request = SFRestAPI.sharedInstance().requestForUpdate(withObjectType: "Note__c", objectId: noteId, fields: ["Name" : title, "Content__c":content])
        SFRestAPI.sharedInstance().send(request, delegate: self)
    }
    //create record
    @IBAction func done(segue:UIStoryboardSegue){
        let noteDetailVC = segue.source as! NoteDetailViewController
        let title = noteDetailVC.titleText
        let content = noteDetailVC.contentText
        let request = SFRestAPI.sharedInstance().requestForCreate(withObjectType: "Note__c", fields: ["Name" : title, "Content__c":content])
        SFRestAPI.sharedInstance().send(request, delegate: self);
    }
    
    // MARK: - SFRestDelegate
    func request(_ request: SFRestRequest, didLoadResponse jsonResponse: Any)
    {
            self.dataRows = (jsonResponse as! NSDictionary)["records"] as! [NSDictionary]
            SFSDKLogger.sharedDefaultInstance().log(type(of:self), level:.debug, message:"request:didLoadResponse: #records: \(self.dataRows.count)")
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
    }
    
    func request(_ request: SFRestRequest, didFailLoadWithError error: Error)
    {
        SFSDKLogger.sharedDefaultInstance().log(type(of:self), level:.debug, message:"didFailLoadWithError: \(error)")
        // Add your failed error handling here
    }
    
    func requestDidCancelLoad(_ request: SFRestRequest)
    {
        SFSDKLogger.sharedDefaultInstance().log(type(of:self), level:.debug, message:"requestDidCancelLoad: \(request)")
        // Add your failed error handling here
    }
    
    func requestDidTimeout(_ request: SFRestRequest)
    {
        SFSDKLogger.sharedDefaultInstance().log(type(of:self), level:.debug, message:"requestDidTimeout: \(request)")
        // Add your failed error handling here
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataRows.count
    }
    //view record detail
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "modifySegue") {
            let viewController = segue.destination as! ModifyNoteViewController
            let cell = sender as? UITableViewCell
            let indexPath = tableView.indexPath(for: cell!)!
            let obj = dataRows[(indexPath.row)]
            titleToPass = obj["Name"] as! String
            contentToPass = obj["Content__c"] as! String
            idToPass = obj["Id"] as! String
            viewController.titleToDisplay = titleToPass
            viewController.contentToDisplay = contentToPass
            viewController.idReceive = idToPass
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "titleCell"
        // Dequeue or create a cell of the appropriate type.
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier:cellIdentifier)
        if (cell == nil)
        {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }

        // Configure the cell to show the data.
        let obj = dataRows[indexPath.row]
        cell!.textLabel!.text = obj["Name"] as? String
        
        // This adds the arrow to the right hand side.
       // cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell!
    }
    //delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let obj = dataRows[indexPath.row]
        let id = obj["Id"] as! String
        let request = SFRestAPI.sharedInstance().requestForDelete(withObjectType: "Note__c", objectId: id)
        SFRestAPI.sharedInstance().send(request, delegate: self)

        if editingStyle == .delete {
            self.dataRows.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
