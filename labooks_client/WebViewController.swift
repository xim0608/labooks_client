//
//  WebViewController.swift
//  labooks_client
//
//  Created by 和田龍樹 on 2017/07/20.
//  Copyright © 2017年 jp.wada. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        webView.delegate = self
        super.viewDidLoad()
        let urlString = "https://elegant-bastille-81866.herokuapp.com/api/rentals/18115233"
        var request = URLRequest(url: URL(string:urlString)!)
        webView.loadRequest(request)

        

        // Do any additional setup after loading the view.
    }

    @IBAction func backToTop(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}