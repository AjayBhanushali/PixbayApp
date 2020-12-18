//
//  RecentSearchCell.swift
//  PixbayApp
//
//  Created by Ajay Bhanushali on 18/12/20.
//

import UIKit

class RecentSearchCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .appBlack()
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(with: .MEDIUM, of: .SUB_TITLE)
        return titleLabel
    }()
    
    lazy var recentIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.tintColor = .appBlack()
        imageView.image = UIImage(with: .Recent).withRenderingMode(.alwaysTemplate)
        return imageView
    }()
    
    var title: String? {
        didSet {
            guard let title = title else {
                return
            }
            titleLabel.text = title
        }
    }
    
    // MARK: Init Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareView()
    }
    
    func prepareView() {
        contentView.addSubview(recentIconView)
        recentIconView.pinEdgesEquallyToSuperview(atrributes: [.top, .bottom], constant: Constants.defaultPadding)
        recentIconView.pinEdgesEquallyToSuperview(atrributes: [.leading], constant: Constants.defaultPadding*2)
        recentIconView.pinHeightWidth(constant: Constants.defaultIconSize)
        
        contentView.addSubview(titleLabel)
        titleLabel.pinTo(atrribute: .leading, toView: recentIconView, toAttribute: .trailing, constant: Constants.defaultPadding)
        titleLabel.pinToSuperview(atrribute: .centerY)
        titleLabel.pinEdgesEquallyToSuperview(atrributes: [.trailing], constant: Constants.defaultPadding)
    }
}
