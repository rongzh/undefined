//
//  TblCell.swift
//  ParseDemo
//
//  Created by Rong Zhou on 12/1/15.
//  Copyright © 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse
class TblCell: UITableViewCell {
    @IBOutlet weak var fname: UILabel!

    @IBOutlet weak var addf: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addfclicked(sender: AnyObject) {
        let current = PFUser.currentUser()!.username
        let friendpair = PFObject(className: "Friends")
        let friendpair1 = PFObject(className: "Friends")
        friendpair["fid1"] = current
        print("come here")
        friendpair1["fid2"] = current
        friendpair["fid2"] = self.fname.text
        friendpair1["fid1"] = self.fname.text
        friendpair.saveInBackgroundWithBlock{
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("come here1")
            } else {
                let alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
        }
        friendpair1.saveInBackgroundWithBlock{
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                let alert = UIAlertView(title: "Success", message: "You add a new friend", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
            else {
                let alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.addf.hidden = true
        })

    }
    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
