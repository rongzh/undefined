//
//  SignUpViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/30/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signUpAction(sender: AnyObject) {
        
        let username = self.usernameField.text
        let password = self.passwordField.text
        let email = self.emailField.text
        let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        // Validate the text fields
        if username!.characters.count < 5 {
            let alert = UIAlertView(title: "Invalid", message: "Username must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if password!.characters.count < 8 {
            let alert = UIAlertView(title: "Invalid", message: "Password must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if email!.characters.count < 8 {
            let alert = UIAlertView(title: "Invalid", message: "Please enter a valid email address", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else {
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            let newUser = PFUser()
            
            newUser.username = username
            newUser.password = password
            newUser.email = finalEmail
            
            let newUsers = PFObject(className: "Users")
            newUsers.setObject(username!, forKey: "username")
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                spinner.stopAnimating()
                if ((error) != nil) {
                    let alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    
                } else {
                    newUsers.saveInBackgroundWithBlock{
                        (success: Bool, error: NSError?) -> Void in
                        
                    }
                    
                    let newfolder = PFObject(className: "Folder")
                    let current = PFUser.currentUser()!.username
                    newfolder["userid"] = current
                    newfolder["fname"] = "My First Folder"
                    newfolder.saveInBackgroundWithBlock{
                        (success:Bool, error:NSError?) -> Void in
                        if(success){
                            let alert = UIAlertView(title: "Success", message: "First Folder Created", delegate: self, cancelButtonTitle: "OK")
                            alert.show()
                            //NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
                            //var myCustomViewController: FolderViewController = FolderViewController(nibName: nil, bundle: nil)
                            //myCustomViewController.viewWillAppear(ani)
                            //myCustomViewController.refreshUI()
                            
                        }
                        else{
                            let alert = UIAlertView(title: "Oops", message: "Something is wrong...", delegate: self, cancelButtonTitle: "OK")
                            alert.show()
                        }
                        
                    }
                    
                    
                    
                    let alert = UIAlertView(title: "Success", message: "Signed Up", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DashBoard") 
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                }
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
