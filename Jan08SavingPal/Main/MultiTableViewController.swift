
//
//  MultiTableViewController.swift
//  Jan08SavingPal
//
//  Created by dingding on 2020/1/10.
//  Copyright © 2020 dingding. All rights reserved.
//

import UIKit

class MultiTableViewController: UITableViewController {

    var projects = [ProjectModal]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //projects = ProjectModal.readProjectsFromFile() ?? [ProjectModal]()
        //tableView.reloadData()
        print("getProjects")
        NetWorkController.sharedInstance.getProjects { (projects) in
            if let projects = projects {
                
                self.projects = projects.filter { (project) -> Bool in
                    project.projectNumber! > 1
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


    @IBAction func saveMoney(_ sender: UITapGestureRecognizer) {
        if let cell = sender.view?.superview?.superview as? UITableViewCell,  let row = tableView.indexPath(for: cell)?.row {
           
            let project = projects[row]
            let controller = UIAlertController(title: "dd", message: "請輸入你要存的錢", preferredStyle: .alert)
            controller.addTextField { (textField) in
               textField.placeholder = "Money"
                textField.text = "\(project.frequencySaveMoney())"
               textField.keyboardType = UIKeyboardType.numberPad
            }
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
               let moneyString = controller.textFields?[0].text ?? "0"
               let money = Int(moneyString) ?? 0
               let formatter = DateFormatter()
               formatter.dateFormat = "yyyy/MM/dd"
               let dateString = formatter.string(from: project.projectStart)
                
                NetWorkController.sharedInstance.saveMoney(projectId: project.projectId, date: dateString, money: money) { (result) in
                    if result {
                        print("save ok")
                    }
                }
            }
            controller.addAction(okAction)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            controller.addAction(cancelAction)
            present(controller, animated: true, completion: nil)
        }
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return projects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mutiCell", for: indexPath) as! MutiTableViewCell

        // Configure the cell...
        let project = projects[indexPath.row]
        cell.mutiProjectName.text = project.projectName
        cell.mutiProjectNextSave.text = "\(project.frequencySaveMoney())"
        cell.mutiProjectFrequency.text = project.projectFreq
        if let gesture = cell.nextSaveView.gestureRecognizers?.first {
            cell.nextSaveView.removeGestureRecognizer(gesture)
        }
        cell.nextSaveView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveMoney(_:))))
        cell.addMember.addTarget(self, action: #selector(self.buttonClick), for: .touchUpInside)
        return cell
    }
    
    @objc func buttonClick(){
        let controller = UIAlertController(title: "邀請朋友", message: "專案名稱：", preferredStyle: .alert)
        controller.addTextField { (textField) in
           textField.placeholder = "邀請碼"
           
        }
       
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
           let phone = controller.textFields?[0].text
          
          
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let row = tableView.indexPathForSelectedRow?.row, let controller = segue.destination as? DetailViewController {
            controller.projectId = projects[row].projectId
            controller.project = projects[row]

        }
    }
    

}
