//
//  ListTVC.swift
//  Mes Listes
//
//  Created by 1 on 05/08/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import UIKit
import Foundation


protocol ListTVCDelegate: NSObjectProtocol {
    func cellDidTapOnOk()
}


class ListTVC: UITableViewCell {

    weak var delegate: ListTVCDelegate?
    
    //MARK: - Views
    var titleLabel  : UILabel = UILabel()
    
    //MARK: Implementations
    
    /* For code implementation */
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        prepareView()        
    }
    
    /* For storyboard implementation */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareView()
    }
    
    func prepareView() {
        
        let screen = UIScreen.main.bounds.size.width
        
        //titleLabel
        titleLabel.text = ""
        titleLabel.frame = CGRect(x: 0, y: 0, width: screen - 40.0, height: 40.0)
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        
        contentView.addSubview(titleLabel)
    }
   
    //MARK: - Others
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
    }

}
