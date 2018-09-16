//
//  ProfileViewController.swift
//  Ana Gym
//
//  Created by Esslam Emad on 3/9/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import RZTransitions

class ProfileViewController: UIViewController {

    var color1 = UIColor(red: 79.0 / 255.0, green: 189.0 / 255.0, blue: 178.0 / 255.0, alpha: 1.0).cgColor
    var color2 = UIColor(red: 80.0 / 255.0, green: 227.0 / 255.0, blue: 194.0 / 255.0, alpha: 1.0).cgColor
    var borderColor = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0).cgColor
    
    
    var user: User!
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var sexIcon: UIImageView!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var myProgramsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "rectangle"), for: .default)
        
        user = Auth.auth.user!
        nameLabel.text = user.username
        heightLabel.text = String(user.height) + NSLocalizedString(" سم", comment: "")
        weightLabel.text = String(user.weight) + NSLocalizedString(" كجم", comment: "")
        switch user.gender {
        case 1:
            sexLabel.text = NSLocalizedString("ذكر", comment: "")
            sexIcon.image = UIImage(named: "male-user")
        default:
            sexLabel.text = NSLocalizedString("أنثى", comment: "")
            sexIcon.image = UIImage(named: "woman-avatar")
        }
        phoneLabel.text = user.phone
        editView.layer.borderWidth = 2
        myProgramsView.layer.borderWidth = 2
        editView.layer.borderColor = borderColor
        myProgramsView.layer.borderColor = borderColor
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = upperView.bounds
        gradientLayer.colors = [color1, color2]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        upperView.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressEditProfile(_ sender: Any) {
    }
    
    @IBAction func didPressMyPrograms(_ sender: Any) {
        performSegue(withIdentifier: "Show My Programs", sender: nil)
    }
    
    @IBAction func unwindToProfile(_ sender: UIStoryboardSegue) {
      //  self.showAlert(error: false, withMessage: NSLocalizedString("تم تعديل الملف الشخصي بنجاح.", comment: ""), completion: nil)
        viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show My Programs"{
            
            let destination = segue.destination as! ProgramsTableViewController
            destination.myPrograms = true
        }
    }

}
