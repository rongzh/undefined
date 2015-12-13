//
//  HomeViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/31/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse

class EditCardViewController: UIViewController,UITextFieldDelegate {
    var foldername = String()
    var cardId = ""
    @IBOutlet weak var BackText: UITextView!
    @IBAction func UpdateCard(sender: AnyObject) {
        updateCardHelperCalled()
        let storyboard = UIStoryboard(name:"Main",bundle:nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("CardListViewController") as! CardListViewController
        vc.foldername = self.foldername;
        self.presentViewController(vc,animated:true,completion:nil)
    }
    @IBOutlet weak var FrontText: UITextView!
    var folders = [String]()
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
//        let currentuser = PFUser.currentUser()!.username
        self.BackText.layer.borderWidth = 1.0;
        //self.BackText.layer.borderColor = UIColor.blackColor
         self.FrontText.layer.borderWidth = 1.0;
        let query1 = PFQuery(className: "Card")
        query1.whereKey("objectId", equalTo:cardId)
        
        let scoreArrary = query1.findObjects()
        for object in scoreArrary!{
            let name = object.objectForKey("def") as! String
            let b_name = object.objectForKey("back") as! String
            self.FrontText.text = name
            self.BackText.text = b_name
            
        }
    }
    
    func updateCardHelperCalled(){
        let query = PFQuery(className: "Card")
        query.getObjectInBackgroundWithId(cardId){
            (cards: PFObject?, error: NSError?) -> Void in
            if error != nil{
                print(error)
            }else if let cards = cards{
                cards["def"] = self.FrontText.text
                cards["back"] = self.BackText.text
                //let alert = UIAlertView()
                //alert.title = "Cards Updated"
                //alert.addButtonWithTitle("OK")
                //alert.show()
                cards.saveInBackground()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    
    return true
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CardListViewController10"
        {
            let detailViewController = ((segue.destinationViewController) as! CardListViewController)
                detailViewController.foldername = foldername
            
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
