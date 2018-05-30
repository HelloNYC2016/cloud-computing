//
//  ModifityNoteViewController.swift
//  ConnectedApp
//
//  Created by 程泽星 on 12/7/17.
//  Copyright © 2017 Salesforce. All rights reserved.
//

import UIKit

class ModifyNoteViewController: UIViewController {
    var titleToDisplay: String = ""
    var contentToDisplay: String = ""
    var idReceive: String = ""
    
    
    @IBOutlet weak var titleDisplay: UITextField!
    @IBOutlet weak var contentDisplay: UITextView!
    
    override func viewDidLoad() {
        titleDisplay.text = titleToDisplay
        contentDisplay.text = contentToDisplay
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "modifySegue" {
            titleToDisplay = titleDisplay.text!
            contentToDisplay = contentDisplay.text!
            
        }
    }

}
