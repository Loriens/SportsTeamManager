//
//  TableViewCell.swift
//  SportsTeamManager
//
//  Created by Vladislav on 18/03/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var inPlayLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with player: Player) {
        numberLabel.text = player.number
        fullNameLabel.text = player.fullName
        teamLabel.text = player.team?.name
        nationalityLabel.text = player.nationality
        positionLabel.text = player.position
        ageLabel.text = "\(player.age)"
        
        if player.inPlay {
            inPlayLabel.text = "In Play"
        } else {
            inPlayLabel.text = "Bench"
        }
        
        if let image = player.image as? UIImage {
            playerImageView.image = image
        }
    }
    
}
