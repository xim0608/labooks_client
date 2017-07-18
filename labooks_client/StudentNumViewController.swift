//
//  StudentNumViewController.swift
//  labooks_client
//
//  Created by 和田龍樹 on 2017/07/18.
//  Copyright © 2017年 jp.wada. All rights reserved.
//

import UIKit

class StudentNumViewController: UIViewController {

    @IBOutlet weak var studentNumber: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.updateSendButttonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func studentNumFieldChanged(_ sender: Any) {
        self.updateSendButttonState()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let identifier = segue.identifier else{
            return
        }
        if identifier == "addBook"{
            let VC = segue.destination as! ViewController
            VC.studentNum = self.studentNumber.text ?? ""
            
        }
    }
    
    private func updateSendButttonState(){
        let studentNum = self.studentNumber.text ?? ""
        self.sendButton.isEnabled = !studentNum.isEmpty
    }

}
