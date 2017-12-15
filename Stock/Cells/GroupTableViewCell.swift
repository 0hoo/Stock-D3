//
//  GroupTableViewCell.swift
//  Stock
//
//  Created by Kim Younghoo on 12/15/17.
//  Copyright © 2017 0hoo. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    //[C11-10]
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stocksLabel: UILabel!

    //[C11-11]
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = nil
        stocksLabel.text = nil
        titleLabel.textColor = .themeBlue
        
        //[C11-21]
        stocksLabel.numberOfLines = 0
    }
    
    //[C11-12]
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        stocksLabel.text = nil
    }
    
    //[C11-13]
    var group: Group? {
        didSet {
            guard let group = group else { return }
            titleLabel.text = group.title
        }
    }
    
    //[C11-14]
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
