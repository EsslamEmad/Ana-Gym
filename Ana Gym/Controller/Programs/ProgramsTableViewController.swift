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
    var register = true
    
    var colors = [(UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 1).cgColor, UIColor(red: 59/255, green: 73/255, blue: 146/255, alpha: 1).cgColor), (UIColor(red: 180/255, green: 236/255, blue: 81/255, alpha: 1).cgColor, UIColor(red: 33/255, green: 147/255, blue: 97/255, alpha: 1).cgColor), (UIColor(red: 218/255, green: 227/255, blue: 80/255, alpha: 1).cgColor, UIColor(red: 170/255, green: 144/255, blue: 113/255, alpha: 1).cgColor), (UIColor(red: 125/255, green: 154/255, blue: 174/255, alpha: 1).cgColor, UIColor(red: 200/255, green: 109/255, blue: 215/255, alpha: 1.0).cgColor)]
    
    @IBOutlet weak var signInButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "rectangle"), for: .default)
        if signInButton != nil {
            signInButton.tintColor = .white}
        
        if Auth.auth.user != nil{
            self.navigationItem.rightBarButtonItem = nil
            //signInButton.title = ""
            register = false
            self.title = NSLocalizedString("البرامج", comment: "")
        }
        
        if myPrograms{
            self.title = NSLocalizedString("برامجي", comment: "")
            self.tableView.contentInset = UIEdgeInsets.init(top: 40, left: 0, bottom: 0, right: 0)
            guard Auth.auth.subscribedPrograms.count > 0 else {
                fetchMyPrograms()
                return
            }
            programs = Auth.auth.subscribedPrograms
        }
        else {
            //self.title = NSLocalizedString("البرامج", comment: "")
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
        if signInButton != nil {
            signInButton.title = ""}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if signInButton != nil {
            signInButton.title = NSLocalizedString("تسجيل الدخول", comment: "")}
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
        if  !register{
            return 1}
        else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !register || section == 1{
            return programs.count}
        else {
            return 2
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if programs.count > 0{
            Auth.auth.production = programs[0].production
        }
        
        if !register || indexPath.section == 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProgramTableViewCell

            if let imgurl = URL(string: programs[indexPath.row].photo){
                cell.programImage.kf.indicatorType = .activity
                cell.programImage.kf.setImage(with: imgurl)}
          //  cell.programImage.image = resizeImage(cell.programImage.image, newWidth: cell.programImage.frame.width)
        cell.titleLabel.text = programs[indexPath.row].name
        cell.subtitleLabel.text = programs[indexPath.row].subtitle
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = cell.view.bounds
        //let cellColors = colors[indexPath.row % 4]
        gradientLayer.colors = [UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 1).cgColor,  UIColor(red: 59/255, green: 73/255, blue: 146/255, alpha: 1).cgColor]
       
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        cell.view.layer.insertSublayer(gradientLayer, at: 0)
        
        return cell
        } else if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WhoWeAre") as! WhoWeAreTableViewCell
            if Auth.auth.pages.count > 0{
                cell.titleLabel.text = Auth.auth.pages[0].title
                let style = NSMutableParagraphStyle()
                style.alignment = NSTextAlignment.right
                
                do{ let richText = try NSMutableAttributedString(
                    data: Auth.auth.pages[0].content.data(using: String.Encoding.utf8)!,
                    options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                    documentAttributes: nil)
                richText.addAttributes([ .paragraphStyle: style ],
                                       range: NSMakeRange(0, richText.length))
                    cell.contentLabel.attributedText = richText
                    cell.contentLabel.textAlignment = .right
                } catch {
                    
                }
                
                
                
            }//else {
               // DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                   // tableView.reloadData()
                //}
          //  }
            //let SVGImage = UIView(SVGNamed: "about")
            //cell.bgImage.addSubview(SVGImage)
            //cell.bgImage.view
            //let svgImgVar = getSvgImgFnc(svgImjFileNameVar: "about-bg", ClrVar : .white)
            //cell.bgImage.image = svgImgVar
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Programs")
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !register || indexPath.section == 1{
            return 180} else if indexPath.row == 0{
            return 550
        } else {
            return 100
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !register || indexPath.section == 1{
        if Auth.auth.subscribedPrograms.first(where: {$0.id == programs[indexPath.row].id}) != nil, Auth.auth.user != nil{
            performSegue(withIdentifier: "ShowSubscribed", sender: programs[indexPath.row])
        } else {
            performSegue(withIdentifier: "ShowUnsbscribed", sender: programs[indexPath.row])
            }}
        
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
    
    func resizeImage(_ image: UIImage?, newWidth: CGFloat) -> UIImage? {
        guard let image = image else {
            return nil
        }
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }


}
