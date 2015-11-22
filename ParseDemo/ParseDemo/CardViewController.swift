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
    
    @IBAction func nextbutton(sender: AnyObject) {
        nextcalled()
    }
    
    @IBOutlet weak var cardtext: UITextField!
    @IBOutlet weak var textbox: UIView!
    var cardView: UIView!
    var searchResults_front=[String]()
    var searchResults_back=[String]()
    var front:UIImageView!
    var back:UIImageView!
    var index = 0
    
    var showingBack = true
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentuser = PFUser.currentUser()!.username

        let query = PFQuery(className: "Card")
        query.whereKey("userid", equalTo:currentuser!)
        
        let scoreArrary = query.findObjects()
        
        
        for object in scoreArrary!{
            let name = object.objectForKey("def") as! String
            let b_name = object.objectForKey("back") as! String
            self.searchResults_front.append(name)
            self.searchResults_back.append(b_name)

        }
            self.cardtext.text = self.searchResults_front[index]
        
        
        back = UIImageView(image: UIImage(named: "back.png"))
        back.frame = CGRectMake(1,25,350,200)
        front = UIImageView(image: UIImage(named: "front.png"))
        front.frame = CGRectMake(1,25,350,200)
        
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("tapped"))
        singleTap.numberOfTapsRequired = 1
        
        let rect = CGRectMake(1, 25, 350, 230)
        cardView = UIView(frame: rect)
        cardView.addGestureRecognizer(singleTap)
        cardView.userInteractionEnabled = true
        cardView.addSubview(front)
        
        view.addSubview(cardView)        // Show the current visitor's username
        [self.view .insertSubview(textbox, aboveSubview: cardView)]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tapped() {
        if (showingBack) {
            UIView.transitionFromView(back, toView: front, duration: 0.1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            showingBack = false
            self.cardtext.text = self.searchResults_front[index]
        } else {
            UIView.transitionFromView(front, toView: back, duration: 0.1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            showingBack = true
            self.cardtext.text = self.searchResults_back[index]
        }
        
    }
    
    func nextcalled(){
        if(showingBack){
            UIView.transitionFromView(back, toView: front, duration: 0.1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            showingBack = false
        }
        if (index + 1 < searchResults_front.count){
            index++
        }
        self.cardtext.text = self.searchResults_front[index]
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
