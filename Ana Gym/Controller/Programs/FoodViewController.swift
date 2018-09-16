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

class FoodViewController: UIViewController {

    var PID: Int!
    var FID: Int!
    var food: Food!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var playSign: UIImageView!
    
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
                if let img = self.food.videoThumb, img != ""{
                    let imgurl = URL(string: img)!
                    self.thumb.kf.indicatorType = .activity
                    self.thumb.kf.setImage(with: imgurl)
                    self.playSign.alpha = 1
                }
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func didPressPlay(_ sender: Any){
        var url : URL?
        if let videourl = URL(string: food.video ?? ""){
            url = videourl
            
            
            
            UIApplication.shared.openURL(url!)
        }
    }

}
