//
//  NutritionViewController.swift
//  Ana Gym
//
//  Created by Esslam Emad on 1/9/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit

class NutritionViewController: UIViewController, UIDocumentInteractionControllerDelegate {

    var NID: Int!
    var PID: Int!
    var nutrition: Nutrition!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchNutrition()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    func fetchNutrition(){
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getNutrition(programID: PID, userID: Auth.auth.user!.id, nutritionID: NID))
            }.done {
                self.nutrition = try! JSONDecoder().decode(Nutrition.self, from: $0)
                self.nameLabel.text = self.nutrition.name
                self.detailsLabel.attributedText = self.nutrition.details.html2AttributedString
                if self.nutrition.file == nil{
                    self.downloadButton.alpha = 0
                    self.downloadButton.isHidden = true
                } else {
                    self.downloadButton.isEnabled = true
                    
                }
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func didPressDownload(_ sender: Any){
        
        downloadButton.isEnabled = false
        downloadButton.setTitle(NSLocalizedString("جاري التحميل...", comment: ""), for: .normal)
        
        // Downloader(self).download(url: URL(string: calory.file!)!)
        //self.view.makeToastActivity(message: "Downloading...")
        let fileURL = URL(string: self.nutrition.file!)!
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

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
}
