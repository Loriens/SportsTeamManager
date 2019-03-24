//
//  ViewController.swift
//  SportsTeamManager
//
//  Created by Vladislav on 17/03/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UITableViewController {
    
    private let resuseIdentifier = "PlayerCell"
    var teamManager: TeamManager!
    private var selectedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [])
    private var selectedSegment = 0
    private var firstCall = true
    var fetchedResultController: NSFetchedResultsController<Player>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: resuseIdentifier)
        self.tableView.sectionHeaderHeight = 70
        self.tableView.allowsSelection = false
        
        // Create header table view
        let headerView = UIView (frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width
            , height: 70))
        let segment = UISegmentedControl(frame: CGRect(x: 20, y: 20, width: tableView.frame.size.width - 40, height: 30))
        segment.insertSegment(withTitle: "All", at: 0, animated: true)
        segment.insertSegment(withTitle: "In Play", at: 1, animated: true)
        segment.insertSegment(withTitle: "Bench", at: 2, animated: true)
        segment.selectedSegmentIndex = selectedSegment
        segment.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        headerView.addSubview(segment)
        self.tableView.tableHeaderView = headerView
        
        let addButton = UIBarButtonItem(title: "Add (+)", style: .done, target: self, action: #selector(addButtonPressed(_:)))
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = searchButton
        
//        let context = teamManager.getContext()
//        let players = teamManager.fetchData(from: Player.self)
//        for player in players {
//            teamManager.delete(object: player)
//        }
//        let teams = teamManager.fetchData(from: Team.self)
//        for team in teams {
//            teamManager.delete(object: team)
//        }
//        teamManager.save(context: context)

        fillPlayersAndTeams()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if firstCall {
            fetchData()
            firstCall = false
        }
        
        guard let sections = fetchedResultController.sections else {
            return 0
        }
        
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultController.sections else {
            return nil
        }
        
        return sections[section].name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultController.sections else {
            return 0
        }
        
        return sections[section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: resuseIdentifier) as! TableViewCell
        
        let cellPlayer = fetchedResultController.object(at: indexPath)
        cell.configure(with: cellPlayer)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE", handler: {
            deleteAction, indexPath in
            
            let player = self.fetchedResultController.object(at: indexPath)
            self.teamManager.delete(object: player)
        })
        
        let editAction = UITableViewRowAction(style: .default, title: "EDIT") {
            editAction, indexPath in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let playerVC = storyboard.instantiateViewController(withIdentifier: "PlayerVC") as! PlayerViewController
            playerVC.player = self.fetchedResultController.object(at: indexPath)
            playerVC.teamManager = self.teamManager
            
            self.navigationController?.pushViewController(playerVC, animated: true)
        }
        
        deleteAction.backgroundColor = .red
        editAction.backgroundColor = .gray
        return [deleteAction, editAction]
    }
    
    @objc func segmentedControlChanged(_ sender: Any?) {
        guard let segmentedControl = sender as? UISegmentedControl else {
            return
        }
        
        fetchData(selectedSegment: segmentedControl.selectedSegmentIndex, predicate: selectedPredicate)
        self.tableView.reloadData()
    }
    
    @objc func addButtonPressed(_ sender: Any?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerVC = storyboard.instantiateViewController(withIdentifier: "PlayerVC") as! PlayerViewController
        playerVC.teamManager = teamManager
        
        self.navigationController?.pushViewController(playerVC, animated: true)
    }
    
    @objc func searchButtonPressed(_ sender: Any?) {
        let SearchVC = SearchViewController()
        SearchVC.modalTransitionStyle = .crossDissolve
        SearchVC.modalPresentationStyle = .overCurrentContext
        SearchVC.delegate = self
        SearchVC.teams = teamManager.fetchData(from: Team.self)
        self.present(SearchVC, animated: true, completion: nil)
    }
    
    private func fetchData(selectedSegment: Int = 0, predicate: NSCompoundPredicate? = nil) {
        var newPredicate = predicate
        
        switch selectedSegment {
        case 1:
            let tempPredicate = NSPredicate(format: "inPlay == true")
            newPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [newPredicate ?? NSCompoundPredicate(), tempPredicate])
        case 2:
            let tempPredicate = NSPredicate(format: "inPlay == false")
            newPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [newPredicate ?? NSCompoundPredicate(), tempPredicate])
        default:
            break
        }
            
        
        fetchedResultController = teamManager.fetchDataWithController(for: Player.self, sectionNameKeyPath: "position", predicate: newPredicate)
        fetchedResultController.delegate = self
        fetchedObjectsCheck()
    }
    
    private func fetchedObjectsCheck() {
        guard let objects = fetchedResultController.fetchedObjects else {
            return
        }
        
        if objects.count > 0 {
            self.tableView.isHidden = false
        } else {
            self.tableView.isHidden = true
        }
    }
    
    /// Create players and teams, if there is no one
    private func fillPlayersAndTeams() {
        let context = teamManager.getContext()
        
        var teams = teamManager.fetchData(from: Team.self)
        if teams.count == 0 {
            teamManager.createObject(from: Team.self).name = "Barcelona"
            teamManager.createObject(from: Team.self).name = "Real Madrid"
            teamManager.createObject(from: Team.self).name = "Chelsea"
            teamManager.createObject(from: Team.self).name = "Spartak"
        }
        teams = teamManager.fetchData(from: Team.self)
        
        let players = teamManager.fetchData(from: Player.self)
        if players.count == 0 {
            
            let player1 = teamManager.createObject(from: Player.self)
            player1.age = 23
            player1.fullName = "Zigam Alexeev"
            player1.image = UIImage(named: "player1")
            player1.nationality = "Slavyanin"
            player1.number = "10"
            player1.position = "Forward"
            player1.team = teams[0]
            player1.inPlay = true
            
            let player2 = teamManager.createObject(from: Player.self)
            player2.age = 10
            player2.fullName = "Ronaldo Junior"
            player2.image = UIImage(named: "player2")
            player2.nationality = "Portuguese"
            player2.number = "43"
            player2.position = "Goalkeeper"
            player2.team = teams[1]
            player2.inPlay = false
            
            let player3 = teamManager.createObject(from: Player.self)
            player3.age = 40
            player3.fullName = "Lebron James"
            player3.image = UIImage(named: "player3")
            player3.nationality = "Russian"
            player3.number = "9"
            player3.position = "Midfielder"
            player3.team = teams[2]
            player3.inPlay = true
            
            let player4 = teamManager.createObject(from: Player.self)
            player4.age = 30
            player4.fullName = "Kevin Durant"
            player4.image = UIImage(named: "player4")
            player4.nationality = "Englishman"
            player4.number = "9"
            player4.position = "Midfielder"
            player4.team = teams[0]
            player4.inPlay = false
            
            let player5 = teamManager.createObject(from: Player.self)
            player5.age = 21
            player5.fullName = "Valentin Guryev"
            player5.image = UIImage(named: "player5")
            player5.nationality = "Russian"
            player5.number = "6"
            player5.position = "Defender"
            player5.team = teams[3]
            player5.inPlay = true
            
            let player6 = teamManager.createObject(from: Player.self)
            player6.age = 21
            player6.fullName = "Ronaldo Sixers"
            player6.image = UIImage(named: "player6")
            player6.nationality = "Americanec"
            player6.number = "60"
            player6.position = "Defender"
            player6.team = teams[2]
            player6.inPlay = false
            
            teamManager.save(context: context)
        }
        
        teamManager.save(context: context)
    }

}

extension MainViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        case .delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        default:
            return
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                self.tableView.insertRows(at: [indexPath], with: .fade)
                fetchedObjectsCheck()
            }
            
        case .delete:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                fetchedObjectsCheck()
            }
            
        case .update:
            if let indexPath = indexPath {
                let cell = self.tableView.cellForRow(at: indexPath) as! TableViewCell
                let cellPlayer = fetchedResultController.object(at: indexPath as IndexPath)
                cell.configure(with: cellPlayer)
            }
            
        case .move:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                self.tableView.insertRows(at: [indexPath], with: .fade)
            }
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}

extension MainViewController: SearchDelegate {
    func viewController(_ viewController: SearchViewController, didPassedData predicate: NSCompoundPredicate) {
        selectedPredicate = predicate
        fetchData(selectedSegment: selectedSegment, predicate: predicate)
        self.tableView.reloadData()
    }
}

