//
//  MoreViewController.swift
//  Ana Gym
//
//  Created by Esslam Emad on 16/9/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD
import RZTransitions

class MoreViewController: UIViewController {

    var register = false
    var id: Int!
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = RZTransitionsManager.shared()
        if register{
            button.alpha = 1
            button.isHidden = false
        }
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getPage(id: id))
            }.done{
                let page = try! JSONDecoder().decode(Page.self, from: $0)
                self.titleLabel.text = page.title
                self.detailsLabel.attributedText = page.content.html2AttributedString
            } .catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func didPressBack(_ sender: Any?){
        switch id{
        case 3:
            performSegue(withIdentifier: "Checkout", sender: nil)
        default:
            performSegue(withIdentifier: "Register", sender: nil)
            
        }
    }


}
