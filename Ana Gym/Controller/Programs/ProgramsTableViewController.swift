//
//  ProgramsTableViewController.swift
//  Ana Gym
//
//  Created by Esslam Emad on 19/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit

class ProgramsTableViewController: UITableViewController {

    var programs = [Program]()
    var myPrograms = false
    
    var colors = [(UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 1).cgColor, UIColor(red: 59/255, green: 73/255, blue: 146/255, alpha: 1).cgColor), (UIColor(red: 180/255, green: 236/255, blue: 81/255, alpha: 1).cgColor, UIColor(red: 33/255, green: 147/255, blue: 97/255, alpha: 1).cgColor), (UIColor(red: 218/255, green: 227/255, blue: 80/255, alpha: 1).cgColor, UIColor(red: 170/255, green: 144/255, blue: 113/255, alpha: 1).cgColor), (UIColor(red: 125/255, green: 154/255, blue: 174/255, alpha: 1).cgColor, UIColor(red: 200/255, green: 109/255, blue: 215/255, alpha: 1.0).cgColor)]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "rectangle"), for: .default)

        
        
        
        if myPrograms{
            self.title = NSLocalizedString("برامجي", comment: "")
            self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0)
            guard Auth.auth.subscribedPrograms.count > 0 else {
                fetchMyPrograms()
                return
            }
            programs = Auth.auth.subscribedPrograms
        }
        else {
            self.title = NSLocalizedString("البرامج", comment: "")
        guard Auth.auth.programs.count > 0 else {
            fetchPrograms()
            return
        }
        programs = Auth.auth.programs
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // SVProgressHUD.dismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func fetchPrograms(){
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getPrograms)
            }.done {
                self.programs = try! JSONDecoder().decode([Program].self, from: $0)
                self.tableView.reloadData()
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    func fetchMyPrograms(){
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getProgramsForUser(id: Auth.auth.user!.id))
            }.done {
                self.programs = try! JSONDecoder().decode([Program].self, from: $0)
                self.tableView.reloadData()
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }

   
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return programs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProgramTableViewCell

        let imgurl = URL(string: programs[indexPath.row].photo)
        cell.programImage.kf.setImage(with: imgurl)
        cell.titleLabel.text = programs[indexPath.row].name
        cell.subtitleLabel.text = programs[indexPath.row].subtitle
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = cell.view.bounds
        let cellColors = colors[indexPath.row % 4]
        gradientLayer.colors = [cellColors.0, cellColors.1]
       
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        cell.view.layer.insertSublayer(gradientLayer, at: 0)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Auth.auth.subscribedPrograms.first(where: {$0.id == programs[indexPath.row].id}) != nil, Auth.auth.isSignedIn == true{
            performSegue(withIdentifier: "ShowSubscribed", sender: programs[indexPath.row])
        } else {
            performSegue(withIdentifier: "ShowUnsbscribed", sender: programs[indexPath.row])
        }
        
    }
    
  
    
    private var finishedLoadingInitialTableCells = false
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        var lastInitialDisplayableCell = false
        
        //change flag as soon as last displayable cell is being loaded (which will mean table has initially loaded)
        if programs.count > 0 && !finishedLoadingInitialTableCells {
            if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows,
                let lastIndexPath = indexPathsForVisibleRows.last, lastIndexPath.row == indexPath.row {
                lastInitialDisplayableCell = true
            }
        }
        
        if !finishedLoadingInitialTableCells {
            
            if lastInitialDisplayableCell {
                //finishedLoadingInitialTableCells = true
            }
            
            //animates the cell as it is being displayed for the first time
            cell.transform = CGAffineTransform(translationX: 0, y: 160 / 2)
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0.05*Double(indexPath.row), options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
            }, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUnsbscribed"{
            let destination = segue.destination as! UnsbscribedProgramViewController
            destination.program = sender as! Program
        } else if segue.identifier == "ShowSubscribed"{
            let destination = segue.destination as! SubscribedProgramTableViewController
            destination.program = sender as! Program
        }
    }

}
