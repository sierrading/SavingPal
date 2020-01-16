//
//  MainViewController.swift
//  Jan08SavingPal
//
//  Created by dingding on 2020/1/8.
//  Copyright © 2020 dingding. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleSignIn

class MainViewController: UIViewController {
    
    //singleTableView
    let projectName = ["AAAAA","BBBBB","CCCCC","DDDDD","EEEEEE"]
    //singleTableView
    
    
    //var userModel:UserModel?
    
    @IBOutlet var containerViews: [UIView]!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelUserId: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelName: UILabel!
    //右上Item 點下去跳轉
    @objc func profileBtn(_ sender: UIButton) {
        let profileVC = self.storyboard?
            .instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController
        self.navigationController?.pushViewController(profileVC!, animated: true)
    }
    //右上Item 點下去跳轉
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //切換TableView
        containerViews[0].isHidden = false
        containerViews[1].isHidden = true
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
        
        
        //右上角 照片
        if let user = UserModel.me, let url = user.imageUrl {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let image = UIImage(data: data)  {
                    DispatchQueue.main.async {
                        let button = UIButton(type: .custom)
                        button.setImage(image, for: .normal)
                        button.translatesAutoresizingMaskIntoConstraints = false
                        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
                        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
                        button.imageView?.contentMode = .scaleAspectFill
                        button.imageView?.layer.cornerRadius = 15
                        button.addTarget(self, action: #selector(self.profileBtn(_:)), for: .touchUpInside)
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
                        
                        
                        
                        //                        let button = UIButton(type: .custom)
                        //                        button.setBackgroundImage(image, for: .normal)
                        //                        //let imageView = UIImageView(image: image)
                        //
                        //                        button.translatesAutoresizingMaskIntoConstraints = false
                        //                        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
                        //                        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
                        //                        button.imageView?.contentMode = .scaleAspectFill
                        //                        button.imageView?.layer.cornerRadius = 15
                        //                        button.imageView?.clipsToBounds = true
                        //                        button.addTarget(self, action: #selector(self.profileBtn(_:)), for: .touchUpInside)
                        //                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
                    }
                }
            }.resume()
        }
        //右上角 照片
    }
    
    //把資料帶過來
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
      
    }
    //    open func refresh() {
    //        print(userModel)
    //        print("132")
    //    }
    
    @IBAction func googleLogout(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        self.present(loginVC!, animated: true, completion: nil)
    }
    
    @IBAction func changeMode(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            containerViews[0].isHidden = false
            containerViews[1].isHidden = true
        } else {
            containerViews[0].isHidden = true
            containerViews[1].isHidden = false
        }
    } 
    
    //用程式碼換頁 到一人或多人 帶資料 //傳ID
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "inputProject" {
            //inputProject?.userModel = userModel
            let controller = segue.destination as! NewProjectViewController
            if containerViews[0].isHidden == false {
                controller.isSingle = true
            } else {
                controller.isSingle = false 
            }
        }
    }
    
}


