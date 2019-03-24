//
//  PlayerViewController.swift
//  SportsTeamManager
//
//  Created by Vladislav on 18/03/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import UIKit
import CoreData
import Photos

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var playerImageView: UIImageView!
    var playerPhotoIsReady = false
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var nationalityField: UITextField!
    @IBOutlet weak var inPlaySegmentedControl: UISegmentedControl!
    @IBOutlet weak var teamSelectButton: UIButton!
    @IBOutlet weak var positionSelectButton: UIButton!
    
    var teamManager: TeamManager!
    var player: Player?
    // If selectTeam is false, user press select position
    private var selectTeam = true
    private var teams = [Team]()
    private var positions = ["Goalkeeper", "Defender", "Midfielder", "Forward"]
    private var pickerController = UIImagePickerController()
    private var context: NSManagedObjectContext?
    private var choosenTeam: Team?
    private var choosenPosition = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerController.sourceType = .photoLibrary
        self.pickerController.delegate = self
        
        teams = teamManager.fetchData(from: Team.self)
        choosenPosition = positions[0]
        if teams.count > 0 {
            choosenTeam = teams[0]
        }
        
        checkPlayer()
    }
    
    @IBAction func uploadImageButtonPressed(_ sender: Any) {
        self.present(pickerController, animated: true)
    }
    
    @IBAction func teamButtonPressed(_ sender: Any) {
        pickerView.isHidden = false
        selectTeam = true
        pickerView.reloadAllComponents()
    }
    
    @IBAction func positionButtonPressed(_ sender: Any) {
        pickerView.isHidden = false
        selectTeam = false
        pickerView.reloadAllComponents()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if playerPhotoIsReady &&
            (nameField.text != "") &&
            (nationalityField.text != "") &&
            (ageField.text != "") &&
            (numberField.text != "") {
            let context = teamManager.getContext()
            var tempPlayer: Player
            
            if let player = player {
                tempPlayer = player
            } else {
                tempPlayer = teamManager.createObject(from: Player.self)
            }
            
            if let age = Int16(ageField.text!) {
                tempPlayer.age = age
            } else {
                tempPlayer.age = 0
            }
            tempPlayer.fullName = nameField.text
            tempPlayer.image = playerImageView.image
            tempPlayer.nationality = nationalityField.text
            tempPlayer.position = choosenPosition
            tempPlayer.team = choosenTeam!
            tempPlayer.number = numberField.text
            if inPlaySegmentedControl.selectedSegmentIndex == 0 {
                tempPlayer.inPlay = true
            } else {
                tempPlayer.inPlay = false
            }
            
            teamManager.save(context: context)
            
            self.navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Error", message: "There is an empty field", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: {
                action in
            })
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

// UIPickerView delegate and data source
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectTeam {
            choosenTeam = teams[row]
            teamSelectButton.titleLabel?.text = choosenTeam?.name
        } else {
            choosenPosition = positions[row]
            positionSelectButton.titleLabel?.text = choosenPosition
        }
        
        pickerView.isHidden = true
    }
    
    
    /// If a user edits a player, fill in the data
    private func checkPlayer() {
        guard let player = player else {
            return
        }
        
        if let image = player.image as? UIImage {
            playerImageView.image = image
            playerPhotoIsReady = true
        }
        
        nameField.text = player.fullName
        nationalityField.text = player.nationality
        ageField.text = "\(player.age)"
        numberField.text = player.number
        choosenTeam = player.team
        choosenPosition = player.position!
        if !player.inPlay {
            inPlaySegmentedControl.selectedSegmentIndex = 1
        }
        
        teamSelectButton.setTitle(choosenTeam?.name, for: .normal)
        positionSelectButton.setTitle(choosenPosition, for: .normal)
    }
    
}

// UIPickerController delegate
extension PlayerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            playerImageView.image = image
            playerPhotoIsReady = true
        }
        
        defer {
            self.pickerController.dismiss(animated: true, completion: nil)
        }
    }
}
