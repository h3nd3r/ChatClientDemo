//
//  LoginViewController.swift
//  ChatClient
//
//  Created by Joshua Escribano on 10/27/16.
//  Copyright © 2016 JoshuaSara. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logIn(_ sender: AnyObject) {
        PFUser.logInWithUsername(inBackground: email.text!, password: password.text!)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationVC = storyboard.instantiateViewController(withIdentifier: "ChatNavigationController")
        present(navigationVC, animated: true, completion: nil)
    }

    @IBAction func signUp(_ sender: AnyObject) {
        let user = PFUser()
        user.username = email.text
        user.password = password.text
        
        
        
        user.signUpInBackground {
            (succeeded: Bool, error: Error?) -> Void in
            if error != nil {
                let alertController = UIAlertController(title: "Error signing up", message: error?.localizedDescription, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // handle response here.
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
            } else {
                // Hooray! Let them use the app now.
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationVC = storyboard.instantiateViewController(withIdentifier: "ChatNavigationController")
                self.present(navigationVC, animated: true, completion: nil)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
