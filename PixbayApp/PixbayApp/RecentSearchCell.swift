//
//  RecentSearchCell.swift
//  PixbayApp
//
//  Created by D2k on 18/12/20.
//

import UIKit

class RecentSearchCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .appBlack()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(with: .MEDIUM, of: .SUB_TITLE)
        return titleLabel
    }()
    
    lazy var recentIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(with: .Recent)
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
        recentIconView.pinEdgesEquallyToSuperview(atrributes: [.leading, .top, .bottom], constant: Constants.defaultPadding)
        recentIconView.pinHeightWidth(constant: 24)
        
        contentView.addSubview(titleLabel)
        titleLabel.pinTo(atrribute: .leading, toView: recentIconView, toAttribute: .trailing, constant: Constants.defaultPadding)
        titleLabel.pinToSuperview(atrribute: .centerY)
        titleLabel.pinEdgesEquallyToSuperview(atrributes: [.trailing], constant: Constants.defaultPadding)
    }
}
