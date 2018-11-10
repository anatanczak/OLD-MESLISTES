//
//  ItemTableViewCell.swift
//  Mes Listes
//
//  Created by Anastasiia Tanczak on 18/08/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import UIKit
import SwipeCellKit

protocol ItemTableViewCellDelegate: NSObjectProtocol {
    func cellDidTapOnNoteButton(cell: ItemTableViewCell)
}

class ItemTableViewCell: SwipeTableViewCell {
    
    //MARK: - Constants
    private let paddingLeadingTrailing: CGFloat = 24
    private let distanceBetweenIconViewAndTitlelabel: CGFloat = 30
    private let paddingTopBottom: CGFloat = 22
    private let iconViewWidthHeight: CGFloat = 12
    private let upperTransparentBorder: CGFloat = 1

    //MARK: - Views
    var backgroundCellView = UIView()
    let iconView = UIImageView()
    let titleLabel = UILabel()

    
    //MARK: - Implementation
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellView()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellView () {
        contentView.isOpaque = false
        contentView.backgroundColor = UIColor.clear
        
        backgroundCellView.backgroundColor = .white
        //contentView.addSubview(backgroundCellView)
        
       
        //titlelabel
        titleLabel.text = ""
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        //iconview
        iconView.image = #imageLiteral(resourceName: "emty-circle-icon")
        iconView.contentMode = .scaleAspectFit
        //backgroundCellView.addSubview(iconView)
        
    }
    
    func setupLayout () {
        // backgroundCellView
//        backgroundCellView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            backgroundCellView.topAnchor.constraint(equalTo: topAnchor, constant: upperTransparentBorder),
//            backgroundCellView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            backgroundCellView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            backgroundCellView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            backgroundCellView.heightAnchor.constraint(equalToConstant: 50)
//            ])
        
        //iconView
//        iconView.translatesAutoresizingMaskIntoConstraints = false
//
//          NSLayoutConstraint.activate([
//
//        ])
        
    
        //titleLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.setContentCompressionResistancePriority(.defaultHigh
//            , for:  .vertical)
//
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 300),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
            ])
    }
    
    //MARK: - DIFFERENT METHODS
    
    func fillWith(model: Item?) {
                if let item = model {
        
                    if item.done == true {
                        let attributedString = NSMutableAttributedString.init(string: item.title)
                        attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSRange.init(location: 0, length: item.title.count))
                        attributedString.addAttribute(.foregroundColor, value: UIColor.lightGray , range: NSRange.init(location: 0, length: item.title.count))
                        titleLabel.attributedText = attributedString
                        
        
                    }else{
                        let attributedString = NSMutableAttributedString.init(string: item.title)
                        attributedString.addAttribute(.strikethroughStyle, value: 0, range: NSRange.init(location: 0, length: item.title.count))
                        titleLabel.attributedText = attributedString
                        
                    }
                    
                }else{
                    titleLabel.text = "You haven't created an item yet"
                }
        
        
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
      
    }
}
