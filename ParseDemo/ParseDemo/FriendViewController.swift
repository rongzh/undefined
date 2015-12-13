//
//  HomeViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/31/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse

class FriendViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var friendname: UITextField!
    
    @IBOutlet weak var SearchBar: UISearchBar!
    var searchActive : Bool = false
    
    
    @IBOutlet weak var myTable: UITableView!
    var friendsArray:[String] = [String]()
    
    var SearchFriendsList=[String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
        SearchBar.delegate = self;
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
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(friendsArray.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.myTable.reloadData()
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        searchActive = false;
        friendsArray.removeAll();
        myTable.reloadData()
        SearchBar.resignFirstResponder()
//        let nameQuery = PFQuery(className: "Users")
//        nameQuery.whereKey("username",containsString:searchBar.text)
        let fQuery = PFQuery(className: "Friends")
        let current = PFUser.currentUser()!.username
        fQuery.whereKey("fid1", containsString: searchBar.text)
        fQuery.whereKey("fid2",  equalTo: current!)
       // var existf=[String]()
        
        fQuery.findObjectsInBackgroundWithBlock{
            (results:[AnyObject]?,error:NSError?) -> Void in
            if error != nil
            {}
            if let objects = results as? [PFObject]{
                for object in objects{
                    let name = object.objectForKey("fid1") as! String
                    self.friendsArray.append(name)
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
        searchActive = false;
        friendsArray.removeAll(keepCapacity: false)
        retrieveFriends();
        myTable.reloadData()
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
