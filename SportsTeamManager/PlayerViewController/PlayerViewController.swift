//
//  PlayerViewController.swift
//  SportsTeamManager
//
//  Created by Vladislav on 18/03/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import UIKit
import CoreData

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var playerImageView: UIImageView!
    var playerPhotoIsReady = false
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var nationalityField: UITextField!
    
    var teamManager: TeamManager!
    // If selectTeam is false, user press select position
    private var selectTeam = true
    private var teams = [Team]()
    private var positions = ["Goalkeeper", "Defender", "Midfielder", "Forward"]
    private var pickerController = UIImagePickerController()
    private var context: NSManagedObjectContext?
    private var choosenTeam = Team()
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
            let player = teamManager.createObject(from: Player.self)
            
            if let age = Int16(ageField.text!) {
                player.age = age
            } else {
                player.age = 0
            }
            player.fullName = nameField.text
            player.image = playerImageView.image
            player.nationality = nationalityField.text
            player.position = choosenPosition
            player.team = choosenTeam
            
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
        print(row)
        if selectTeam {
            return teams[row].name
        } else {
            return positions[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectTeam {
            choosenTeam = teams[row]
        } else {
            choosenPosition = positions[row]
        }
        
        pickerView.isHidden = true
    }
    
}

// UIPickerController delegate
extension PlayerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            playerImageView.image = image
            playerPhotoIsReady = true
        }
        
        self.pickerController.dismiss(animated: true, completion: nil)
    }
}
