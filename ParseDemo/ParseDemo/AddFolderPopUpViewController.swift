//
//  FolderViewController.swift
//  ParseDemo
//
//  Created by Rong Zhou on 12/2/15.
//  Copyright © 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse

class AddFolderPopUpViewController: UIViewController/*,UITableViewDataSource, UITableViewDelegate*/{
    @IBOutlet weak var foldername: UITextField!
    
//    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//    let nextViewController = storyboard.instantiateViewControllerWithIdentifier("Folder View Controller") as FolderViewController
//    self.presentViewController(nextViewController, animated:true, completion:nil)
    //var folderViewController : FolderViewController!
    //var folderViewController: FolderViewController = FolderViewController(nibName: nil, bundle: nil)
    //var folderview:FolderViewController? = nil
    //func tableView(tableView: UITableView, numberOfColumnsInSection section: Int) -> Int{
      //  return 2
    //}
    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//        //if (foldersArray.count % 2 == 1){
//        //  return foldersArray.count/2 + 1
//        //}
//        //return self.folderViewController.foldersArray.count
//        return self.folderview!.foldersArray.count
//    }
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
//        //let myCell = self.folderViewController.MyTable.dequeueReusableCellWithIdentifier("Cell",forIndexPath: indexPath)
//        let myCell = self.folderview!.MyTable.dequeueReusableCellWithIdentifier("Cell",forIndexPath: indexPath)
//        //myCell.textLabel?.text = self.folderViewController.foldersArray[indexPath.row]
//        myCell.textLabel?.text = self.folderview!.foldersArray[indexPath.row]
//        return myCell
//    }

    
    @IBAction func createfolder(sender: AnyObject) {
        let fname_ = foldername.text
        let newfolder = PFObject(className: "Folder")
        let current = PFUser.currentUser()!.username
        newfolder["userid"] = current
        newfolder["fname"] = fname_
        newfolder.saveInBackgroundWithBlock{
            (success:Bool, error:NSError?) -> Void in
            if(success){
                let alert = UIAlertView(title: "Success", message: "Folder Created", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
            else{
                let alert = UIAlertView(title: "Oops", message: "Something is wrong...", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
        }
        
        //self.folderViewController.foldersArray.removeAll()
//        self.folderview!.foldersArray.removeAll()
//        let fQuery = PFQuery(className: "Folder")
//        fQuery.whereKey("userid",equalTo:current!)
//        
//        fQuery.findObjectsInBackgroundWithBlock{
//            (results:[AnyObject]?,error:NSError?) -> Void in
//            if error != nil
//            {}
//            if let objects = results as? [PFObject]{
//                for object in objects{
//                    let name = object.objectForKey("fname") as! String
//                    print(name)
//                    //self.folderViewController.foldersArray.append(name)
//                    self.folderview!.foldersArray.append(name)
//                }
//                dispatch_async(dispatch_get_main_queue()){
//                    self.folderview!.MyTable.reloadData()
//                }
//            }
//            
//        }

        self.removeAnimate()
    }
        
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    @IBAction func closepopup(sender: AnyObject) {
        self.removeAnimate()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        self.view.layer.cornerRadius = 5
        self.view.layer.shadowOpacity = 0.3
        self.view.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        //folderview = FolderViewController()
        //self.folderViewController.MyTable.delegate = self
        //self.folderViewController.MyTable.dataSource = self
    }
    
    public func showInView(aView: UIView!, animated: Bool)
    {
        aView.addSubview(self.view)
        if animated
        {
            self.showAnimate()
        }
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
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
