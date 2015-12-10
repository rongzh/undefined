//
//  HomeViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/31/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse

class FriendViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var friendname: UITextField!
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    
    
    @IBOutlet weak var myTable: UITableView!
    var friendsArray:[String] = [String]()
    
    var SearchFriendsList=[String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
        retrieveFriends()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return friendsArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let myCell = self.myTable.dequeueReusableCellWithIdentifier("Cell",forIndexPath: indexPath)
        let fQuery = PFQuery(className: "Card")
        fQuery.whereKey("userid",  equalTo: friendsArray[indexPath.row])
        let scoreArrary = fQuery.findObjects()
        var c = scoreArrary!.count;
        myCell.textLabel?.text = friendsArray[indexPath.row] + " (" + String(c) + " Card)"
        return myCell
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
        
        //var query = PFQuery(className: "User")
        
        //query.getObjectInBackgroundWithId("lZ4eHLhJex") {
          //  (fid1: PFObject?, error: NSError?) -> Void in
            //if error == nil && fid1 != nil {
              //  self.friendname.text = "fid1";
            //} else {
              //  print(error)
           // }
       // }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        myTable.reloadData()
        SearchBar.resignFirstResponder()
        let nameQuery = PFQuery(className: "Users")
        nameQuery.whereKey("username",containsString:searchBar.text)
        let fQuery = PFQuery(className: "Friends")
        let current = PFUser.currentUser()!.username
        fQuery.whereKey("fid1", containsString: searchBar.text)
        fQuery.whereKey("fid2",  equalTo: current!)
        var existf=[String]()
        
        fQuery.findObjectsInBackgroundWithBlock{
            (results:[AnyObject]?,error:NSError?) -> Void in
            if error != nil
            {}
            if let objects = results as? [PFObject]{
                for object in objects{
                    let name = object.objectForKey("fid1") as! String
                    existf.append(name)
                }
            }
            
        }
        
        let query = PFQuery.orQueryWithSubqueries([nameQuery])
        
        query.findObjectsInBackgroundWithBlock{
            (results:[AnyObject]?,error:NSError?) -> Void in
            
            if error != nil
            {
                let myAlert = UIAlertController(title:"Alert",message:error?.localizedDescription,preferredStyle: UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title:"Ok",style:UIAlertActionStyle.Default,handler: nil)
                
                myAlert.addAction(okAction)
                self.presentViewController(myAlert,animated:true,completion:nil)
                
                return
            }
            
            if let objects = results as? [PFObject]{
                self.SearchFriendsList.removeAll(keepCapacity: false)
                
                for object in objects{
                    let name = object.objectForKey("username") as! String
                    if (!existf.contains(name)){
                        self.SearchFriendsList.append(name)
                    }
                }
                
                dispatch_async(dispatch_get_main_queue()){
                    self.myTable.reloadData()
                    self.SearchBar.resignFirstResponder()
                }
            }
        }
        
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar){
        SearchBar.resignFirstResponder()
        SearchBar.text=""
        SearchBar.setShowsCancelButton(false, animated: true)
        
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
