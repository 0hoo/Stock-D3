//
//  StockTableViewCell.swift
//  Stock
//
//  Created by Kim Younghoo on 12/6/17.
//  Copyright © 2017 0hoo. All rights reserved.
//

import UIKit

class StockTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = nil
        priceLabel.text = nil
        amountLabel.text = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        priceLabel.text = nil
        amountLabel.text = nil
    }

    var stock: Stock? {
        didSet {
            guard let stock = stock else { return }
            
            titleLabel?.text = stock.name
            amountLabel?.text = "\(stock.amount)주"
            
            if stock.isPriceKeep {
                priceLabel?.textColor = .black
            } else if stock.isPriceUp {
                priceLabel?.textColor = .upRed
            } else {
                priceLabel?.textColor = .downBlue
            }
            priceLabel?.text = "\(stock.priceText)   \(stock.priceDiffText)"
        }
    }
}
