//
//  HomeViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/31/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse

class ShareCardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
     var friendsArray:[String] = [String]()
    //var selectedRowSets = [NSMutableIndexSet]()
    @IBAction func ShareCalled(sender: AnyObject) {
        var name = String()
        for i in checkornot{
            if i == true {
                print("enter the condition")
               name = friendsArray[checkornot.indexOf(i)!]
                let query = PFQuery(className: "Card")
                query.whereKey("objectId", equalTo:cardId)
                
                let scoreArrary = query.findObjects()
                
                let query1 = PFQuery(className: "Folder")
                query1.whereKey("userid", equalTo:name)
                query1.whereKey("fname", equalTo:"Shared to me")
                
                let scoreArrary1 = query1.findObjects()
                if scoreArrary1!.count == 0 {
                    let newfolder = PFObject(className: "Folder")
                    newfolder["userid"] = name
                    newfolder["fname"] = "Shared to me"
                    newfolder.saveInBackgroundWithBlock{
                        (success:Bool, error:NSError?) -> Void in
                        if(success){
                        
                        }
                        else{
                            
                        }
                        
                    }
                }
                var newCard = PFObject(className: "Card")
                var current = PFUser.currentUser()!.username
                
                
                newCard["def"] = scoreArrary![0].objectForKey("def")
                newCard["back"] = scoreArrary![0].objectForKey("back")
                newCard["userid"] = name
                newCard["degree"] = "1 (brand new)"
                newCard["foldername"] = "Shared to me"
                newCard.saveInBackgroundWithBlock{
                    (success:Bool, error:NSError?) -> Void in
                    if(success){
                        let alert = UIAlertView(title: "Success", message: "Card Shared", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                    }
                    else{
                        let alert = UIAlertView(title: "Oops1", message: "Something is wrong...", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                    }
                }
            }// if true
     
        }//for
    }
    var checkornot:[Bool] = [Bool]()
    @IBOutlet weak var BackButton: UIBarButtonItem!
    var cardId = String()
    var foldername = String()
    @IBOutlet weak var myTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
        print("first get in : folder name is : ")
        print(foldername)
        retrieveFriends()
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return friendsArray.count
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var lastSelectedIndexPath = NSIndexPath(forRow: -1, inSection: 0)
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let myCell = self.myTable.dequeueReusableCellWithIdentifier("Cell",forIndexPath: indexPath)
        let fQuery = PFQuery(className: "Card")
        fQuery.whereKey("userid",  equalTo: friendsArray[indexPath.row])
        let scoreArrary = fQuery.findObjects()
        var c = scoreArrary!.count;
        myCell.textLabel?.text = friendsArray[indexPath.row] + " (" + String(c) + " Card)"
        //let selectedRows=self.selectedRowSets[indexPath.section]
        if myCell.selected{
            myCell.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.checkornot.append(true)
             //selectedRows.addIndex(indexPath.row);
        }
        else{
            myCell.accessoryType = UITableViewCellAccessoryType.None;
            self.checkornot.append(false)
            //selectedRows.removeIndex(indexPath.row)
        }
        
        
        return myCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let myCell = self.myTable.dequeueReusableCellWithIdentifier("Cell",forIndexPath: indexPath) as UITableViewCell
        //myCell.selected = true
        //let selectedRows=self.selectedRowSets[indexPath.section]
        let myCell = tableView.cellForRowAtIndexPath(indexPath)
        if (myCell!.accessoryType == UITableViewCellAccessoryType.Checkmark){
            myCell!.accessoryType = UITableViewCellAccessoryType.None
            self.checkornot[indexPath.row] = false
            //selectedRows.removeIndex(indexPath.row)
        }
        else{
            myCell!.accessoryType = UITableViewCellAccessoryType.Checkmark;
            self.checkornot[indexPath.row] = true
            //selectedRows.addIndex(indexPath.row);
        }
        
        
    }
    
    func retrieveFriends(){
        let fQuery = PFQuery(className: "Friends")
        let current = PFUser.currentUser()!.username
        fQuery.whereKey("fid1",  equalTo: current!)
        fQuery.findObjectsInBackgroundWithBlock{
            (results:[AnyObject]?,error:NSError?) -> Void in
            if error != nil
            {}
            if let objects = results as? [PFObject]{
                for object in objects{
                    let name = object.objectForKey("fid2") as! String
                    print(name)
                    self.friendsArray.append(name)
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.myTable.reloadData()
                })
            }
            
            
        }

    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CardListViewController1"
        {
            let detailViewController = ((segue.destinationViewController) as! CardListViewController)
            detailViewController.foldername = self.foldername
            print("we get here!!!!!this we are going back")
            print(foldername)
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
