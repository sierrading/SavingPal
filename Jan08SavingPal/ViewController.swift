//
//  ViewController.swift
//  Jan08SavingPal
//
//  Created by dingding on 2020/1/8.
//  Copyright © 2020 dingding. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookLogin
import FacebookCore


class ViewController: UIViewController,GIDSignInDelegate {
    
    var imageUrl:String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true 
    }
    
    @IBAction func goBackFromLogout(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func facebookLogin(_ sender: UIButton) {
        
        let manager = LoginManager()
        manager.logIn(permissions: [Permission.publicProfile, .userPhotos, .email, .userGender ], viewController: self) { (loginResult) in
            switch loginResult{
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermission, let declinedPermissions,let accessToken):
                print("Logged in!")
                self.getDetails()
            }
        }
        
        
    }
    func getDetails(){
        
        guard let _ = AccessToken.current else{return}
        let param = ["fields":"name, email, gender, age_range, picture.type(large)"]
        let graphRequest = GraphRequest(graphPath: "me",parameters: param)
        graphRequest.start { (sss, result, err) in
            if let result = result as? Dictionary<String, Any> {
                let email = result["email"] as? String
                let name = result["name"] as? String
                
                if let picDic = result["picture"] as? [String: Any], let dataDic = picDic["data"] as? [String: Any], let url = dataDic["url"] as? String  {
                    
                    let token = AccessToken.current?.tokenString
                    var userModel = UserModel(
                        name:name,
                        email:email,
                        userId: AccessToken.current?.userID,
                        imageUrl: URL(string: url))
                    userModel.token = token
                    userModel.save()
                    self.loginBackend()
                }
                
            }
        }
        
    }
    
    @IBAction func googleLogin(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let facebookAccessToken = AccessToken.current
        if let _ = AccessToken.current {
            print("\(facebookAccessToken?.userID) login")
        } else {
            print("not login")
        }
    }
    
    func loginBackend() {
        if var user = UserModel.me {
            //labelName.text = user.name
            //labelEmail.text = user.email
            //labelUserId.text = user.userId
            let params : Dictionary<String, Any> = [
                "user_id": user.userId,
                "user_email": user.email!,
                "user_name": user.name!
            ]
            //imageViewProfile.sd_setImage(with: user.imageUrl, completed: nil)
            NetWorkController.sharedInstance.connectApiLogin(api: "/login",params: params)
            {(jsonData) in
                print(jsonData.description)
                let token = jsonData["data"]["token"].stringValue
                user.token = token
                user.save()
            
                DispatchQueue.main.async {
                    let profileVC = self.storyboard?
                            .instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
                    self.navigationController?.pushViewController(profileVC!, animated: true)
                                   
                }
            }
        }else{
            print("user model not found")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            print(error.debugDescription)
        }else{
            if let user = user{
                let userModel = UserModel(
                    name:user.profile.name,
                    email:user.profile.email,
                    userId: user.userID,
                    imageUrl: user.profile.imageURL(withDimension: UInt(200)))
                
                userModel.save()
                loginBackend()
                
               
            }
        }
    }
    
    
}

