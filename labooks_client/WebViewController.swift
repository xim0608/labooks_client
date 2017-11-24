//
//  WebViewController.swift
//  labooks_client
//
//  Created by 和田龍樹 on 2017/07/20.
//  Copyright © 2017年 jp.wada. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class WebViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    var cellItems = NSMutableArray()
    let cellNum = 10
    var items: [JSON] = []
    var studentNum: String = ""
    var books_isbn: [String] = []
    @IBOutlet weak var tableView: UITableView!
    
    
//    tableView.dataSource = self
//    self.view.addSubview(tableView)

    override func viewDidLoad() {
        
        super.viewDidLoad()
//        var itemArray: NSMutableArray = []
        let tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        
        
        
//        usleep(3000000)
        let params: [String:Any] = [
            "studentNum": self.studentNum,
            "books_isbn": self.books_isbn
        ]
        let postURL = Const.baseUrl + "api/process"
        Alamofire.request(postURL, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                debugPrint(response)
                let json = JSON(response.result.value ?? 0)
                json.forEach{(_, data) in
                    self.items.append(data)
                }
                tableView.reloadData()
                
        }
    
//        webView.delegate = self
//        let urlString = Const.baseUrl + self.studentNum
//        var request = URLRequest(url: URL(string:urlString)!)
//        webView.loadRequest(request)

        

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backToTop(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // tableのcellにAPIから受け取ったデータを入れる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TableCell")
        cell.textLabel?.text = items[indexPath.row]["title"].string
        cell.detailTextLabel?.text = "著者 : \(items[indexPath.row]["author"].stringValue)"
        return cell
    }

    // cellの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
