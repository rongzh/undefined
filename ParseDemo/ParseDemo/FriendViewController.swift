//
//  HomeViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/31/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse

class FriendViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate{
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var friendname: UITextField!
    
    @IBOutlet weak var myTable: UITableView!
    var friendsArray:[String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func retrieveFriends(){
        var query:PFQuery = PFQuery(className: "User")
        
        query.getObjectInBackgroundWithId("lZ4eHLhJex") {
            (fid1: PFObject?, error: NSError?) -> Void in
            if error == nil && fid1 != nil {
                self.friendname.text = "fid1";
            } else {
                print(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
