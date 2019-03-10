//
//  FoodViewController.swift
//  Ana Gym
//
//  Created by Esslam Emad on 5/9/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit
import WebKit

class FoodViewController: UIViewController, UIDocumentInteractionControllerDelegate, WKNavigationDelegate {

    var PID: Int!
    var FID: Int!
    var food: Food!
    var photo: String!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var playSign: UIImageView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var bigView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchFood()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }

    func fetchFood(){
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getFood(programID: PID, userID: Auth.auth.user!.id, foodID: FID))
            }.done {
                self.food = try! JSONDecoder().decode(Food.self, from: $0)
                self.nameLabel.text = self.food.name
                self.detailsLabel.attributedText = self.food.details.html2AttributedString
                print(self.food.video ?? "")
                print(self.food.videoThumb ?? "")
                if let img = self.food.videoThumb, img != ""{
                    let imgurl = URL(string: img)!
                    self.thumb.kf.indicatorType = .activity
                    self.thumb.kf.setImage(with: imgurl)
                    //self.playSign.alpha = 1
                }else {
                    self.bigView.isHidden = true
                }
                if self.food.file == nil{
                    self.downloadButton.alpha = 0
                    self.downloadButton.isHidden = true
                } else {
                    self.downloadButton.isEnabled = true
                    
                }
                self.didPressPlay(nil)
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func didPressPlay(_ sender: Any?){
        if let videourl = URL(string: food.video ?? ""){
           // performSegue(withIdentifier: "Video", sender: videourl)
            let webView = WKWebView(frame: self.bigView.frame)
            var request: URLRequest!
            request = URLRequest(url: videourl)
            
            thumb.alpha = 0
            webView.alpha = 1
            bigView.addSubview(webView)
            webView.center = bigView.center
            webView.navigationDelegate = self
            webView.load(request)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Video"{
            let destination = segue.destination as! VideoViewController
            destination.url = (sender as! URL)
        }
    }
    
    @IBAction func didPressDownload(_ sender: Any){
        
        downloadButton.isEnabled = false
        downloadButton.setTitle(NSLocalizedString("جاري التحميل...", comment: ""), for: .normal)
        
        // Downloader(self).download(url: URL(string: calory.file!)!)
        //self.view.makeToastActivity(message: "Downloading...")
        let fileURL = URL(string: self.food.file!)!
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        let destinationFileUrl = documentsUrl.appendingPathComponent(fileURL.lastPathComponent)
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url:fileURL)
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil
            {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode
                {
                    //self.showAlert(error: false, withMessage: NSLocalizedString("تم التحميل بنجاح، من فضلك إنتظر لحظة حتى يتم فتح الملف.", comment: ""), completion: nil)
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                do
                {
                    if(FileManager.default.fileExists(atPath: destinationFileUrl.path))
                    {
                        try FileManager.default.removeItem(at: destinationFileUrl)
                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                        self.showFileWithPath(path: destinationFileUrl.path)
                        //self.view.hideToastActivity()
                    }
                    else
                    {
                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                        self.showFileWithPath(path: destinationFileUrl.path)
                        //self.view.hideToastActivity()
                    }
                }
                catch (let writeError)
                {
                    //self.view!.makeToast(message: "Download Failed Try Again Later", duration: 2.0, position: HRToastPositionCenter as AnyObject)
                    self.downloadButton.setTitle(NSLocalizedString("إضغط لتحميل ملف التغذية", comment: ""), for: .normal)
                    self.downloadButton.isEnabled = true
                    self.showAlert(withMessage: NSLocalizedString("حدث خطأ أثناء قراءة الملف", comment: ""))
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
            }
            else
            {
                // self.view!.makeToast(message: "Download Failed Try Again Later", duration: 2.0, position: HRToastPositionCenter as AnyObject)
                self.downloadButton.setTitle(NSLocalizedString("إضغط لتحميل ملف التغذية", comment: ""), for: .normal)
                self.downloadButton.isEnabled = true
                self.showAlert(withMessage: NSLocalizedString("حدث خطأ أثناء تحميل الملف", comment: ""))
                print("Error took place while downloading a file. Error description");
            }
        }
        task.resume()
    }
    
    func showFileWithPath(path: String)
    {
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        if isFileFound == true
        {
            self.downloadButton.setTitle(NSLocalizedString("تم التحميل بنجاح", comment: ""), for: .normal)
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            viewer.presentPreview(animated: true)
        } else{
            self.downloadButton.setTitle(NSLocalizedString("إضغط لتحميل ملف التغذية", comment: ""), for: .normal)
            self.downloadButton.isEnabled = true
            self.showAlert(withMessage: NSLocalizedString("حدث خطأ أثناء قراءة الملف", comment: ""))
        }
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
}
