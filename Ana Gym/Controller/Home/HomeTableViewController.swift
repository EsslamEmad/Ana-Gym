//
//  HomeTableViewController.swift
//  Ana Gym
//
//  Created by Esslam Emad on 16/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD
import Kingfisher


class HomeTableViewController: UITableViewController//, UICollectionViewDelegate, UICollectionViewDataSource
{
    
    /*var programs = [Program]()
    var products = [Product]()*/
    
    //@IBOutlet var programsCollectionView: UICollectionView!
   // @IBOutlet var productsCollectionView: UICollectionView!
    @IBOutlet var programsContainer: UIView!
   // @IBOutlet var productsContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "rectangle"), for: .default)

        tableView.backgroundView = UIImageView(image: UIImage(named: "Background-1.png"))
        programsContainer.backgroundColor = .clear
        
        
        
        //productsContainer.backgroundColor = .clear
       /* programsCollectionView.dataSource = self
        programsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.delegate = self
        */
        /*firstly{
            return API.CallApi(APIRequests.getPrograms)
            }.done {
                self.programs = try! JSONDecoder().decode([Program].self, from: $0)
                self.programsCollectionView.reloadData()
                print(self.programs[0].name)
            }.catch { error in
                print(error.localizedDescription)
        }*/
        /*firstly{
            return API.CallApi(APIRequests.getProducts)
            }.done {
                self.products = try! JSONDecoder().decode([Product].self, from: $0)
                self.productsCollectionView.reloadData()
                print(self.products[0].name)
                print(self.productsCollectionView.numberOfItems(inSection: 0))
            }.catch { error in
                print(error.localizedDescription)
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // SVProgressHUD.dismiss()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    /*
    //Mark: CollectionView Protocols
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag{
        case productsCollectionView.tag:
            print("Hey" + String(products.count))
            return products.count
        default:
            print("Bye" + String(programs.count))
            return programs.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(0)
        switch collectionView.tag{
        case productsCollectionView.tag:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! ProductHomeCollectionViewCell
            let imgurl = URL(string:products[indexPath.item].photos[0])
            cell.productImage.kf.indicatorType = .activity
            cell.productImage.kf.setImage(with: imgurl)
            cell.nameLabel.text = products[indexPath.item].name
            cell.priceLabel.text = String(products[indexPath.item].price) + NSLocalizedString(" ريال", comment: "")
            cell.layer.cornerRadius = 10.0
            print(1)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! ProgramHomeCollectionViewCell
            let imgurl = URL(string: programs[indexPath.item].photo)
            cell.programImage.kf.indicatorType = .activity
            cell.programImage.kf.setImage(with: imgurl)
            cell.nameLabel.text = programs[indexPath.item].name
            cell.subtitleLabel.text = programs[indexPath.item].subtitle
            cell.coachLabel.text = programs[indexPath.item].coach
            cell.layer.cornerRadius = 10.0
            print(2)
            return cell
        }
    }
    
    */
    
    override var prefersStatusBarHidden: Bool{
        get {
            return true
        }
    }

}
