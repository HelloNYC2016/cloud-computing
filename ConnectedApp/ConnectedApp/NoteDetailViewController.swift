//
//  NoteDetailViewController.swift
//  ConnectedApp
//
//  Created by 程泽星 on 12/6/17.
//  Copyright © 2017 Salesforce. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController {
    
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteContent: UITextView!
    var titleText: String = ""
    var contentText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSegue" {
            titleText = noteTitle.text!
            contentText = noteContent.text!
            
        }
    }
    
}

