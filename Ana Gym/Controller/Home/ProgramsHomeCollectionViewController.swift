//
//  ProgramsHomeCollectionViewController.swift
//  Ana Gym
//
//  Created by Esslam Emad on 16/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD

private let reuseIdentifier = "Cell"

class ProgramsHomeCollectionViewController: UICollectionViewController {

    var programs = [Program]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        collectionView?.backgroundColor = .clear
        self.collectionView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        guard Auth.auth.programs.count > 0 else {
            fetchPrograms()
            return
        }
        programs = Auth.auth.programs
        self.collectionView?.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
       // SVProgressHUD.dismiss()
    }
    
    func fetchPrograms() {
        firstly{
            return API.CallApi(APIRequests.getPrograms)
            }.done {
                self.programs = try! JSONDecoder().decode([Program].self, from: $0)
                self.collectionView?.reloadData()
                self.collectionView?.scrollToItem(at: IndexPath(row: self.programs.count - 1, section: 0), at: .left, animated: false)
            }.catch { error in
                print(error.localizedDescription)
                self.viewDidLoad()
            }.finally {
                SVProgressHUD.dismiss()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch programs.count {
        case 0:
            
            
            return 2
            
        default:
            return programs.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch programs.count {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loading", for: indexPath) as! LoadingCollectionViewCell
            cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            if indexPath.item == 0 { cell.loadingLabel.alpha = 0} else  { collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .left, animated: false)}
            return cell
        default:
            
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! ProgramHomeCollectionViewCell
        let imgurl = URL(string: programs[indexPath.item].photo)
        cell.programImage.kf.indicatorType = .activity
        cell.programImage.kf.setImage(with: imgurl)
        cell.nameLabel.text = programs[indexPath.item].name
        cell.subtitleLabel.text = programs[indexPath.item].subtitle
        cell.coachLabel.text = NSLocalizedString("المدرب: ", comment: "") + programs[indexPath.item].coach
        cell.layer.cornerRadius = 10.0
        cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        if let SP = Auth.auth.subscribedPrograms{
            if SP.first(where: {$0.id == programs[indexPath.row].id}) != nil {
                cell.subscribtionButton.alpha = 0
            }else {
                cell.subscribtionButton.tag = indexPath.row
            }
        } else {
            cell.subscribtionButton.tag = -1
        }
        return cell
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Auth.auth.subscribedPrograms.first(where: {$0.id == programs[indexPath.row].id}) != nil {
            performSegue(withIdentifier: "Show Subscribed", sender: programs[indexPath.row])
        } else {
            performSegue(withIdentifier: "Show Unsubscribed", sender: programs[indexPath.row])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Unsubscribed"{
            let destination = segue.destination as! UnsbscribedProgramViewController
            destination.program = sender as! Program
        } else if segue.identifier == "Show Subscribed"{
            let destination = segue.destination as! SubscribedProgramTableViewController
            destination.program = sender as! Program
        } else if segue.identifier == "Checkout" {
            let destination = segue.destination as! CheckoutViewController
            destination.program = sender as! Program
        }
    }
    
    @IBAction func didPressSubscribe(_ sender: UIButton){
        guard sender.tag != -1 else {
            print("-1")
            return
        }
        performSegue(withIdentifier: "Checkout", sender: programs[sender.tag])
    }
    
    var timr = Timer()
    var w: CGFloat = 0.0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.collectionView?.scrollToItem(at: IndexPath(row: self.programs.count - 1, section: 0), at: .left, animated: false)
        configAutoscrollTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        deconfigAutoscrollTimer()
    }
    
    func configAutoscrollTimer()
    {
        
        timr = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.autoScrollView), userInfo: nil, repeats: true)
    }
    func deconfigAutoscrollTimer()
    {
        timr.invalidate()
        
    }
    func onTimer()
    {
        autoScrollView()
    }
    
    @objc func autoScrollView()
    {
        
        let initailPoint = CGPoint(x: w,y :0)
        
        if __CGPointEqualToPoint(initailPoint, (collectionView?.contentOffset)!)
        {
            if w < (collectionView?.contentSize.width)! - 218 
            {
                
                self.w += 220
                
                
            }
            else
            {
                w = -180
            }
            let offsetPoint = CGPoint(x: w,y :0)
            UIView.animate(withDuration: 0.5, animations: {
                self.collectionView?.contentOffset = offsetPoint
            })
            
            
            
            
        }
        else
        {
            w = (collectionView?.contentOffset.x)!
        }
    }

}
