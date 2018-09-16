//
//  SubscribedProgramTableViewController.swift
//  Ana Gym
//
//  Created by Esslam Emad on 29/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit
import AVFoundation
import AVKit

class SubscribedProgramTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var delegate = cellDelegate()
    var nutritionDelegate = caloryCellDelegate()
    var foodDelegate = foodCellDelegate()
    var pending = false
    var program: Program!
    var nutritionMaleCount = 0
    var nutritionFemaleCount = 0
    var nutritionCount = 0
   
    var trainingCount = 0
    var trainingOn = true
    var color1 = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    var color2 = UIColor(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 1.0)
    var training = true
    var sex = true
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var programImage: UIImageView!
    @IBOutlet weak var trainingButton: UIButton!
    @IBOutlet weak var nutritionButton: UIButton!
    @IBOutlet weak var trainingCollectionView: UICollectionView!
    @IBOutlet weak var maleTableView: UITableView!
    @IBOutlet weak var femaleTableView: UITableView!
    @IBOutlet weak var nutritionTableView: UITableView!
    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var playSign: UIImageView!
    
    @IBOutlet weak var LunchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stack.alpha = 0
        trainingCollectionView.delegate = self
        trainingCollectionView.dataSource = self
        maleTableView.delegate = delegate
        maleTableView.dataSource = delegate
        femaleTableView.dataSource = delegate
        femaleTableView.delegate = delegate
        nutritionTableView.delegate = nutritionDelegate
        nutritionTableView.dataSource = nutritionDelegate
        foodTableView.delegate = foodDelegate
        foodTableView.dataSource = foodDelegate
        
        fetchProgram()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // SVProgressHUD.dismiss()
    }
    
    func fetchProgram(){
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getSubscribedProgramForUser(programID: program.id, userID: (Auth.auth.user?.id)!))
            }.done {
                self.program = try! JSONDecoder().decode(Program.self, from: $0)
                guard self.program.subscribtionState == "subscribed" else {
                    self.pendingProgram()
                    return
                }
                if self.program.training == nil {
                    self.training = false
                    self.sex = false
                } else if self.program.nutrition == nil {
                    self.training = true
                    self.sex = true
                } else {
                    self.training = true
                    self.sex = false
                }
                self.theMasterMindFunction()
            }.catch { error in
                self.showAlert(withMessage: NSLocalizedString("حدث خطأ في الحصول على بيانات البرنامج، من فضلك أعد المحاولة لاحقًا", comment: ""))
                print(error.localizedDescription)
                self.title = NSLocalizedString("خطأ", comment: "")
            }.finally {
                SVProgressHUD.dismiss()
        }
    }

    func theMasterMindFunction(){
        
        if !training{
            
            trainingButton.setTitle(NSLocalizedString("الإفطار", comment: ""), for: .normal)
            nutritionButton.setTitle(NSLocalizedString("السناكات", comment: ""), for: .normal)
            LunchButton.setTitle(NSLocalizedString("الغذاء/العشاء", comment: ""), for: .normal)
        } else if !sex{
            nutritionDelegate.nutritionCount = program.nutrition!.count
            nutritionDelegate.program = program
            trainingCount = program.training!.count
            LunchButton.isHidden = true
        }else {
            self.delegate.maleCount = self.program.nutritionMale?.count ?? 0
            self.delegate.femaleCount = self.program.nutritionFemale?.count ?? 0
            self.delegate.program = self.program
            self.trainingCount = self.program.training?.count ?? 0
            LunchButton.isHidden = true
        }
        stack.alpha = 1.0
        self.nutritionTableView.reloadData()
        self.maleTableView.reloadData()
        self.femaleTableView.reloadData()
        self.trainingCollectionView.reloadData()
        self.nameLabel.text = self.program.name
        self.subtitleLabel.text = self.program.subtitle
        self.title = self.program.name
        tableView.reloadData()
        self.didPressTraining(nil)
    }
    
    func pendingProgram(){
        pending =  true
        self.nameLabel.text = self.program.name
        self.subtitleLabel.text = self.program.subtitle
        self.title = self.program.name
        if program.mainVideoThumb != nil, let imgurl = URL(string: program.mainVideoThumb ?? ""){
            programImage.kf.indicatorType = .activity
            programImage.kf.setImage(with: imgurl)
            playSign.alpha = 1.0
        }
        let alert = UIAlertController(title: NSLocalizedString("قيد الإنتظار", comment: ""), message: NSLocalizedString("عفواً، لم يتم تفعيل إشتراكك لهذا البرنامج بعد.", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("حسنًا", comment: ""), style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didPressNutrition(_ sender: Any) {
        
        trainingButton.backgroundColor = color1
        nutritionButton.backgroundColor = color2
        LunchButton.backgroundColor = color1
        
        if program.nutritionVideoThumb != nil, let imgurl = URL(string: program.nutritionVideoThumb ?? ""){
            programImage.kf.indicatorType = .activity
            programImage.kf.setImage(with: imgurl)
            playSign.alpha = 1.0
        } else {
            let imgurl = URL(string: program.photo)
            programImage.kf.indicatorType = .activity
            programImage.kf.setImage(with: imgurl)
            playSign.alpha = 0
        }
        guard training else {
            foodDelegate.food = program.snacks
            foodTableView.reloadData()
            return
        }
        trainingOn = false
        tableView.reloadData()
        
    }
    @IBAction func didPressTraining(_ sender: Any?) {
        
        trainingButton.backgroundColor = color2
        nutritionButton.backgroundColor = color1
        LunchButton.backgroundColor = color1
        if program.trainingVideoThumb != nil, let imgurl = URL(string: program.trainingVideoThumb ?? ""){
            programImage.kf.indicatorType = .activity
            programImage.kf.setImage(with: imgurl)
            playSign.alpha = 1.0
        } else {
            let imgurl = URL(string: program.photo)
            programImage.kf.indicatorType = .activity
            programImage.kf.setImage(with: imgurl)
           // playSign.alpha = 1
        }
        guard training else {
            foodDelegate.food = program.breakfast
            foodTableView.reloadData()
            return
        }
        trainingOn = true
        tableView.reloadData()
    }
    @IBAction func didPressLunch(_ sender: Any){
        trainingButton.backgroundColor = color1
        nutritionButton.backgroundColor = color1
        LunchButton.backgroundColor = color2
        foodDelegate.food = program.lunchDinner
        foodTableView.reloadData()
    }
    @IBAction func didPressPlay(_ sender: Any) {
        
        /*guard let videoUrl = URL(string: "https://www.youtube.com/watch?v=E3DdozJHxC0.mpeg4") else {
            print("X")
            return
 }*/
        var url : URL?
        guard !pending else {
            if let videourl = URL(string: program.mainVideo){
                url = videourl
                UIApplication.shared.openURL(url!)
            }
            return
        }
        
        if let videourl = URL(string: program.trainingVideo), trainingOn{
            url = videourl
        }
        else if let videourl = URL(string: program.nutritionVideo), !trainingOn {
            url = videourl
        }
        if url != nil{
            UIApplication.shared.openURL(url!)
        }
        /*self.player.playerDelegate = self
        self.player.playbackDelegate = self
        self.player.view.frame = self.view.bounds
        
        self.addChildViewController(self.player)
        self.tableView.addSubview(self.player.view)
        self.player.didMove(toParentViewController: self)
        self.player.url = videoUrl
        self.player.playbackLoops = true
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.player.view.addGestureRecognizer(tapGestureRecognizer)
        self.player.playFromBeginning()
        print("A")*/
        
    }
    @IBAction func didPressDay(_ sender: UIButton) {
        performSegue(withIdentifier: "Show Training", sender: program.training![sender.tag].id)
    }
    @IBAction func didPressNutritionMale(_ sender: UIButton) {
        performSegue(withIdentifier: "Show Nutrition", sender: [sender.tag, true])
    }
    @IBAction func didPressNutritionFemale(_ sender: UIButton) {
        performSegue(withIdentifier: "Show Nutrition", sender: [sender.tag, false])
    }
    @IBAction func didPressCalory(_ sender: UIButton){
        performSegue(withIdentifier: "Show Calory", sender: sender.tag)
    }
    @IBAction func didPressFood(_ sender: UIButton){
        performSegue(withIdentifier: "Show Food", sender: sender.tag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Training"{
            let destination = segue.destination as! TrainingViewController
            destination.PID = program.id
            destination.TID = Int(sender as! String)!
        } else if segue.identifier == "Show Nutrition"{
            let destination = segue.destination as! NutritionViewController
            destination.PID = program.id
            let arr = sender as! [Any]
            if arr[1] as! Bool{
                destination.NID = Int(program.nutritionMale![arr[0] as! Int].id)!
            }else {
                destination.NID = Int(program.nutritionFemale![arr[0] as! Int].id)!
            }
        } else  if segue.identifier == "Show Calory"{
            let destination = segue.destination as! CaloryViewController
            destination.PID = program.id
            destination.CID = Int(program.nutrition![sender as! Int].id)!
        } else if segue.identifier == "Show Food"{
            let destination = segue.destination as! FoodViewController
            destination.PID = program.id
            destination.FID = sender as! Int
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView{
            switch indexPath.row {
            case 0:
                return 100
            case 1:
                return 190
            case 2:
                return 58
            case 3:
                if training, trainingOn{
                    return 250
                } else {
                    return 0
                }
            case 4:
                if sex, !trainingOn{
                    return 250
                } else {
                    return 0
                }
            case 5:
                if !sex, !trainingOn{
                    return 250
                } else {
                    return 0
                }
            case 6:
                if !training{
                    return 250
                } else {
                    return 0
                }
            default:
                return 0
            }
        }
        else {
            return 65
        }
    }
    
    /*override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case maleTableView:
            return nutritionMaleCount
        case femaleTableView:
            return nutritionFemaleCount
        default:
            return 5
        }
    }
    */
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trainingCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! TrainingDayCollectionViewCell
        cell.button.setTitle(program.training![indexPath.item].name, for: .normal)
        cell.button.tag = indexPath.row
        if program.training![indexPath.item].name == ""{
            cell.button.backgroundColor = UIColor(red: 62.0/255.0, green: 194.0/255.0, blue: 194.0/255.0, alpha: 1.0)
            cell.button.setTitle(NSLocalizedString("أجازة", comment: ""), for: .normal)
        } else {
            cell.button.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        }
        
        return cell
    }
    
    

}


class cellDelegate: UIView, UITableViewDelegate, UITableViewDataSource{
    
    var maleCount = 0
    var femaleCount = 0
    var program: Program!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag{
        case 1:
            return maleCount
        default:
            return femaleCount
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NutritionTableViewCell
        switch tableView.tag{
        case 1:
            cell.button.setTitle(program.nutritionMale![indexPath.row].name, for: .normal)
        default:
            cell.button.setTitle(program.nutritionFemale![indexPath.row].name, for: .normal)
        }
        cell.button.tag = indexPath.row
        return cell
    }
    
    
}



class caloryCellDelegate: UIView, UITableViewDelegate, UITableViewDataSource{
    
    var nutritionCount = 0
    var program: Program!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutritionCount
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NutritionTableViewCell
        
        cell.button.setTitle(program.nutrition![indexPath.row].name, for: .normal)
        
        cell.button.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}

class foodCellDelegate: UIView, UITableViewDelegate, UITableViewDataSource{
    
    
    var food: [Flavor]?
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return food?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NutritionTableViewCell
        
        cell.button.setTitle(food![indexPath.row].name, for: .normal)
        
        cell.button.tag = Int(food![indexPath.row].id)!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}
