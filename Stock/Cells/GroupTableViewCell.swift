//
//  GroupTableViewCell.swift
//  Stock
//
//  Created by Kim Younghoo on 12/15/17.
//  Copyright © 2017 0hoo. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stocksLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = nil
        stocksLabel.text = nil
        titleLabel.textColor = .themeBlue
        stocksLabel.numberOfLines = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        stocksLabel.text = nil
    }
    
    var group: Group? {
        didSet {
            guard let group = group else { return }
            titleLabel.text = group.title
        }
    }
    
    var stocks: [Stock]? {
        didSet {
            guard let stocks = stocks else { return }
            let note = group?.note ?? ""
            if stocks.count > 0 {
                let stocksText = "\(stocks.count) 종목"
                let stockTitles = stocks.map { $0.name }.joined(separator: ", ")
                let stockLabelText = "\(note) · \(stocksText) · \(stockTitles)"
                stocksLabel?.text = stockLabelText
            } else {
                stocksLabel?.text = note
            }
        }
    }
}
