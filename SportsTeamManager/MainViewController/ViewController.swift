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
    var teamManager: TeamManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: resuseIdentifier)
        self.tableView.allowsSelection = false
        
        let addButton = UIBarButtonItem(title: "Add (+)", style: .done, target: self, action: #selector(addButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: resuseIdentifier) as! TableViewCell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.0
    }
    
    @objc func addButtonPressed(_ sender: Any?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerVC = storyboard.instantiateViewController(withIdentifier: "PlayerVC") as! PlayerViewController
        playerVC.teamManager = teamManager
        
        self.navigationController?.pushViewController(playerVC, animated: true)
    }

}

