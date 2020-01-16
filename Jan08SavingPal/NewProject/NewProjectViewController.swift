//
//  NewProjectViewController.swift
//  Jan08SavingPal
//
//  Created by dingding on 2020/1/8.
//  Copyright © 2020 dingding. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewProjectViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UITextFieldDelegate {
    //default 預設值在textView裡面
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 2{
            numPeople.text = numberArray[0]
        }
        if textField.tag == 3{
            textField.text = dateFormatter.string(from: NSDate() as Date)
        }
    }
    //default 預設值在textView裡面
    
    //判斷 是不是一個人
    var isSingle = false 
    let dateFormatter = DateFormatter()
    
    //按下第一個確定 產生的view project
    @IBOutlet weak var generateProject: UIView!
    //按下第一個確定 產生的view project
    
    
    //ClickshowInfomation
    @IBOutlet weak var showProjectFrequency: UILabel!
    @IBOutlet weak var showProjectMoneySave: UILabel!
    @IBOutlet weak var showProjectName: UILabel!
    @IBOutlet weak var showProjectStartDate: UILabel!
    @IBOutlet weak var showProjectEndDate: UILabel!
    @IBAction func showProjectCancelBtn(_ sender: UIButton) {
        generateProject.isHidden = true
    }
    //ClickshowInfomation
    
    
    
    
    
    //結束日期
    @IBOutlet weak var endDateTextField: UITextField!
    private var dateEndPicker: UIDatePicker?
    //結束日期
    
    //開始日期
    @IBOutlet weak var startDateTextField: UITextField!
    private var datePicker: UIDatePicker?
    //開始日期
    
    
    //頻率 日/週/月
    @IBOutlet weak var mutiPickerFrequency: UITextField!
    let freqencyArray = ["每天","每週","每月"]
    var freqencyPickerView = UIPickerView()
    //頻率 日/週/月
    
    
    //人數
    @IBOutlet weak var numPeople: UITextField!
    let numberArray = ["2","3","4","5","6","7","8","9","10"]
    var numPickerView = UIPickerView()
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 0){
            return numberArray.count
        }
        return freqencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 0){
            return numberArray[row]
        }
        return freqencyArray[row]
    }
    
    var total:String?
    var freqency:String?
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 0){
            total = numberArray[row]
            numPeople.text = total
            numPeople.resignFirstResponder()
            print("number: \(numberArray[row])")
        }else if(pickerView.tag == 1){
            freqency = freqencyArray[row]
            
            mutiPickerFrequency.text = freqency
            
            let frequncyDay = ProjectModal.calculateFrequncyDay(frequencyText: mutiPickerFrequency.text!, saveDay: saveDay)
            
            frequcyTextView.text = "\(Int(frequncyDay))"
            mutiPickerFrequency.resignFirstResponder()
            print("frequency: \(freqencyArray[row])")
            
        }
    }
    //人數End
    
    
    //呈現天數
    @IBOutlet weak var frequcyTextView: UITextField!
    //呈現天數
    
    
    //顯示打字專案名稱
    @IBOutlet weak var projectName: UITextField!
    //顯示打字專案名稱
    
    
    //顯示打字專案目標
    @IBOutlet weak var projectGoal: UITextField!
    //顯示打字專案目標
    
    
    //上傳照片
    @IBOutlet weak var imgAddCarPhoto1: UIImageView!{
        didSet{
            picker1 = UIImagePickerController()
            alert1 = createAlert(picker: picker1!)
            let tap = UITapGestureRecognizer(target: self, action: #selector(showAlert1))
            //接著把設定好的偵測事件，指定給ImageView
            imgAddCarPhoto1.addGestureRecognizer(tap)
            imgAddCarPhoto1.layer.cornerRadius = imgAddCarPhoto1.bounds.height/2
            imgAddCarPhoto1.clipsToBounds = true
        }
    }
    
    
    //按確認確認確認確認確認顯示方案到首頁
    @IBAction func calculateProjectResult(_ sender: UIButton) {
        //手勢判斷按旁邊 鍵盤會收起來
        closeKeyboard()
        //手勢判斷按旁邊 鍵盤會收起來
        if projectName.text == "" || mutiPickerFrequency.text == "" || startDateTextField.text == "" || endDateTextField.text == "" || projectGoal.text == "" || numPeople.text == "" || frequcyTextView.text == ""{
            
            let myAlert = UIAlertController(title: "請填完所有格子", message: "", preferredStyle: .alert)
            
            //生出一顆按鈕 樣式default, handler是按下以後要執行甚麼？
            //要把自己dismiss掉
            let okAction = UIAlertAction(title: "OK 繼續填", style: .default)
            
            
            //myAlert掛進警告控制器裡面
            myAlert.addAction(okAction)
            
            
            present(myAlert, animated: true,completion: nil)
            
        }else{
            //顯示出 剛剛沒顯示的project
            generateProject.isHidden = false
            //顯示出 剛剛沒顯示的project
            
            //把上面打在TextField的資料顯示出來
            showProjectName.text = projectName.text
            showProjectFrequency.text = mutiPickerFrequency.text
            showProjectStartDate.text = startDateTextField.text
            showProjectEndDate.text = endDateTextField.text
            //把上面打在TextField的資料顯示出來
            
            //計算上面的邏輯
            if let goalText = projectGoal.text, let goal = Double(goalText), let numText = numPeople.text, let num = Double(numText), let frequcyText = frequcyTextView.text, let frequency = Double(frequcyText) {
                
                var money = goal / num / frequency
                money.round(.up)
                showProjectMoneySave.text = "\(Int(money))"
                //計算上面的邏輯
            }
            
            
        }
        
        
        
    }
    //按確認
    
    //上傳照片位置！！
    var picker1:UIImagePickerController?
    var alert1:UIAlertController?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgAddCarPhoto1.image = selectedImage
            imgAddCarPhoto1.contentMode = .scaleAspectFill
            imgAddCarPhoto1.clipsToBounds = true
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func createAlert(picker:UIImagePickerController) -> UIAlertController{
        let photoSourceRequestController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "拍照", style: .default, handler: {
            (action:UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .camera
                
                self.present(picker, animated: true, completion: nil)
            }
        })
        
        let photoLibraryAction = UIAlertAction(title: "選擇相片", style: .default, handler: {
            (action:UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .photoLibrary
                
                self.present(picker, animated: true, completion: nil)
            }
        })
        
        //加入取消動作
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        photoSourceRequestController.addAction(cancelAction)
        photoSourceRequestController.addAction(cameraAction)
        photoSourceRequestController.addAction(photoLibraryAction)
        return photoSourceRequestController
    }
    
    @objc func showAlert1(){
        present(alert1!, animated: true, completion: nil)
    }
    
    //上傳照片End
    
    
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //判斷是否多人或單人
        mutiPickerFrequency.text = freqencyArray[0]
        
        //        startDateTextField.text = Calendar.current.dateComponents(in: .current, from: today)
        
        if isSingle {
            numPeople.isEnabled  = false
            numPeople.text = "1"
        }
        //判斷是否多人或單人
        
        generateProject.isHidden = true 
        
        //人數
        numPickerView.delegate = self
        numPickerView.dataSource = self
        numPeople.inputView = numPickerView
        //numPeople.textAlignment = .center
        //numPeople.placeholder = "人數"
        //人數End
        freqencyPickerView.delegate = self
        freqencyPickerView.dataSource = self
        
        mutiPickerFrequency.inputView = freqencyPickerView
        
        //日期
        datePicker = UIDatePicker()
        let today = Date()
        var dateComponents = Calendar.current.dateComponents(in: .current, from: today)
        dateComponents.minute = 0
        dateComponents.hour = 0
        dateComponents.second = 0
        let todayStart = Calendar.current.date(from: dateComponents)
        
        
        
        datePicker?.minimumDate = todayStart
        datePicker?.datePickerMode = .date
        datePicker?.locale = Locale(identifier: "zh_CN")
        startDateTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        startDateTextField.inputView = datePicker
        //日期
        
        
        //設定結束日期不可以比開始日期早
        dateEndPicker = UIDatePicker()
        
        
        let tomorrow =  Calendar.current.date(byAdding: .day, value: 1, to: todayStart!)
        
        dateEndPicker?.minimumDate = tomorrow
        dateEndPicker?.datePickerMode = .date
        endDateTextField.inputView = dateEndPicker
        dateEndPicker?.addTarget(self, action: #selector(dateEndChanged(datePicker:)), for: .valueChanged)
        dateEndPicker?.locale = Locale(identifier: "zh_CN")
        endDateTextField.inputView = dateEndPicker
        
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        //設定日期居區間
        //        datePicker?.minimumDate = dateFormatter.date(from: "NSDate()")
        
        //兩種picker判斷
        numPickerView.tag = 0
        freqencyPickerView.tag = 1
        //兩種picker判斷
        
        //手勢判斷按旁邊 鍵盤會收起來
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
        //手勢判斷按旁邊 鍵盤會收起來
        
    }
    
    var startDate :Date?
    var endDate :Date?
    
    @objc func dateEndChanged(datePicker: UIDatePicker){
        let getEndDate = dateFormatter.string(from: datePicker.date)
        endDateTextField.text = getEndDate
        print(getEndDate)
        //endDate = Date(endDateTextField.text)
        //view.endEditing(true)
        endDate = dateFormatter.date(from: getEndDate)
        let days = startDate?.daysBetweenDate(toDate: endDate!)
        frequcyTextView.text = days?.description
        if let days = days {
            saveDay = Double(days)
        }
    }
    
    var saveDay: Double = 0
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let getStartDate = dateFormatter.string(from: datePicker.date)
        startDateTextField.text = getStartDate
        print(getStartDate)
        startDate = dateFormatter.date(from: getStartDate)
        
        dateEndPicker?.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate!)
        //view.endEditing(true)
        //            let days = startDate?.daysBetweenDate(toDate: endDate!)
        //            frequcyTextView.text = days?.description
    }
    
    @objc func closeKeyboard(){
        self.view.endEditing(true)
        //numPeople.text = total
    }
    
    
    // 裡面的顯示出來的button
    @IBAction func showProjectConfirm(_ sender: Any) {
        //上傳照片
//        NetWorkController.sharedInstance.updateWithImage(api:"/avatars/", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwb3N0Ijp7InVzZXJfaWQiOiIxMTI4MDU4MTMxNzc3Njc1OTY2NzIiLCJ1c2VyX2VtYWlsIjoic3VjaHVuZGluZ0BnbWFpbC5jb20iLCJ1c2VyX25hbWUiOiJTdWNodW4gVGluZyJ9LCJpYXQiOjE1Nzg1NDQxMTcsImV4cCI6MTU3ODYzMDUxN30.MenSRJIPtiEzd1_427CXN00Wz6ASai74oIIctw9N4VY", params: ["projectId":2], img: imgAddCarPhoto1.image!, imgWithName: "projectImage", callBack: {(jsonData) in
//            print(jsonData)
//        })
        
        let params:[String:Any] = ["project_name": showProjectName.text!,
                                "project_target" : projectGoal.text!,
                                   "project_freq" : mutiPickerFrequency.text!,
                                   "project_start" : showProjectStartDate.text!,
                                   "project_end" : showProjectEndDate.text!,
                                   "project_count" : frequcyTextView.text!,
                                   "project_number": numPeople.text!]
        
        if let me = UserModel.me {
            
        
            //112805813177767596672
            NetWorkController.sharedInstance.connectApiByPost(api: "/projects/\(me.userId!)",token: me.token! ,params: params) { (result) in
                print("\(result.description) click")
                
                self.navigationController?.popViewController(animated: true)

            }
            
        }
        
        
//        let goal = Double(projectGoal.text!) ?? 0
//
//        let peopleCount = Int(numPeople.text!) ?? 1
//
//        let project = ProjectModal(projectName: projectName.text!,
//                                   projectTarget: goal,
//                                   projectFreq: mutiPickerFrequency.text!,
//                                   projectStart: startDate!,
//                                   projectEnd: endDate!,
//                                   projectNumber: peopleCount,
//                                   saveMoney: 0,
//                                   projectId: 0,
//                                   projectPhoto: <#T##String?#>,
//                                   status: <#T##Int#>)
            
            
//            name: projectName.text!,
//                                   goal: goal,
//                                   frequency: mutiPickerFrequency.text!,
//                                   startDate: startDate!,
//                                   endDate: endDate!,
//                                   peopleCount: peopleCount,
//                                   saveMoney: 0)
        
//        var projects = ProjectModal.readProjectsFromFile() ?? [ProjectModal]()
//        projects.append(project)
//        ProjectModal.saveToFile(projects: projects)
//        
        
    }
}



extension Date{
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
}
