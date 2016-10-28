//
//  ChatViewController.swift
//  ChatClient
//
//  Created by Joshua Escribano on 10/27/16.
//  Copyright © 2016 JoshuaSara. All rights reserved.
//

import UIKit
import Parse

class Message: Any {
    var text: String
    var sender: String
    init(text:String, sender:String) {
        self.text = text
        self.sender = sender
    }
}

class ChatViewController: UIViewController {

    var messages:[PFObject] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        onTimer()
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
    }
    
    func onTimer() {
        let query = PFQuery(className:"MessageSF")
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) messages.")
                // Do something with the found objects
                self.messages.removeAll()
                if let objects = objects {
                    for object in objects {
                        print(object)
                        self.messages.append(object)
                    }
                }
                self.tableView.reloadData()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error?.localizedDescription)")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitMessage(_ sender: AnyObject) {
        let group = PFObject(className: "MessageSF")
        group["text"] = messageField.text
        group["user"] = PFUser.current()
        group.saveInBackground(block: {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                print("success")
            } else {
                print(error?.localizedDescription)
            }
        })
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageCell
        let user = messages[indexPath.row]["user"] as? PFUser
        user?.fetchIfNeededInBackground(block: {
            (object: PFObject?, error: Error?) -> Void in
            cell.messageLabel.text = (object as! PFUser).username
        })
        cell.messageLabel.text = messages[indexPath.row]["text"] as? String

        return cell
    }
    
}
