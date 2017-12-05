//
//  ContactsViewController.swift
//  zulu
//
//  Created by MkhululiZulu on 10/28/17.
//  Copyright © 2017 MkhululiZulu. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class ContactsViewController: UIViewController, UITextFieldDelegate, DateControllerDelagate{
    
    var currentContact: Contact?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtZipCode: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCellPhone: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblBirthDate: UILabel!
    @IBOutlet weak var btnChange: UIButton!
     @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var changePicture: UIButton!
    @IBOutlet weak var imgContactPicture: UIImageView!
    
    override func viewDidLoad() {
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(callPhone(gesture: )))
        lblPhone.addGestureRecognizer(longPress)
        
        if let imageData = currentContact?.image as? Data {
            imgContactPicture.image = UIImage(data: imageData)
        }
        
        
        super.viewDidLoad()
        
        if currentContact != nil{
        
            txtName.text = currentContact!.contactName
            txtAddress.text = currentContact!.streetAddress
            txtCity.text = currentContact!.city
            txtState.text = currentContact!.state
            txtZipCode.text = currentContact!.zipCode
            txtPhone.text = currentContact!.phoneNumber
            txtCellPhone.text = currentContact!.cellNumber
            txtEmail.text = currentContact!.email
            let formatter = DataFormatter()
            formatter.dateStyle = .short
            if currentContact!.birthday != nil{
                lblBirthDate.text = formatter.string(from: currentContact!.birthday as! Date)
            }
            
        }
        
        
        self.changeEditMode(self)
        // Do any additional setup after loading the view.
        let textFields: [UITextField] = [txtName,txtAddress,txtCity,txtState,txtZipCode,txtPhone,txtCellPhone,txtEmail]
        
        for textfield in textFields{
            textfield.addTarget(self,
                            action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)),
                             for: UIControlEvents.editingDidEnd)
            
            if let imageData = currentContact?.image as? Data {
                imgContactPicture.image = UIImage(data: imageData)
            }
        }
    }
    func callPhone(gesture: UILongPressGestureRecognizer){
        if gesture.state == .began {
            let number = txtPhone.text
            if number!.characters.count > 0 {
            //Dont call blank numbers
                let url = NSURL(string: "telprompt://\(number!)")
                    UIApplication.shared.open(url as! URL, options: [:], completionHandler: nil)
                print("Calling Phone Number: \(url!)")
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) -> Bool{
        currentContact?.contactName = txtName.text
        currentContact?.streetAddress = txtAddress.text
        currentContact?.city = txtCity.text
        currentContact?.state = txtState.text
        currentContact?.zipCode = txtZipCode.text
        currentContact?.cellNumber = txtCellPhone.text
        currentContact?.phoneNumber = txtEmail.text
        
        return true
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeEditMode(_ sender: Any)
    {
        let textFields: [UITextField] = [txtName,txtAddress,txtCity,txtState,txtZipCode,txtPhone,txtCellPhone,txtEmail]
         if sgmtEditMode.selectedSegmentIndex == 0   {
            for textField in textFields {
            textField.isEnabled = false
            textField.borderStyle = UITextBorderStyle.none
                
        }
        btnChange.isHidden = true
            navigationItem.rightBarButtonItem = nil
    }
    
    else if sgmtEditMode.selectedSegmentIndex == 1
    {
        for textField in textFields
        {
            textField.isEnabled = true
            textField.borderStyle = UITextBorderStyle.roundedRect
        }
    
    btnChange.isHidden = false
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveContact))
    
    }
    }

    
    func dateChanged(date: Date) {
        if currentContact != nil {
            currentContact?.birthday = date as NSDate?
            appDelegate.saveContext()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
            lblBirthDate.text = formatter.string(from: date)
        }
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
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
    
    func saveContact(){
    if currentContact == nil {
    let context = appDelegate.persistentContainer.viewContext
    currentContact = Contact(context: context)
    }
    appDelegate.saveContext()
        sgmtEditMode.selectedSegmentIndex = 0
        changeEditMode(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueContactDate")
        {
            let dateController = segue.destination as! DateViewController
            dateController.delegate = self
        }
    }
    
    @IBAction func changePicture(_ sender: Any)
    {
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) != AVAuthorizationStatus.authorized
        {
            //Camera not authorized
            let alertController = UIAlertController(title: "Camera Access Denied", message: "In order to take pictures, you need to allow the app to access  the camera in the Settings.", preferredStyle: .alert)
            let actionSettings = UIAlertAction(title: "Open Settings", style: .default)
            {action in self.openSettings()
            
            }
            
    
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
       
            alertController.addAction(actionSettings)
        alertController.addAction(actionCancel)
        present(alertController, animated: true, completion: nil)
    }
    else
    
    {
    // Already Authorized
    
    if UIImagePickerController.isSourceTypeAvailable(.camera){
    let cameraController = UIImagePickerController()
    cameraController.sourceType = .camera
    cameraController.cameraCaptureMode = .photo
    cameraController.delegate = self
    cameraController.allowsEditing = true
    self.present(cameraController, animated: true, completion: nil)
    }
}


func openSettings(){
    if let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
    {
        if #available(iOS 10.0, *){
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            
        }
        else {
        UIApplication.shared.openURL(settingsUrl)
        }
    }
}

func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaInfo info : [String : Any]){
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            imgContactPicture.contentMode = .scaleAspectFit
            imgContactPicture.image = image
        }
        dismiss (animated : true, completion: nil)
    }
    
    if currentContact == nil {
    let context = appDelegate.persistentContainer.viewContext
    currentContact = Contact(context: context)
    }
    currentContact?.image = NSData (data: UIImageJPEGRepresentation(image, 1.0)!)

   
   
    let url = NSURL(string: "telprompt://1234567894")
    UIApplication.shared.open(url as! URL, options: [:], completionHandler: nil)
    
    }
}

