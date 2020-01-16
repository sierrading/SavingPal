//
//  SettingViewController.swift
//  Jan08SavingPal
//
//  Created by dingding on 2020/1/8.
//  Copyright © 2020 dingding. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import GoogleSignIn

class SettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBAction func logOutBtn(_ sender: UIButton) {
        
    }
    var arrayUserSelf = ["請輸入邀請碼："]
    
    var arrayEnviroment = ["推播通知"]
    
    var arrayAboutUs = ["意見回饋", "關於我們", "版本"]
    
    
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelUserId: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var imageViewProfile: UIImageView!{
        didSet{
            imageViewProfile.layer.cornerRadius = imageViewProfile.bounds.height/2
            imageViewProfile.clipsToBounds = true
        }
    }
    //var userModel:UserModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelUserId.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let user = UserModel.me{
            labelName.text = user.name
            labelEmail.text = user.email
            labelUserId.text = user.userId
            
            let params : Dictionary<String, Any> = [
                //"user_id": user.userId,
                "user_email": user.email!,
                "user_name": user.name!
            ]
            imageViewProfile.sd_setImage(with: user.imageUrl, completed: nil)
            NetWorkController.sharedInstance.connectApiByPost(api: "/login",token: user.token! ,params:params)
            {(jsonData) in
                print(jsonData.description)
            }
            
        }else{
            print("user model not found")
        }
    }
    
    open func refresh() {
        
        print(UserModel.me)
        print("132")
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // 設置tableView每個Header的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return arrayUserSelf.count
        } else if section == 1{
            return arrayEnviroment.count
        }
        return arrayAboutUs.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        //view.backgroundColor = UIColor.applicationAssistantColor()
        view.backgroundColor = UIColor(named:"mainBlue")
        let viewLabel = UILabel(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
        viewLabel.textColor = UIColor(named: "textGray")
        
        if section == 0{
            viewLabel.text = "多人存邀請碼"
           
        }
        else if section == 1{
            viewLabel.text = "環境設定"
        }
        else if section == 2{
            viewLabel.text = "關於App"
        }
        view.addSubview(viewLabel)
        tableView.addSubview(view)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingTableViewCell
        
         let inviteCell = tableView.dequeueReusableCell(withIdentifier: "InviteCell", for: indexPath) as! SettingInvatationTableViewCell
        
        if(indexPath.section == 0){
            inviteCell.inviteLabel.text = arrayUserSelf[indexPath.row]
//            inviteCell.inviteTextField.text
//            inviteCell.inviteBtn
            //cell.itemName.text = arrayUserSelf[indexPath.row]
            
            
            //           cell.accessoryType = checknumbers[indexPath.row] ? .checkmark: .none
            return inviteCell
            
        }
        else if indexPath.section == 1{
            cell.itemName.text = arrayEnviroment[indexPath.row]
            //            if checkletters[indexPath.row]{
            //                cell.accessoryType = .checkmark}
            //            else{
            //                cell.accessoryType = .none
            //            }
            //            cell.accessoryType = checkletters[indexPath.row] ? .checkmark: .none
        }else if indexPath.section == 2{
            cell.itemName.text = arrayAboutUs[indexPath.row]
        }
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    //        tableView.deselectRow(at: indexPath, animated: true)
    //        performSegue(withIdentifier: "setting_to_modify", sender: arrayUserSelf[0])
    //
    //    }
    
    
}
