//
//  PlayerViewController.swift
//  SportsTeamManager
//
//  Created by Vladislav on 18/03/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet var nationalityField: UIView!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var teamManager: TeamManager!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
