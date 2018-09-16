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

class NutritionViewController: UIViewController {

    var NID: Int!
    var PID: Int!
    var nutrition: Nutrition!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
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
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
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
