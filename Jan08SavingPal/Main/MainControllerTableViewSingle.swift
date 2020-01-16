//
//  MainControllerTableViewSingle.swift
//  Jan08SavingPal
//
//  Created by dingding on 2020/1/9.
//  Copyright © 2020 dingding. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import GoogleSignIn

extension MainViewController: UITableViewDataSource,UITableViewDelegate{
  
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        cell.textLabel?.text = projectName[indexPath.row]
        return cell
    }
    
    
  
  
    
}
