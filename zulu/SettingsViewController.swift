//
//  SettingsViewController.swift
//  zulu
//
//  Created by MkhululiZulu on 10/28/17.
//  Copyright © 2017 MkhululiZulu. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var swAscending: UISwitch!
    @IBOutlet weak var pckSortField: UIPickerView!
    @IBOutlet weak var lblBattery: UILabel!
    
    let sortOrderItems: Array<String> = ["contactName", "city", "birthday","state", "zipCode"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pckSortField.dataSource = self;
        pckSortField.delegate = self;
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.batteryChanged), name: NSNotification.Name.UIDeviceBatteryStateDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.batteryChanged), name: NSNotification.Name.UIDeviceBatteryLevelDidChange, object: nil)
        
        self.batteryChanged()
        
    }
    
    func batteryChanged()
    {
        let device = UIDevice.current
        var batteryState: String
        switch(device.batteryState)
        
        {
        case.charging: batteryState = "+"
        case.full:  batteryState = "!"
        case.unplugged: batteryState = "-"
        case .unknown: batteryState = "?"
            
        }
        let batteryLevelPercent = device.batteryLevel * 100
        let batteryLevel = String(format: "%.0f%%", batteryLevelPercent)
        let batteryStatus = "\(batteryLevel) (\(batteryState))"
        lblBattery.text = batteryStatus
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //set the UI based on values in UserDefaults
        self.startMotionDetection()
        let settings = UserDefaults.standard
        swAscending.setOn(settings.bool(forKey: Constants.kSortDirectionAscending), animated: true)
        let sortField = settings.string(forKey:  Constants.kSortField)
        
        var i = 0
        for field in sortOrderItems
        {
            if field == sortField {
                pckSortField.selectRow(i, inComponent: 0, animated: false)
            }
            i += 1
        }
        pckSortField.reloadComponent(0)
    }
    
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sortDirectionChanged(_ sender: Any)
    {
    let settings = UserDefaults.standard
        settings.set(swAscending.isOn, forKey: Constants.kSortDirectionAscending)
        settings.synchronize()
    }
        
        // MARK: UIPickerViewDelegate Methods
        //Returns the number of 'columns' to display 
        func numberOfComponents(in pickView: UIPickerView)-> Int
            {
                return 1
            }
        
        //returns the # of rows in the picker
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int)-> Int
        {
        
            return sortOrderItems.count
        }
        
        //Sets the value that is shown for each row in the picker
        func pickerView (_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String?
        {
            return sortOrderItems[row]
        }

    //if the user chooses from the pickerview, it calls this function 
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let sortField = sortOrderItems[row]
        let settings = UserDefaults.standard
        settings.set(sortField, forKey: "sortField")
        settings.synchronize()
       
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidDisappear(_ animated: Bool) {
        UIDevice.current.isBatteryMonitoringEnabled = false
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.motionManager.stopAccelerometerUpdates()
        
        let device = UIDevice.current
        print ("Device Info: ")
        print ("Name:  \(device.name)")
        print("Model: \(device.model)")
        print("System Name:  \(device.systemName)")
        print("System Version:  \(device.systemName)")
        print("Identifier:  \(device.identifierForVendor!)")
        
        let orientation: String
        
        switch device.orientation{
        case .faceDown:
            orientation = "Face Down"
        case  .landscapeLeft:
            orientation = "Landscape Left"
        case  .portrait:
            orientation = "Potrait"
        case  .landscapeRight:
            orientation = "Landscape Right"
        case  .faceUp:
            orientation = "Face Up"
        case  .portraitUpsideDown:
            orientation = "Potrait Upside Down"
        case  .unknown:
        orientation = "Unknown Orientation"
        }
        print("Orientation:  \(orientation)")
        
    }
    func startMotionDetection()
        {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mManager = appDelegate.motioinManager
            if mManager.isAccelerometerAvailable
            {
            mManager.accelerometerUpdateInterval = 0.05
                mManager.startAccelerometerUpdates(to: OperationQueue.main)
                {
                    (data: CMAccelerometerData?, error: Error?) in
                    self.updateLabel(data: data!)
                }
            }
        }
    
    func updateLabel(data: CMAccelerometerData)
    {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let tabBarHeight = self.tabBarController?.tabBar.frame.Height
        let moveFactor:Double = 15.0
        var rect = lblBattery.frame
        let moveToX = Double(rect.origin.x) + data.acceleration.x * moveFactor
        let moveToY = Double(rect.origin.y + rect.size.height) - (data.acceleration.y * moveFactor)
        let maxX = Double (SettingsViewController.frame.size.width - rect.width)
        let maxY = Double(SettingsViewController.frame.size.height - tabBarHeight)
        let minY = Double(rect.size.height + statusBarHeight)
       
        if(moveToX > 0 && moveToX < maxX){
        rect.origin.x += CGFloat(data.acceleration.x * moveFactor)}
        if (moveToY > minY && moveToY < maxY){
            rect.origin.y -= CGFloat(data.acceleration.y * moveFactor);
        }
        UIView.animate(withDuration: TimeInterval(0),
                       delay: TimeInterval(0),
                       options: UIViewAnimationOptions.curveEaseInOut,
                       animations: {self.lblBattery.frame = rect},
                       completion: nil)
        
    }
    

}

