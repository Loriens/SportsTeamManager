//
//  ViewController.swift
//  SportsTeamManager
//
//  Created by Vladislav on 17/03/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    private let resuseIdentifier = "PlayerCell"
    var teamManager: TeamManager!
    private var players = [Player]()
    private var selectedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [])
    private var selectedSegment = 0

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: resuseIdentifier) as! TableViewCell
        
        cell.configure(with: players[indexPath.item])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.0
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE", handler: {
            deleteAction, indexPath in
            
            self.teamManager.delete(object: self.players[indexPath.item])
            self.fetchData()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        
        deleteAction.backgroundColor = .red
        return [deleteAction]
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
        players = teamManager.fetchData(from: Player.self, predicate: predicate)
        
        switch selectedSegment {
        case 0:
            self.selectedSegment = selectedSegment
        case 1:
            self.selectedSegment = selectedSegment
            players = players.filter({$0.inPlay})
        case 2:
            self.selectedSegment = selectedSegment
            players = players.filter({!$0.inPlay})
        default:
            break
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

extension MainViewController: SearchDelegate {
    func viewController(_ viewController: SearchViewController, didPassedData predicate: NSCompoundPredicate) {
        selectedPredicate = predicate
        fetchData(selectedSegment: selectedSegment, predicate: predicate)
        self.tableView.reloadData()
    }
}

