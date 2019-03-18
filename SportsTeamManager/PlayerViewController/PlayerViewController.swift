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
    // If selectTeam is false, user press select position
    private var selectTeam = true
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
        pickerView.isHidden = false
        pickerView.reloadAllComponents()
    }
    
    @IBAction func positionButtonPressed(_ sender: Any) {
        pickerView.isHidden = false
        selectTeam = false
        pickerView.reloadAllComponents()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// Support UIPickerView delegate and data source
extension PlayerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if selectTeam {
            return teams.count
        } else {
            return positions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectTeam {
            return teams[row].name
        } else {
            return positions[row]
        }
    }
    
}
