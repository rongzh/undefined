//
//  HomeViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/31/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse

class AddFriendViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    @IBOutlet weak var myTable: UITableView!
   
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    var searchResults=[String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "viewTblCell", bundle: nil)
        myTable.registerNib(nib,forCellReuseIdentifier:"cell")
        
        
        // fill the cache of a user's followees
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return searchResults.count
    }
   
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let myCell:TblCell = self.myTable.dequeueReusableCellWithIdentifier("cell",forIndexPath: indexPath) as! TblCell
        
        myCell.fname!.text = searchResults[indexPath.row]
         myCell.textLabel!.adjustsFontSizeToFitWidth = true;
        
        return myCell
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        mySearchBar.resignFirstResponder()
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
                self.searchResults.removeAll(keepCapacity: false)
                
                for object in objects{
                    let name = object.objectForKey("username") as! String
                    if (!existf.contains(name)){
                        self.searchResults.append(name)
                    }
                }
                
                dispatch_async(dispatch_get_main_queue()){
                    self.myTable.reloadData()
                    self.mySearchBar.resignFirstResponder()
                }
            }
        }
        
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar){
        mySearchBar.resignFirstResponder()
        mySearchBar.text=""
        mySearchBar.setShowsCancelButton(false, animated: true)

    }

    @IBAction func refreshButtonTapped(sender: AnyObject) {
        mySearchBar.resignFirstResponder()
        mySearchBar.text=""
        mySearchBar.setShowsCancelButton(false, animated: true)
        searchResults.removeAll(keepCapacity: false)
        myTable.reloadData()
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
