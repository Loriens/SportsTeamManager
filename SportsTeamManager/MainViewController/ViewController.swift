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
        
        // Create teams, if there is no one team
        let context = teamManager.getContext()
        let teams = teamManager.fetchData(from: Team.self)
        if teams.count == 0 {
            teamManager.createObject(from: Team.self).name = "Barcelona"
            teamManager.createObject(from: Team.self).name = "Real Madrid"
            teamManager.createObject(from: Team.self).name = "Chelsea"
        }
        teamManager.save(context: context)
        
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

}

