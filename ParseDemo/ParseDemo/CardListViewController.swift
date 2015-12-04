//
//  HomeViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/31/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse

class CardListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
     @IBOutlet weak var myTable: UITableView!
    var searchResults=[String]()
    var foldername = String()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
        let currentuser = PFUser.currentUser()!.username
        let query = PFQuery(className: "Card")
        query.whereKey("userid", equalTo:currentuser!)
        query.whereKey("foldername", equalTo: foldername)
        
        let scoreArrary = query.findObjects()
        
        
        for object in scoreArrary!{
            let name = object.objectForKey("def") as! String
            
            self.searchResults.append(name)
            
        }

        //self.usernameLabel.text = PFUser.currentUser()!.username
        // Show the current visitor's username
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return searchResults.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
         let myCell = self.myTable.dequeueReusableCellWithIdentifier("Cell",forIndexPath: indexPath)
        
        myCell.textLabel!.text = searchResults[indexPath.row]
        myCell.textLabel!.adjustsFontSizeToFitWidth = true;
        
        return myCell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CardViewController"
        {
            let detailViewController = ((segue.destinationViewController) as! CardViewController)
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
