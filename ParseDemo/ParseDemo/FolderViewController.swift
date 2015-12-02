//
//  FolderViewController.swift
//  ParseDemo
//
//  Created by Rong Zhou on 12/2/15.
//  Copyright © 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse

class FolderViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    @IBOutlet weak var usernameLabel: UITextField!
    
    @IBOutlet weak var MyTable: UITableView!
    @IBAction func addCalled(sender: AnyObject) {
        
    }
    @IBOutlet weak var SearchBar: UISearchBar!
    var foldersArray:[String] = [String]()
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //if (foldersArray.count % 2 == 1){
          //  return foldersArray.count/2 + 1
        //}
        return foldersArray.count
    }
    
    func tableView(tableView: UITableView, numberOfColumnsInSection section: Int) -> Int{
        return 2
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let myCell = self.MyTable.dequeueReusableCellWithIdentifier("Cell",forIndexPath: indexPath)
        
        myCell.textLabel?.text = foldersArray[indexPath.row]
        return myCell
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        MyTable.delegate = self
        MyTable.dataSource = self
        let current = PFUser.currentUser()!.username
        let fQuery = PFQuery(className: "Folder")
        fQuery.whereKey("userid",equalTo:current!)
        
        fQuery.findObjectsInBackgroundWithBlock{
            (results:[AnyObject]?,error:NSError?) -> Void in
            if error != nil
            {}
            if let objects = results as? [PFObject]{
                for object in objects{
                    let name = object.objectForKey("fname") as! String
                    print(name)
                    self.foldersArray.append(name)
                }
                dispatch_async(dispatch_get_main_queue()){
                    self.MyTable.reloadData()
                }
            }
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
