//
//  StockChartTableViewCell.swift
//  Stock
//
//  Created by Kim Younghoo on 12/7/17.
//  Copyright © 2017 0hoo. All rights reserved.
//

import UIKit

import PINRemoteImage

class StockChartTableViewCell: UITableViewCell {
    
    var stock: Stock? {
        didSet {
            guard let stock = stock else { return }
            chartImageView.pin_setImage(from: stock.monthChartImageUrl)
        }
    }
    
    @IBOutlet var chartImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}
