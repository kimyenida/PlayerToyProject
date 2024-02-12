//
//  PagingTabBarCell.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/18/24.
//
//
import Foundation
import UIKit

class TabBarCell: UICollectionViewCell{
    static let identifier = "PagingTabBarCell"
    
    var titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .semibold)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
//    var underline: UIView = {
//        let view = UIView()
//        view.backgroundColor = .black
//        view.alpha = 0.0
//        return view
//    }()
    
    override var isSelected: Bool{
        didSet{
            titleLabel.textColor = isSelected ? .black : .lightGray
            //underline.alpha = isSelected ? 1.0 : 0.0
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(title: String){
        titleLabel.text = title
    }
}

private extension TabBarCell{
    func setupLayout(){
        contentView.addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                                     titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
                                 ])
        //contentView.addSubview(underline)
        //underline.translatesAutoresizingMaskIntoConstraints = false
        
//        NSLayoutConstraint.activate([underline.heightAnchor.constraint(equalToConstant: 3.0),
//                                     underline.widthAnchor.constraint(equalTo: titleLabel.widthAnchor),
//                                     underline.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),
//                                     underline.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
//                                     underline.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
//                                     underline.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
}
