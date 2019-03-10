//
//  SideMenuTableViewController.swift
//  Ana Gym
//
//  Created by Esslam Emad on 17/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {

    @IBOutlet weak var programsButton: UIButton!
   // @IBOutlet weak var productsButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var whoWeAreButton: UIButton!
    @IBOutlet weak var contactUsButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        programsButton.titleEdgeInsets.right = 55
       // productsButton.titleEdgeInsets.right = 55
        profileButton.titleEdgeInsets.right = 55
        whoWeAreButton.titleEdgeInsets.right = 55
        contactUsButton.titleEdgeInsets.right = 55
        logOutButton.titleEdgeInsets.right = 55
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logOut(_ sender: Any){
        let alert = UIAlertController(title: NSLocalizedString("تسجيل الخروج", comment: ""), message: NSLocalizedString("هل ترغب حقًا في تسجيل الخروج؟", comment: ""), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: NSLocalizedString("نعم", comment: ""), style: .default, handler: {(UIAlertAction) in
                Auth.auth.logout()
            self.performLoginSegue()
        })
        let noAction = UIAlertAction(title: NSLocalizedString("لا", comment: ""), style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    func performLoginSegue(animated: Bool = true){
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        self.dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        vc.view.frame = rootViewController.view.frame
        window.rootViewController?.dismiss(animated: true, completion: nil)
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        })
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
