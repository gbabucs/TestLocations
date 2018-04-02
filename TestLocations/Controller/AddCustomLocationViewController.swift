//
//  AddCustomLocationViewController.swift
//  TestLocations
//
//  Created by Babu Gangatharan on 4/2/18.
//  Copyright © 2018 Babu Gangatharan. All rights reserved.
//

import UIKit

class AddCustomLocationViewController: UIViewController {

    //--------------------------------------------------------------------------
    // MARK: - IBOutlet
    //--------------------------------------------------------------------------
    
    @IBOutlet weak var customLocationTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    //--------------------------------------------------------------------------
    // MARK: - View Life Cycle
    //--------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Location"
    }
    
    //--------------------------------------------------------------------------
    // MARK: - IBAction
    //--------------------------------------------------------------------------
    
    @IBAction func saveLocation(_ sender: UIBarButtonItem) {
        guard let name = customLocationTextField?.text else {
            return
        }
        
        NotificationCenter.default.post(name: .CustomLocationDidUpdate, object: name)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//--------------------------------------------------------------------------
// MARK: - UITextFieldDelegate
//--------------------------------------------------------------------------

extension AddCustomLocationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let regex = try! NSRegularExpression(pattern: "[a-zA-Z\\s]+", options: [])
        let range = regex.rangeOfFirstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count))
        
        return range.length == string.count
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
