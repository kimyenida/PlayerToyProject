//
//  TestCell.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/22/24.
//

import Foundation
import UIKit

class OneVideoCell: UICollectionViewCell{
    static let reuseId = "VideoCell"

    
    var thumbnailImageView : CustomImageView = {
        var view = CustomImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        return view
    }()
    var titlelb: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.sizeToFit()
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    var sublb: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.sizeToFit()
        label.textColor = .darkGray
        label.numberOfLines = 0
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        willSet {
            setSelected(newValue)
        }
    }
    
    func setSelected(_ isSelected: Bool) {
        if isSelected {
            thumbnailImageView.layer.borderWidth = 4
        }
        else {
            thumbnailImageView.layer.borderWidth = 0
        }
    }
    
    func configure(title:String, sub:String, imagelink: String?){
        guard let imagelink = imagelink else { return }
        titlelb.text = title
        sublb.text = sub
        thumbnailImageView.loadImage(imageUrl: imagelink)
    }
    
    private func setupLayout(){
        contentView.addSubview(titlelb)
        contentView.addSubview(sublb)
        contentView.addSubview(thumbnailImageView)
        
        titlelb.translatesAutoresizingMaskIntoConstraints = false
        sublb.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     thumbnailImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 100/contentView.bounds.height),
                                     thumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                                     thumbnailImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                                    ])
        
        NSLayoutConstraint.activate([titlelb.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     titlelb.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                     titlelb.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor),
                                     
                                     
                                     sublb.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     sublb.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                     sublb.topAnchor.constraint(equalTo: titlelb.bottomAnchor, constant: 3)])
    }
}
