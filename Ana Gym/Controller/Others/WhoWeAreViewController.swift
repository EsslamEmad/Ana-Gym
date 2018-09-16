//
//  WhoWeAreViewController.swift
//  Ana Gym
//
//  Created by Esslam Emad on 6/9/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit

class WhoWeAreViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "rectangle"), for: .default)

        firstly{
            return API.CallApi(APIRequests.getPage(id: 1))
            }.done {
                let page = try! JSONDecoder().decode(Page.self, from: $0)
                self.titleLabel.text = page.title
                self.contentLabel.attributedText = page.content.html2AttributedString
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }

}
