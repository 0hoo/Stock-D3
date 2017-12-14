//
//  ChartCollectionViewCell.swift
//  Stock
//
//  Created by Kim Younghoo on 12/14/17.
//  Copyright © 2017 0hoo. All rights reserved.
//

import UIKit

class ChartCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var chartImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLabel.text = nil
        chartImageView.image = nil
    }
}
