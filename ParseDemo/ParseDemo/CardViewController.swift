//
//  HomeViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/31/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse

class CardViewController: UIViewController {
    @IBOutlet weak var someLabel: UILabel!
    
    @IBOutlet weak var cardtext: UITextField!
    var cardView: UIView!
    var back: UIImageView!
    var front: UIImageView!
    
    var searchResults=[String]()
    
    
    var showingBack = true
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentuser = PFUser.currentUser()!.username

        let query = PFQuery(className: "Card")
        query.whereKey("userid", equalTo:currentuser!)
        
        let scoreArrary = query.findObjects()
        
        
        for object in scoreArrary!{
            let name = object.objectForKey("def") as! String
            
            self.searchResults.append(name)

        }

        for object in searchResults{
            self.cardtext.text = object
        }
        
        
        back = UIImageView(image: UIImage(named: "back.png"))
        back.frame = CGRectMake(0,0,350,200)
        front = UIImageView(image: UIImage(named: "front.png"))
        front.frame = CGRectMake(0,0,350,200)
        
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("tapped"))
        singleTap.numberOfTapsRequired = 1
        
        let rect = CGRectMake(20, 20, back.image!.size.width, back.image!.size.height)
        cardView = UIView(frame: rect)
        cardView.addGestureRecognizer(singleTap)
        cardView.userInteractionEnabled = true
        cardView.addSubview(back)
        
        view.addSubview(cardView)        // Show the current visitor's username
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tapped() {
        if (showingBack) {
            UIView.transitionFromView(back, toView: front, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            showingBack = false
        } else {
            UIView.transitionFromView(front, toView: back, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            showingBack = true
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
