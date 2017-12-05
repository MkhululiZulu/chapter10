//
//  DateViewController.swift
//  zulu
//
//  Created by MkhululiZulu on 11/13/17.
//  Copyright © 2017 MkhululiZulu. All rights reserved.
//

import UIKit

protocol DateControllerDelagate: class {
    func dateChanged(date: Date)
}

class DateViewController: UIViewController {
    
    @IBOutlet weak var dtpDate: UIDatePicker!
    weak var delegate: DateControllerDelagate?
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

override func  viewDidLoad()
    {
        super.viewDidLoad()
        
      
        let saveButton: UIBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveDate))
        
        self.navigationItem.rightBarButtonItem = saveButton
        self.title = "Pick Birthdate"
    }
    func saveDate ()
    {
        self.delegate?.dateChanged(date: dtpDate.date)
        self.navigationController?.popViewController(animated: true)
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
