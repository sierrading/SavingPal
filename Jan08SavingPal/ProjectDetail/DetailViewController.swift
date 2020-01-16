//
//  DetailViewController.swift
//  Jan08SavingPal
//
//  Created by dingding on 2020/1/9.
//  Copyright © 2020 dingding. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource {
    //自己的progressBar
    
    
    @IBOutlet weak var historyTableView: UITableView!
    var projectId: Int!
    var project: ProjectModal!

    @IBOutlet weak var selfProgressBar: UIProgressView!
    var histories = [HistoryMoney]()
 
    @IBAction func addSaveMoneyBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "今日應該存：", message:  "今日應該存：", preferredStyle: .alert)
        alert.addTextField()
        alert.textFields![0].text = "$300"  
        alert.addAction(UIAlertAction(title: "確認存", style: .cancel, handler: { (action) in
            let amount = alert.textFields![0].text
        }))
        
    }
    
    @IBOutlet weak var projectGoal: UILabel!
    
    @IBOutlet weak var projectLeft: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetWorkController.sharedInstance.getHistories(projectId: projectId) { (history) in
            if let history = history {
                self.histories = history.history
                DispatchQueue.main.async {
                    self.historyTableView.reloadData()

                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! SavingHistoryTableViewCell
        let history = histories[indexPath.row]
        cell.howMuchSaved.text = "\(history.money)"
        cell.date.text = history.historyDate
        
        return cell
    }
    
    
    
}
