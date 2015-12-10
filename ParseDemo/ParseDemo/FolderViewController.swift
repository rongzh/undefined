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
    var popViewController : AddFolderPopUpViewController!
    @IBOutlet weak var MyTable: UITableView!
    //var hellotable : UITableView = MyTable
    
    @IBAction func addCalled(sender: AnyObject) {
        
    }
    @IBOutlet weak var SearchBar: UISearchBar!
    var foldersArray:[String] = [String]()
    
    //var myTable: SomeType = someValue
    
    
    
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
        let current = PFUser.currentUser()!.username
        let fQuery = PFQuery(className: "Card")
        fQuery.whereKey("userid",  equalTo: current!)
        fQuery.whereKey("foldername",  equalTo: foldersArray[indexPath.row])
        print(foldersArray[indexPath.row])
        let scoreArrary = fQuery.findObjects()
        var c = scoreArrary!.count;
        myCell.textLabel?.text = foldersArray[indexPath.row] + "(" + String(c) + " Card)"
        return myCell
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            let query = PFQuery(className: "Folder")
            query.whereKey("fname", equalTo: self.foldersArray[indexPath.row])
            query.whereKey("userid",equalTo: PFUser.currentUser()!.username!)
            let scoreArrary = query.findObjects()
            
            let object = scoreArrary![0]
            object.deleteInBackground();
            print("deleted")
            
            let query1 = PFQuery(className: "Card")
            query1.whereKey("foldername", equalTo: self.foldersArray[indexPath.row])
            query1.whereKey("userid",equalTo: PFUser.currentUser()!.username!)
            let scoreArrary1 = query1.findObjects()
            for object1 in scoreArrary1!{
                object1.deleteInBackground();
                print("delete card also")
            }

            self.foldersArray.removeAtIndex(indexPath.row)
            // remove the deleted item from the `UITableView`
            self.MyTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    }
        
        return [delete]
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
    
    func reloadTableData(notification: NSNotification) {
        MyTable.reloadData()
    }
    
    
    func loadList(notification: NSNotification){
        //load data here
        self.MyTable.reloadData()
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        self.MyTable.reloadData()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CardListViewController"
        {
            let detailViewController = ((segue.destinationViewController) as! CardListViewController)
            let indexPath = self.MyTable.indexPathForSelectedRow!
            let foldername = foldersArray[indexPath.row]
            detailViewController.foldername = foldername
            print(foldername)
        }
    }
    @IBAction func ShowPopUp(sender: UIBarButtonItem) {
        let bundle = NSBundle(forClass: AddFolderPopUpViewController.self)
        self.popViewController = AddFolderPopUpViewController(nibName: "AddFolderPopUp", bundle: nil)
        //self.popViewController.title = "This is a popup view"
        //self.popViewController.showViewController(<#T##vc: UIViewController##UIViewController#>, sender: <#T##AnyObject?#>)
         self.popViewController.showInView(self.view,animated:true)
        //self.MyTable.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func reloaddata(){
        self.MyTable.reloadData()

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
