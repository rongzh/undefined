//
//  HomeViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/31/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse

class CardViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate{
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var degree: UIPickerView!
    @IBAction func nextbutton(sender: AnyObject) {
        nextcalled()
    }
    
    @IBOutlet weak var cardtext: UITextField!
    @IBOutlet weak var textbox: UIView!
    var cardView: UIView!
    var searchResults_front=[String]()
    var searchResults_back=[String]()
    var searchResult_id = [String]()
    var searchResult_degrees = [String]()
    var foldername = String()
    var globalDegree = "0"
    
    var front:UIImageView!
    var back:UIImageView!
      var index = 0
    let degreePicker = ["1","2","3","4","5"]

    var showingBack = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        degree.dataSource = self
        degree.delegate = self
        let currentuser = PFUser.currentUser()!.username
        
        
        let query = PFQuery(className: "Card")
        query.whereKey("userid", equalTo:currentuser!)
        query.whereKey("foldername", equalTo:foldername)
        
        let scoreArrary = query.findObjects()
        
        
        for object in scoreArrary!{
            let name = object.objectForKey("def") as! String
            let b_name = object.objectForKey("back") as! String
            let id = object.objectId as! AnyObject
            let degrees = object.objectForKey("degree") as! String
            
 
            self.searchResults_front.append(name)
            self.searchResults_back.append(b_name)
            self.searchResult_id.append(id as! String)
            self.searchResult_degrees.append(degrees)

        }
            self.cardtext.text = self.searchResults_front[index]
            self.myLabel.text = self.searchResult_degrees[index]
            let defaultRowIndex = degreePicker.indexOf(self.searchResult_degrees[index])
            degree.selectRow(defaultRowIndex!, inComponent: 0, animated: true)
        
        let rect = CGRectMake((view.frame.size.width-300)/4, 20, 300, 210)
        cardView = UIView(frame: rect)
        back = UIImageView(image: UIImage(named: "back.png"))
        back.frame = rect
        back.contentMode = UIViewContentMode.ScaleAspectFit
        
        front = UIImageView(image: UIImage(named: "front.png"))
        front.frame = rect
        front.contentMode = UIViewContentMode.ScaleAspectFit
        
        
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("tapped"))
        singleTap.numberOfTapsRequired = 1
        
        cardView.addGestureRecognizer(singleTap)
        cardView.userInteractionEnabled = true
        cardView.addSubview(front)
        self.view.addSubview(cardView)
        let horizontalConstraint = NSLayoutConstraint(item: cardView, attribute: NSLayoutAttribute.RightMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.LeftMargin, multiplier: 1, constant: 100)
        self.view.addConstraint(horizontalConstraint)
//        let widthConstraint = NSLayoutConstraint(item: cardView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 350)
//       self.view.addConstraint(widthConstraint)
//        // view.addConstraint(widthConstraint) // also works
//        
//        let heightConstraint = NSLayoutConstraint(item: cardView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 200)
//        self.view.addConstraint(heightConstraint)
        // view.addConstraint(heightConstraint) // also works
        
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
        globalDegree = self.myLabel.text!


        helper()
        
//        let query = PFQuery(className: "Card")
//        query.getObjectInBackgroundWithId(searchResult_id[index]){
//            (cards: PFObject?, error: NSError?) -> Void in
//            if error != nil{
//                print(error)
//            }else if let cards = cards{
//                cards["degree"] = self.myLabel.text
//                let alert = UIAlertView()
//                alert.title = "No Text"
//                alert.message = self.myLabel.text
//                alert.addButtonWithTitle("OK")
//                alert.show()
//                cards.saveInBackground()
//            }
//        }
    
        

        if(showingBack){
            UIView.transitionFromView(back, toView: front, duration: 0.1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            showingBack = false
        }
        if (index + 1 < searchResults_front.count){
            index++
        }
        self.cardtext.text = self.searchResults_front[index]
        self.myLabel.text = self.searchResult_degrees[index]
        var defaultRowIndex = degreePicker.indexOf(self.searchResult_degrees[index])
        degree.selectRow(defaultRowIndex!, inComponent: 0, animated: true)
    }
    
    func helper(){
        let query = PFQuery(className: "Card")
        query.getObjectInBackgroundWithId(searchResult_id[index]){
            (cards: PFObject?, error: NSError?) -> Void in
            if error != nil{
                print(error)
            }else if let cards = cards{
                cards["degree"] = self.globalDegree
                let alert = UIAlertView()
                alert.title = "Degree Updated"
                alert.message = "Degree Updated to " + self.globalDegree
                alert.addButtonWithTitle("OK")
                alert.show()
                cards.saveInBackground()
            }
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return degreePicker.count

    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return degreePicker[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == degreePicker{
        myLabel.text = degreePicker[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var titleData = degreePicker[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.blueColor()])
        return myTitle
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            //color the label's background
            let hue = CGFloat(row)/CGFloat(degreePicker.count)
            pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
        let titleData = degreePicker[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 26.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .Center
        
        return pickerLabel
        
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
