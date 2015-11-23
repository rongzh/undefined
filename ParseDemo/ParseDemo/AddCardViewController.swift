//
//  HomeViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/31/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse

class AddCardViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate{
    
    @IBAction func addcard(sender: AnyObject) {
        addCards()
    }
    @IBOutlet weak var frontinfo: UITextField!
    let degreePicker = ["1","2","3","4","5"]

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var degree: UIPickerView!
    @IBOutlet weak var backinfo: UITextField!
        override func viewDidLoad() {
        
            
        super.viewDidLoad()
        degree.dataSource = self
        degree.delegate = self
            
    }
    
    func addCards(){
        var newCard = PFObject(className: "Card")
        var name = PFUser.currentUser()!.username

        newCard["def"] = frontinfo.text
        newCard["back"] = backinfo.text
        newCard["userid"] = name
        newCard["degree"] = myLabel.text
        
        if((frontinfo.text?.isEmpty)! == 1 || (backinfo.text?.isEmpty)! == 1){
            let alert = UIAlertView()
            alert.title = "No Text"
            alert.message = "Text boxes cannot be empty"
            alert.addButtonWithTitle("OK")
            alert.show()
            return
        }
        if(myLabel.text == "Degree"){
            let alert = UIAlertView()
            alert.title = "No Degree"
            alert.message = "Select an initial degree for this card"
            alert.addButtonWithTitle("OK")
            alert.show()
            return
        }
        
        newCard.saveInBackgroundWithBlock{
            (success:Bool, error:NSError?) -> Void in
            if(success){
                let alert = UIAlertView(title: "Success", message: "Card Created", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                self.frontinfo.text = nil
                self.backinfo.text = nil
                self.myLabel.text = "Degree"
                
            }
            else{
                let alert = UIAlertView(title: "Oops", message: "Something is wrong...", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        myLabel.text = degreePicker[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = degreePicker[row]
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
        
    }    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
