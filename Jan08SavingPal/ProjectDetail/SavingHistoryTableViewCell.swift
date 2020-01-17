//
//  SavingHistoryTableViewCell.swift
//  Jan08SavingPal
//
//  Created by dingding on 2020/1/14.
//  Copyright © 2020 dingding. All rights reserved.
//

import UIKit

class SavingHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var SavingEdit: UIButton!
    @IBOutlet weak var howMuchSaved: UILabel!
    @IBOutlet weak var saveTag: UILabel!
    @IBOutlet weak var newProject: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
