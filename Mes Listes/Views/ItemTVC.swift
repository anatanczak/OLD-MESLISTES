//
//  ItemTVC.swift
//  Mes Listes
//
//  Created by Anastasiia Tanczak on 07/08/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import UIKit
import Foundation
import SwipeCellKit

protocol ItemTVCDelegate: NSObjectProtocol {
    func cellDidTapOnNoteButton()
}

class ItemTVC: SwipeTableViewCell {
    
    weak var itemDelegate: ItemTVCDelegate?
    
    //MARK: - Properties
    var label = UILabel()
    var noteButton = UIButton()
    
    //MARK: - Implementations
    
    //used for code implementation
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareView()
    }
    
    //used for storyboard implementation
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareView()
    }
    
    func prepareView () {
        
        
        let screen = UIScreen.main.bounds.size.width
        
        label.frame = CGRect(x: 0, y: 0, width: screen - 40, height: 40)
        label.text = ""
        contentView.addSubview(label)
        
        noteButton.backgroundColor = UIColor.cyan
        noteButton.setTitle("N", for: .normal)
        noteButton.frame = CGRect(x: screen - 40, y: 0, width: 40, height: 40)
        noteButton.addTarget(self, action: #selector(noteButtonAction), for: .touchUpInside)
        contentView.addSubview(noteButton)
    }
    
    //MARK: - Action
    @objc func noteButtonAction () {
        print(":-->noteButtonPressed")
        itemDelegate?.cellDidTapOnNoteButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        label.text = nil
    }

}

