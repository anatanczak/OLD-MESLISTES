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
    var icontView   : UIImageView = UIImageView()
    var titleLabel  : UILabel = UILabel()
    var button      : UIButton = UIButton()
    
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
        
        //icontView
        icontView.image = #imageLiteral(resourceName: "reminder-icon")
        icontView.contentMode = .scaleAspectFit
        icontView.frame = CGRect(x: 0, y: 0, width: 40.0, height: 60.0)
        
        contentView.addSubview(icontView)
        
        //titleLabel
        titleLabel.text = "TITLE"
        titleLabel.frame = CGRect(x: 40.0, y: 0, width: screen - 40.0, height: 20.0)
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        
        contentView.addSubview(titleLabel)

        //button
        button.setTitle("OK", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.frame = CGRect(x: (screen/3) * 2, y: 30.0, width: screen/3, height: 30)
        button.backgroundColor = UIColor.green
        contentView.addSubview(button)
    }
    
    //MARK: - Action
    
    @objc func buttonAction() {
        print(":=-> buttonAction")
        delegate?.cellDidTapOnOk()
    }
    
    //MARK: - Others
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        icontView.image = nil
        titleLabel.text = ""
    }

}
