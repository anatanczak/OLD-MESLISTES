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
    //MARK: - Constants
    private let labelFontSize: CGFloat = 14
    private let iconWidthHeightForAllDevices: CGFloat = 45
    private let paddingFromLeadingEdge: CGFloat = 30
    private let distanceBetweenIconViewAndTitlelabel: CGFloat = 30
    private let paddingToTrailingEdge: CGFloat = 20
   // private let paddingTopAndBottom: CGFloat = 8

    //MARK: - Views
    var iconView = UIImageView()
    var titleLabel = UILabel()

    //MARK: - Implementation
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
        setupCellView()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupCellView () {
        contentView.backgroundColor = UIColor.white
        
        //titleLabel
        titleLabel.text = ""
        titleLabel.textAlignment = .left
        
        var myFont = UIFont.systemFont(ofSize: labelFontSize, weight: .light)
        //var myFont = UIFont.preferredFont(forTextStyle: .body).withSize(labelFontSize)
        myFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: myFont)
        titleLabel.font = myFont
       
        // titleLabel.font = UIFont.systemFont(ofSize: labelFontSize, weight: .light)
        contentView.addSubview(titleLabel)
        
        //iconView
        iconView.image = nil
        iconView.contentMode = .scaleAspectFit
        contentView.addSubview(iconView)
    }
    
    //TODO: make dynamic type work
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    private func setupLayout() {
   
        // iconView Layout
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: iconWidthHeightForAllDevices),
            iconView.heightAnchor.constraint(equalToConstant: iconWidthHeightForAllDevices),
            iconView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            { let constraint = iconView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: paddingFromLeadingEdge)
                return constraint
            }(),
            ])
        
        //titleLabel Layout
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: distanceBetweenIconViewAndTitlelabel),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: paddingToTrailingEdge)
            ])
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
