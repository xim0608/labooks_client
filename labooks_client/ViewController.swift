//
//  ViewController.swift
//  AVCaptureMetadataOutputSample_EAN13CodeReader
//
//  Created by hirauchi.shinichi on 2016/12/21.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var studentNumLabel: UILabel!
    
    let detectionArea = UIView()
    
    var timer: Timer!
    var counter = 0
    var isDetected = false
    var studentNum:String = ""
    var books_isbn: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        studentNumLabel.textAlignment = .center
        studentNumLabel.text = studentNum
        
        
        // セッションのインスタンス生成
        let captureSession = AVCaptureSession()
        
        // 入力（背面カメラ）
        let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let videoInput = try! AVCaptureDeviceInput.init(device: videoDevice)
        captureSession.addInput(videoInput)

        // 出力（ビデオデータ）
        let metadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metadataOutput)
        
        // メタデータを検出した際のデリゲート設定
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        // EAN-13コードの認識を設定
        metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code]
        
        // 検出エリアのビュー
        let x: CGFloat = 0.05
        let y: CGFloat = 0.3
        let width: CGFloat = 0.9
        let height: CGFloat = 0.2
        
        detectionArea.frame = CGRect(x: view.frame.size.width * x, y: view.frame.size.height * y, width: view.frame.size.width * width, height: view.frame.size.height * height)
        detectionArea.layer.borderColor = UIColor.red.cgColor
        detectionArea.layer.borderWidth = 3
        view.addSubview(detectionArea)

        // 検出エリアの設定
        metadataOutput.rectOfInterest = CGRect(x: y,y: 1-x-width,width: height,height: width)
        
        // プレビュー
        if let videoLayer = AVCaptureVideoPreviewLayer.init(session: captureSession) {
            videoLayer.frame = previewView.bounds
            videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            previewView.layer.addSublayer(videoLayer)
        }
        
        // セッションの開始
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // 複数のメタデータを検出できる
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            // EAN-13Qコードのデータかどうかの確認
            if metadata.type == AVMetadataObjectTypeEAN13Code || metadata.type == AVMetadataObjectTypeEAN8Code{
                if metadata.stringValue != nil {
                    // 検出データを取得
                    counter = 0
                    if !isDetected || label.text != metadata.stringValue! {
                        isDetected = true
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) // バイブレーション
                        label.text = metadata.stringValue!
//                        print(self.books_isbn.index(of: metadata.stringValue!))
                        if self.books_isbn.index(of: metadata.stringValue!) == nil {
                            print(metadata.stringValue!)
                            self.books_isbn.append(metadata.stringValue!)
                        }
                        
                        detectionArea.layer.borderColor = UIColor.white.cgColor
                        detectionArea.layer.borderWidth = 5
                    }
                }
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        timer.invalidate()
        self.books_isbn = []
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBooksData(_ sender: Any) {
        print(self.books_isbn)
        let urlString = "https://elegant-bastille-81866.herokuapp.com/api/process"
        var request = URLRequest(url: URL(string:urlString)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let params: [String: Any] = [
            "student_id": self.studentNum,
            "books": self.books_isbn
        ]
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        }catch{
            print(error.localizedDescription)
        }
        // use NSURLSessionDataTask
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            if (error == nil) {
                let result = String(data: data!, encoding: .utf8)!
                print(result)
            } else {
                print(error ?? "")
            }
        })
        task.resume()
        performSegue(withIdentifier: "showRentalData", sender: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func update(tm: Timer) {
        counter += 1
        print(counter)
        if 1 < counter {
            detectionArea.layer.borderColor = UIColor.red.cgColor
            detectionArea.layer.borderWidth = 3
            label.text = ""
        }
    }
    
}

