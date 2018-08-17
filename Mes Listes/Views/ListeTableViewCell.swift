//
//  ListeTableViewCell.swift
//  Mes Listes
//
//  Created by Anastasiia Tanczak on 17/08/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import UIKit
import SwipeCellKit

class ListeTableViewCell: SwipeTableViewCell {
    
    //MARK: - Views
    var iconView = UIImageView()
    var titleLabel = UILabel()

    //MARK: - Implementation
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func prepareCellView () {
        let screen = UIScreen.main.bounds.size.width
        contentView.backgroundColor = UIColor.white
        
        //titleLabel
        titleLabel.text = ""
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .ultraLight)
        titleLabel.frame = CGRect(x: 30.0, y: 15.5, width: screen - 40, height: 42)
        contentView.addSubview(titleLabel)
        
        //iconView
        iconView.image = #imageLiteral(resourceName: "camera-icon")
        iconView.frame = CGRect(x: 20.0, y: 15.5, width: 42, height: 42)
        contentView.addSubview(iconView)
    }
    
    //MARK: - OTHERS
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        titleLabel.text = nil
        
    }

}
