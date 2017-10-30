//
//  ContactsViewController.swift
//  zulu
//
//  Created by MkhululiZulu on 10/28/17.
//  Copyright © 2017 MkhululiZulu. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    @IBOutlet weak var txtName: UITextView!
    @IBOutlet weak var txtAddress: UITextView!
    @IBOutlet weak var txtCity: UITextView!
    @IBOutlet weak var txtState: UITextView!
    @IBOutlet weak var txtZip: UITextView!
    @IBOutlet weak var txtCell: UITextView!
    @IBOutlet weak var txtPhone: UITextView!
    @IBOutlet weak var txtEmail: UITextView!
    @IBOutlet weak var txtBirthdate: UITextView!
    @IBOutlet weak var lblBirthdate: UITextView!
    @IBOutlet weak var btnChange: UITextView!
    
    

    override func viewDidLoad() {
        weak var changeEditMode: UISegmentedControl!
        super.viewDidLoad()
        self.changeEditMode(self)
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var scrollView: UIScrollView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeEditMode(_ sender: Any)
    {
        let textFields: [UITextField] = [txtName,txtAddress,txtCity,txtState,txtZip,txtPhone,txtCell,txtEmail]
         if sgmtEditMode.selectedSegmentIndex == 0   {
            for textField in textFields {
            textField.isEnabled = false
            textField.borderStyle = UITextBorderStyle.none}
                
        }
        btnChange.isHidden = true
    }
    
    else if sgmtEditMode.selectedSegmentIndex == 1 {
    for textField in textFields{
    textField.isEnabled = true
    textField.borderStyle = UITextBorderStyle.roundedRect}
    btnChange.isHidden = false
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        weak var ChangeButton: UIButton!
        super.viewWillDisappear(animated)
        weak var Birthdatelabel: UILabel!
        self.registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardNotifications()
    }

    func registerKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self, selector:
            #selector(ContactsViewController.keyboardDidShow(notification:)), name:
            NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(ContactsViewController.keyboardWillHide(notification:)), name:
            NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func unregisterKeyboardNotifications()
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
    
    //Get the existing contentInset for the scrollView and set the bottom property to the height of the keyboard
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardSize.height
    
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = 0
        
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
