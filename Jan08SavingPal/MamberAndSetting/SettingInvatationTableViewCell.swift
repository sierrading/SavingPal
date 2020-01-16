//
//  SettingInvatationTableViewCell.swift
//  Jan08SavingPal
//
//  Created by dingding on 2020/1/16.
//  Copyright © 2020 dingding. All rights reserved.
//

import UIKit

class SettingInvatationTableViewCell: UITableViewCell {

    @IBOutlet weak var inviteBtn: UIButton!
    @IBOutlet weak var inviteTextField: UITextField!
    @IBOutlet weak var inviteLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
