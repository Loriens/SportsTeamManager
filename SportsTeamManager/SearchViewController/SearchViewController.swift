//
//  SearchViewController.swift
//  SportsTeamManager
//
//  Created by Vladislav on 20/03/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import UIKit

protocol SearchDelegate: class {
    func viewController(_ viewController: SearchViewController, didPassedData predicate: NSCompoundPredicate)
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var ageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var teamButton: UIButton!
    @IBOutlet weak var posititonButton: UIButton!
    @IBOutlet weak var selectPickerLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var viewForPicker: UIView!
    
    weak var delegate: SearchDelegate?
    var teams = [Team]()
    private var positions = ["Goalkeeper", "Defender", "Midfielder", "Forward"]
    private var selectedTeam: Team?
    private var selectedPosition = "Goalkeeper"
    
    override func viewDidLoad() {
        viewForPicker.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
        
        if let team = teams.first {
            selectedTeam = team
        }
    }
    
    @IBAction func positionSelectPressed(_ sender: Any) {
        selectPickerLabel.text = "Select position"
        pickerView.reloadAllComponents()
        viewForPicker.isHidden = false
    }
    
    @IBAction func teamSelectPressed(_ sender: Any) {
        selectPickerLabel.text = "Select team"
        pickerView.reloadAllComponents()
        viewForPicker.isHidden = false
    }
    
    @IBAction func startSearchPressed(_ sender: Any) {
    }
    
    @IBAction func resetPressed(_ sender: Any) {
        delegate?.viewController(self, didPassedData: NSCompoundPredicate(andPredicateWithSubpredicates: []))
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension SearchViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectPickerLabel.text!.contains("team") {
            selectedTeam = teams[row]
            teamButton.setTitle(selectedTeam?.name, for: .normal)
        } else {
            selectedPosition = positions[row]
            posititonButton.setTitle(selectedPosition, for: .normal)
        }
        viewForPicker.isHidden = true
    }
}

extension SearchViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if selectPickerLabel.text!.contains("team") {
            return teams.count
        } else {
            return positions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectPickerLabel.text!.contains("team") {
            return teams[row].name
        } else {
            return positions[row]
        }
    }
}
