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
        super.viewDidLoad()
        
        viewForPicker.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
        
        if let team = teams.first {
            selectedTeam = team
        }
        
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.closeTapGesture(_:)))
        bgView.addGestureRecognizer(closeTap)
    }
    
    private func makeCompoundPredicate(name: String, age: String, team: String, position: String) -> NSCompoundPredicate {
        
        var predicates = [NSPredicate]()
        
        if !name.isEmpty {
            let namePredicate = NSPredicate(format: "fullName CONTAINS[cd] '\(name)'")
            predicates.append(namePredicate)
        }
        
        if !position.isEmpty {
            let positionPredicate = NSPredicate(format: "position CONTAINS[cd] '\(position)'")
            predicates.append(positionPredicate)
        }
        
        if !team.isEmpty {
            let teamPredicate = NSPredicate(format: "team.name CONTAINS[cd] '\(team)'")
            predicates.append(teamPredicate)
        }
        
        if !age.isEmpty {
            let selectedSegmentControl = ageCondition(index: ageSegmentedControl.selectedSegmentIndex)
            let agePredicate = NSPredicate(format: "age \(selectedSegmentControl) '\(age)'")
            predicates.append(agePredicate)
        }
        
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
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
        guard let name = fullNameField.text,
            let age = ageField.text,
            var team = teamButton.titleLabel?.text,
            var position = posititonButton.titleLabel?.text else {
                return
        }
        
        if team == "Select" {
            team = ""
        }
        if position == "Select" {
            position = ""
        }
        
        let compoundPredicate = makeCompoundPredicate(name: name, age: age, team: team, position: position)
        delegate?.viewController(self, didPassedData: compoundPredicate)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetPressed(_ sender: Any) {
        delegate?.viewController(self, didPassedData: NSCompoundPredicate(andPredicateWithSubpredicates: []))
        
        dismiss(animated: true, completion: nil)
    }
    
    private func ageCondition(index: Int) -> String {
        var condition: String!
        
        switch index {
        case 0: condition = ">="
        case 1: condition = "="
        case 2: condition = "<="
        default: break
        }
        
        return condition
    }
    
    @objc func closeTapGesture (_ recognizer: UITapGestureRecognizer) {
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
