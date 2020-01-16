//
//  SingleTableViewCell.swift
//  Jan08SavingPal
//
//  Created by dingding on 2020/1/9.
//  Copyright © 2020 dingding. All rights reserved.
//

import UIKit

class SingleTableViewCell: UITableViewCell {

    @IBOutlet weak var nextSaveView: UIView!
    //自己的progress Bar
    @IBOutlet weak var singleProgressBar: UIProgressView!
    
    //頻率
    @IBOutlet weak var singleFrequency: UILabel!
    
    //下次存
    @IBOutlet weak var singleNextSave: UILabel!
    
    //狀態
    @IBOutlet weak var singleProjectStatus: UILabel!
    
    //projectNAME
    @IBOutlet weak var singleProjectName: UILabel!
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
