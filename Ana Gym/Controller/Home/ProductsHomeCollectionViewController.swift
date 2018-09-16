//
//  ProductsCollectionViewController.swift
//  Ana Gym
//
//  Created by Esslam Emad on 16/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD

private let reuseIdentifier = "Cell"
fileprivate let sectionInsets = UIEdgeInsets(top: 25.0, left: 15, bottom: 25.0, right: 15)

class ProductsHomeCollectionViewController: UICollectionViewController {

    
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        collectionView?.backgroundColor = .clear
        firstly{
            return API.CallApi(APIRequests.getProducts)
            }.done {
                self.products = try! JSONDecoder().decode([Product].self, from: $0)
                self.collectionView?.reloadData()
            }.catch { error in
                print(error.localizedDescription)
                self.viewDidLoad()
            }.finally {
                SVProgressHUD.dismiss()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch products.count {
        case 0:
            return 1
        default:
            return products.count
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch products.count {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loading", for: indexPath) as! LoadingCollectionViewCell
            
            return cell
        default:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! ProductHomeCollectionViewCell
        let imgurl = URL(string:products[indexPath.item].photos[0])
        cell.productImage.kf.indicatorType = .activity
        cell.productImage.kf.setImage(with: imgurl)
        cell.nameLabel.text = products[indexPath.item].name
        cell.priceLabel.text = String(products[indexPath.item].price) + NSLocalizedString(" ريال", comment: "")
        cell.layer.cornerRadius = 10.0
        return cell
        }
    }
    
    

}

extension ProductsHomeCollectionViewController: UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (2 + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / 2
        
        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
}
