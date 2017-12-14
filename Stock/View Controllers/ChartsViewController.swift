//
//  ChartsViewController.swift
//  Stock
//
//  Created by Kim Younghoo on 12/14/17.
//  Copyright © 2017 0hoo. All rights reserved.
//

import UIKit

class ChartsViewController: UIViewController {

    let stock: Stock
    
    @IBOutlet weak var collectionView: UICollectionView!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(stock: Stock) {
        self.stock = stock
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "차트"
        
        collectionView.register(UINib(nibName: ChartCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ChartCollectionViewCell.reuseIdentifier)
    }
}

extension ChartsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCollectionViewCell.reuseIdentifier, for: indexPath) as! ChartCollectionViewCell
        
        if indexPath.item == 0 {
            cell.textLabel?.text = "1일"
            cell.chartImageView?.pin_setImage(from: stock.dayChartImageUrl)
        } else if indexPath.item == 1 {
            cell.textLabel?.text = "1개월"
            cell.chartImageView?.pin_setImage(from: stock.monthChartImageUrl)
        } else if indexPath.item == 2 {
            cell.textLabel?.text = "3개월"
            cell.chartImageView?.pin_setImage(from: stock.threeMonthsChartImageUrl)
        } else if indexPath.item == 3 {
            cell.textLabel?.text = "1년"
            cell.chartImageView?.pin_setImage(from: stock.yearChartImageUrl)
        } else if indexPath.item == 4 {
            cell.textLabel?.text = "3년"
            cell.chartImageView?.pin_setImage(from: stock.threeYearsChartImageUrl)
        }
        
        return cell
    }
}

extension ChartsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width / 2 - 15, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
