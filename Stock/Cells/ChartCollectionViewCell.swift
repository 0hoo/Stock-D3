//
//  ChartCollectionViewCell.swift
//  Stock
//
//  Created by Kim Younghoo on 12/14/17.
//  Copyright © 2017 0hoo. All rights reserved.
//

import UIKit

class ChartCollectionViewCell: UICollectionViewCell {

    //[C10-7]
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var chartImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //[C10-8]
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLabel.text = nil
        chartImageView.image = nil
    }
}
