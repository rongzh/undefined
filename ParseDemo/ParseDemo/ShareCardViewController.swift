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
        //print(selectedRowSets)
    }
    var cardId = String()
    var foldername = String()
    @IBOutlet weak var myTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
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
             //selectedRows.addIndex(indexPath.row);
        }
        else{
            myCell.accessoryType = UITableViewCellAccessoryType.None;
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
            //selectedRows.removeIndex(indexPath.row)
        }
        else{
            myCell!.accessoryType = UITableViewCellAccessoryType.Checkmark;
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
        if segue.identifier == "CardListViewController"
        {
            let detailViewController = ((segue.destinationViewController) as! CardListViewController)
            detailViewController.foldername = foldername
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
