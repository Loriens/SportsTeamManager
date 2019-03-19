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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: resuseIdentifier)
        self.tableView.allowsSelection = false
        
        let addButton = UIBarButtonItem(title: "Add (+)", style: .done, target: self, action: #selector(addButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
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
    
    @objc func addButtonPressed(_ sender: Any?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerVC = storyboard.instantiateViewController(withIdentifier: "PlayerVC") as! PlayerViewController
        playerVC.teamManager = teamManager
        
        self.navigationController?.pushViewController(playerVC, animated: true)
    }
    
    private func fetchData() {
        players = teamManager.fetchData(from: Player.self)
    }
    
    /// Create players, if there is no one
    private func fillPlayersAndTeams() {
        let context = teamManager.getContext()
        
        let players = teamManager.fetchData(from: Player.self)
        if players.count == 0 {
            let context = teamManager.getContext()
            
            let teams = teamManager.fetchData(from: Team.self)
            print(teams)
            
            let player1 = teamManager.createObject(from: Player.self)
            player1.age = 23
            player1.fullName = "Zigam Alexeev"
            player1.image = UIImage(named: "player1")
            player1.nationality = "Slavyanin"
            player1.number = "10"
            player1.position = "Forward"
            player1.team = teams[0]
            
            let player2 = teamManager.createObject(from: Player.self)
            player2.age = 10
            player2.fullName = "Ronaldo Junior"
            player2.image = UIImage(named: "player2")
            player2.nationality = "Portuguese"
            player2.number = "43"
            player2.position = "Goalkeeper"
            player2.team = teams[1]
            
            let player3 = teamManager.createObject(from: Player.self)
            player3.age = 40
            player3.fullName = "Lebron James"
            player3.image = UIImage(named: "player3")
            player3.nationality = "Russian"
            player3.number = "9"
            player3.position = "Midfielder"
            player3.team = teams[2]
            
            let player4 = teamManager.createObject(from: Player.self)
            player4.age = 30
            player4.fullName = "Kevin Durant"
            player4.image = UIImage(named: "player4")
            player4.nationality = "Englishman"
            player4.number = "9"
            player4.position = "Midfielder"
            player4.team = teams[0]
            
            let player5 = teamManager.createObject(from: Player.self)
            player5.age = 21
            player5.fullName = "Valentin Guryev"
            player5.image = UIImage(named: "player5")
            player5.nationality = "Russian"
            player5.number = "6"
            player5.position = "Defender"
            player5.team = teams[3]
            
            let player6 = teamManager.createObject(from: Player.self)
            player6.age = 21
            player6.fullName = "Ronaldo Sixers"
            player6.image = UIImage(named: "player6")
            player6.nationality = "Americanec"
            player6.number = "6"
            player6.position = "Defender"
            player6.team = teams[2]
            
            teamManager.save(context: context)
        }
        
        let teams = teamManager.fetchData(from: Team.self)
        if teams.count == 0 {
            teamManager.createObject(from: Team.self).name = "Barcelona"
            teamManager.createObject(from: Team.self).name = "Real Madrid"
            teamManager.createObject(from: Team.self).name = "Chelsea"
            teamManager.createObject(from: Team.self).name = "Spartak"
        }
        
        teamManager.save(context: context)
    }

}

