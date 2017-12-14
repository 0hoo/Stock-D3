//
//  StockHeaderView.swift
//  Stock
//
//  Created by Kim Younghoo on 12/14/17.
//  Copyright © 2017 0hoo. All rights reserved.
//

import UIKit

class StockHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let background = UIView(frame: self.bounds)
        background.backgroundColor = .white
        backgroundView = background
        
        //contentView.backgroundColor = .white
        
        titleLabel.textColor = .themeBlue
        separator.backgroundColor = .separator
    }
}
