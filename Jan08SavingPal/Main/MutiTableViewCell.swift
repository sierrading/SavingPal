//
//  MutiTableViewCell.swift
//  Jan08SavingPal
//
//  Created by dingding on 2020/1/9.
//  Copyright © 2020 dingding. All rights reserved.
//

import UIKit

class MutiTableViewCell: UITableViewCell {

    @IBOutlet weak var addMember: UIButton!
    @IBOutlet weak var nextSaveView: UIView!
    @IBOutlet weak var mutiProjectFrequency: UILabel!
    @IBOutlet weak var mutiProjectMembersPhoto: UIImageView!
    @IBOutlet weak var mutiProjectNextSave: UILabel!
    @IBAction func mutiProjectAddMember(_ sender: UIButton) {
        
       
    
       
    }
    @IBOutlet weak var mutiProgressBar: UIProgressView!
    @IBOutlet weak var mutiProjectStatus: UILabel!
    @IBOutlet weak var mutiProjectName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func aaa(){
//        
//               let controllerAlert = UIAlertController(title: "登入", message: "請輸入你在 B12 星球的電話和密碼", preferredStyle: .alert)
//               controllerAlert.addTextField { (textField) in
//                  textField.placeholder = "電話"
//                  textField.keyboardType = UIKeyboardType.phonePad
//               }
//              
//                     let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//                     controllerAlert.addAction(cancelAction)
//                 
//        present(controllerAlert, animated: true, completion: nil)
//    }

}
