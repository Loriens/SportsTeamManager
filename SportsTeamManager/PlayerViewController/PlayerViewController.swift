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
    private var teams = [Team]()
    private var positions = ["Goalkeeper", "Defender", "Midfielder", "Forward"]
    private var pickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerController.sourceType = .photoLibrary
        
        teams = teamManager.fetchData(from: Team.self)
    }
    
    @IBAction func uploadImageButtonPressed(_ sender: Any) {
        self.present(pickerController, animated: true)
    }
    
    @IBAction func teamButtonPressed(_ sender: Any) {
    }
    
    @IBAction func positionButtonPressed(_ sender: Any) {
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// Support UIPickerView delegate and data source
extension PlayerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return teams.count
        case 1:
            return positions.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return teams[row].name
        case 1:
            return positions[row]
        default:
            return "empty"
        }
    }
    
}
