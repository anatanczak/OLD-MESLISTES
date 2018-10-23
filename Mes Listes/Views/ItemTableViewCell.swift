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
    
    weak var itemDelegate: ItemTableViewCellDelegate?

    //MARK: - Views
    let iconView = UIImageView()
    let titleLabel = UILabel()
    let noteButton = UIButton()
    
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
        contentView.backgroundColor = UIColor.white
        
        titleLabel.text = ""
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        
        iconView.image = #imageLiteral(resourceName: "emty-circle-icon")
        iconView.contentMode = .scaleAspectFit
        
        noteButton.setImage(#imageLiteral(resourceName: "note-icon-gray"), for: .normal)
        noteButton.contentHorizontalAlignment = .fill
        noteButton.contentVerticalAlignment = .fill
        noteButton.imageView?.contentMode = .scaleAspectFit
        
        noteButton.addTarget(self, action: #selector(noteButtonAction), for: .touchUpInside)
        [titleLabel, iconView, noteButton].forEach { contentView.addSubview($0) }
        
    }
    
    func setupLayout () {
        
        let iconSideOffset: CGFloat = 47.0
        let iconUpperLowerOffset: CGFloat = 12.5
        

        
        iconView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: titleLabel.leadingAnchor, padding: .init(top: iconUpperLowerOffset, left: iconSideOffset, bottom: iconUpperLowerOffset, right: 30), size: .init(width: 12.0, height: 12.0))
        
        
        
        titleLabel.anchor(top: contentView.topAnchor, leading: iconView.trailingAnchor, bottom: contentView.bottomAnchor, trailing: noteButton.leadingAnchor, padding: .init(top: iconUpperLowerOffset, left: 27 , bottom: iconUpperLowerOffset, right: 10))
        
        noteButton.anchor(top: contentView.topAnchor, leading: titleLabel.trailingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 2, left: 5, bottom: 2, right: 2),
            size: .init(width: 17, height: 25))
        
    }
    
    //MARK: - ACTIONS
    @objc func noteButtonAction () {
        //create an alert which asks if thhe user want to create a note for this item
        itemDelegate?.cellDidTapOnNoteButton(cell: self)
    }

    //MARK: - DIFFERENT METHHODS
    
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
                    
                    if item.hasNote {
                        noteButton.setImage(#imageLiteral(resourceName: "note-icon-rose"), for: .normal)
                    }else{
                        noteButton.setImage(#imageLiteral(resourceName: "note-icon-gray"), for: .normal)
                    }
                    
                }else{
                    titleLabel.text = "You haven't created an item yet"
                }
        
        
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
      
        noteButton.imageView?.image = nil
    }
}
