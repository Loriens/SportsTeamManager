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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: resuseIdentifier)
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

}

