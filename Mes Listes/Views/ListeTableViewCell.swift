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
     
        setupCellView()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupCellView () {
        let screen = UIScreen.main.bounds.size.width
        contentView.backgroundColor = UIColor.white
        
        //titleLabel
        titleLabel.text = ""
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        //titleLabel.frame = CGRect(x: 30.0, y: 15.5, width: screen - 40, height: 42)
        contentView.addSubview(titleLabel)
        
        //iconView
        iconView.image = nil
        iconView.contentMode = .scaleAspectFit
        //iconView.frame = CGRect(x: 20.0, y: 15.5, width: 42, height: 42)
        contentView.addSubview(iconView)
    }
    
    private func setupLayout() {
        
        let standartImageWidthHeight: CGFloat = 45.0
        let iPhone6SreenWidth: CGFloat = 375.0
        let multiplier: CGFloat = standartImageWidthHeight/iPhone6SreenWidth
        
        let iconSideOffset: CGFloat = 47.0
        let iconUpperLowerOffset: CGFloat = 12.5
        
        let iconWidth = UIScreen.main.bounds.size.width * multiplier
        

        
        iconView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: titleLabel.leadingAnchor, padding: .init(top: iconUpperLowerOffset, left: iconSideOffset, bottom: iconUpperLowerOffset, right: 30), size: .init(width: 45.0, height: 45.0))
        
        
        
        titleLabel.anchor(top: contentView.topAnchor, leading: iconView.trailingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: iconUpperLowerOffset, left: 27 , bottom: iconUpperLowerOffset, right: 39))
        
       
    }
    
    func fillWith(model: Liste?) {
       
        if let liste = model {
            //set icon
            if let listeIconName = liste.iconName {
                iconView.image = UIImage(named: listeIconName)
            }
            
            //set title
            if liste.done == true {
                let attributedString = NSMutableAttributedString.init(string: liste.name.uppercased())
                attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSRange.init(location: 0, length: liste.name.count))
                attributedString.addAttribute(.foregroundColor, value: UIColor.lightGray , range: NSRange.init(location: 0, length: liste.name.count))
                titleLabel.attributedText = attributedString
            } else {
                let attributedString = NSMutableAttributedString.init(string: liste.name.uppercased())
                attributedString.addAttribute(.strikethroughStyle, value: 0, range: NSRange.init(location: 0, length: liste.name.count))
                titleLabel.attributedText = attributedString
            }
            
            // delete this code if there are 3 hardcoded listes
        } else {
            titleLabel.text = "You haven't created a list yet"
        }
        
        
    }
    
    //MARK: - OTHERS
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        titleLabel.text = nil
        iconView.image = nil
        
    }

}
