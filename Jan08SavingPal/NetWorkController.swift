//
//  NetWorkController.swift
//  SavingPalJan01
//
//  Created by 丁丁丁 on 2020/1/2.
//  Copyright © 2020 ding. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class NetWorkController: NSObject {
    // 伺服器網址
    static let rootUrl : String = "http://35.185.170.23:3000/api"
    
    // 單例
    static let sharedInstance = NetWorkController()
    
    var alamofireManager:Alamofire.SessionManager!
    
    fileprivate override init() {
        // 初始化
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 20
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    
    
    
    func connectApiByPost(api : String,token : String,params : Dictionary<String, Any>, callBack:((JSON) -> ())?){
        
        alamofireManager.request(NetWorkController.rootUrl + api, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization":"Bearer " + token])
            .validate(statusCode: 200 ..< 500).responseJSON
            {
                (response) in
                if response.result.isSuccess{
                    let jsonData = try! JSON(data: response.data!)
                    
                    //                    let token = jsonData["data"]["token"].stringValue
                    //                    let token = data["token"]?.stringValue
                    //                    print(token)
                    //                    let status = jsonData.dictionary!["Status Code"]?.int
                    //
                    //                    if status == 200 {
                    //                        callBack?(jsonData)
                    //                        print("請求成功 \(String(describing: response.result.value))")
                    //                    }else{
                    //                        print("請求失敗 callBack 後端寫錯那種: \(response.debugDescription)")
                    //                    }
                    
                    print("請求成功 \(String(describing: response.result.value))")
                    callBack?(jsonData)
                    
                }else{
                    print("請求失敗 callBack onFailure那種: \(response.debugDescription)")
                }
        }
    }
    
    
    func connectApiLogin(api : String,params : Dictionary<String, Any>, callBack:((JSON) -> ())?){
        
        alamofireManager.request(NetWorkController.rootUrl + api, method: .post, parameters: params, encoding: JSONEncoding.default, headers:[:])
            .validate(statusCode: 200 ..< 500).responseJSON
            {
                (response) in
                if response.result.isSuccess{
                    let jsonData = try! JSON(data: response.data!)
                    
                    //                    let token = jsonData["data"]["token"].stringValue
                    //                    let token = data["token"]?.stringValue
                    //                    print(token)
                    //                    let status = jsonData.dictionary!["Status Code"]?.int
                    //
                    //                    if status == 200 {
                    //                        callBack?(jsonData)
                    //                        print("請求成功 \(String(describing: response.result.value))")
                    //                    }else{
                    //                        print("請求失敗 callBack 後端寫錯那種: \(response.debugDescription)")
                    //                    }
                    
                    print("請求成功 \(String(describing: response.result.value))")
                    callBack?(jsonData)
                    
                }else{
                    print("請求失敗 callBack onFailure那種: \(response.debugDescription)")
                }
        }
    }
    
    func saveMoney(projectId: Int, date: String, money: Int, completionHandler: @escaping (Bool)->() ) {
        if let me = UserModel.me, let url = URL(string: NetWorkController.rootUrl)?.appendingPathComponent("histories/\(me.userId!)") {
            
            var request = URLRequest(url: url)
            request.setValue("Bearer " + me.token!, forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            let postString = "project_id=\(projectId)&history_date=\(date)&money=\(money)"
            let postData = postString.data(using: .utf8)
            
            URLSession.shared.uploadTask(with: request, from: postData) { (data, response, error) in
                
                if let data = data {
                    
                    
                    print(String(data: data, encoding: .utf8))
                    let decoder = JSONDecoder()
                    
                    
                    if let saveMoneyReturnData = try? decoder.decode(SaveMoneyReturnData.self, from: data), saveMoneyReturnData.errorCode == -1 {
                        
                        completionHandler(true)
                        
                    } else {
                        print("parse error")
                        completionHandler(false)
                        
                    }
                    
                } else {
                    completionHandler(false)
                }
                
                
                
            }.resume()
            
            
            
        }
    }
    
    func getHistories(projectId: Int, completionHandler: @escaping (History?)->() ) {
           if let me = UserModel.me, let url = URL(string: NetWorkController.rootUrl)?.appendingPathComponent("histories/\(me.userId!)/\(projectId)") {
               
               var request = URLRequest(url: url)
               request.setValue("Bearer " + me.token!, forHTTPHeaderField: "Authorization")
               
               
               URLSession.shared.dataTask(with: request) { (data, response, error) in
                   if let data = data {
                       
                       
                       print(String(data: data, encoding: .utf8))
                       let decoder = JSONDecoder()
                       decoder.keyDecodingStrategy = .convertFromSnakeCase
                       
                                           do {
                                               try decoder.decode(HistoryData.self, from: data)
                                           } catch {
                                               print(error)
                                           }
                       
                       if let historyData = try? decoder.decode(HistoryData.self, from: data) {
                        completionHandler(historyData.data)
                           
                       } else {
                           print("parse error")
                           completionHandler(nil)
                           
                       }
                       
                   } else {
                       completionHandler(nil)
                   }
               }.resume()
               
           }
           
       }
       
    
    func getProjects(completionHandler: @escaping ([ProjectModal]?)->() ) {
        if let me = UserModel.me, let url = URL(string: NetWorkController.rootUrl)?.appendingPathComponent("projects/\(me.userId!)") {
            
            var request = URLRequest(url: url)
            request.setValue("Bearer " + me.token!, forHTTPHeaderField: "Authorization")
            
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    
                    
                    print(String(data: data, encoding: .utf8))
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd"
                    decoder.dateDecodingStrategy = .formatted(formatter)
                    //
                    //                    do {
                    //                        try decoder.decode(ProjectData.self, from: data)
                    //                    } catch {
                    //                        print(error)
                    //                    }
                    
                    if let projectData = try? decoder.decode(ProjectData.self, from: data) {
                        completionHandler(projectData.data)
                        
                    } else {
                        print("parse error")
                        completionHandler(nil)
                        
                    }
                    
                } else {
                    completionHandler(nil)
                }
            }.resume()
            
        }
        
    }
    
    func get(api : String, callBack:((JSON) -> ())?){
        alamofireManager.request(NetWorkController.rootUrl + api, encoding: JSONEncoding.default, headers: [:])
            .validate(statusCode: 200 ..< 500).responseJSON
            {
                (response) in
                if response.result.isSuccess{
                    let jsonData = try! JSON(data: response.data!)
                    //                    let status = jsonData.dictionary!["Status Code"]?.int
                    //
                    //                    if status == 200 {
                    //                        callBack?(jsonData)
                    //                        print("請求成功 \(String(describing: response.result.value))")
                    //                    }else{
                    //                        print("請求失敗 callBack 後端寫錯那種: \(response.debugDescription)")
                    //                    }
                    
                    print("請求成功 \(String(describing: response.result.value))")
                    callBack?(jsonData)
                    
                }else{
                    print("請求失敗 callBack onFailure那種: \(response.debugDescription)")
                }
        }
    }
    //上傳照片
    func updateWithImage(api : String, token:String, params : Dictionary<String, Any>, img:UIImage, imgWithName:String, callBack:((JSON) -> ())?){
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in params {
                    if let value = value as? String{
                        multipartFormData.append(value.data(using:.utf8)!, withName: key)
                    }
                    if let value = value as? Int{
                        multipartFormData.append("(value)".data(using:.utf8)!, withName: key)
                    }
                }
                
                //參數解釋：
                //withName:和後臺伺服器的name要一致 ；fileName:可以充分利用寫成使用者的id，但是格式要寫對；mimeType：規定的，要上傳其他格式可以自行百度查一下
                if let imageData = img.jpegData(compressionQuality:0.3){
                    multipartFormData.append(imageData, withName: imgWithName, fileName: "test.jpg", mimeType: "image/jpeg")
                }
                
                
        },to: NetWorkController.rootUrl + api, method:.post, headers:["Authorization":"Bearer " + token, "Content-Type":"multipart/form-data"], encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                //連線伺服器成功後，對json的處理
                upload.responseJSON {
                    response in
                    
                    //解包
                    guard let result = response.result.value else { return }
                    print("請求成功\(result)")
                    //                    callBack?(result as! JSON)
                }
                //獲取上傳進度
                upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                    print("圖片上傳進度: \(progress.fractionCompleted)")
                }
            case .failure(let encodingError):
                //列印連線失敗原因
                print(encodingError)
            }
        })
    }
    //上傳照片
    
    
    
    
    
}
