//
//  DeleteTableViewCell.swift
//  Stock
//
//  Created by Kim Younghoo on 12/13/17.
//  Copyright © 2017 0hoo. All rights reserved.
//

import UIKit

class DeleteTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textLabel?.textAlignment = .center
        textLabel?.textColor = .red
        textLabel?.font = .systemFont(ofSize: 15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
