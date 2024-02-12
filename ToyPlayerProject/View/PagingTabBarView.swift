//
//  TestView.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/18/24.
//

import Foundation
import UIKit

protocol PagingTabBarProtocol: AnyObject {
    func didTapPagingTabBarCell(scrollTo indexPath: IndexPath)
}

class PagingTabBarView: UIView {
    
    var indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    lazy var tabBarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let cellheight: CGFloat = 44.0
    var categoryTitleList: [String]
    weak var delegate: PagingTabBarProtocol?
    
    // indicatorBar 움직이기 위한 레이아웃 변수
    var indicatorViewLeadingConstraint:NSLayoutConstraint!
    var indicatorViewWidthConstraint: NSLayoutConstraint!

    init(categoryTitleList: [String]) {
        self.categoryTitleList = categoryTitleList
        super.init(frame: .zero)
        setUpCollectionView()
    
        addSubview(tabBarCollectionView)
        tabBarCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tabBarCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tabBarCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tabBarCollectionView.heightAnchor.constraint(equalToConstant: cellheight).isActive = true
        
        addSubview(indicatorView)
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        indicatorViewLeadingConstraint.isActive = true
        indicatorViewWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: self.frame.width / CGFloat(categoryTitleList.count))
        indicatorViewWidthConstraint.isActive = true
       
        indicatorView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCollectionView() {
        tabBarCollectionView.backgroundColor = .white
        tabBarCollectionView.showsVerticalScrollIndicator = false
        tabBarCollectionView.bounces = false
        tabBarCollectionView.allowsMultipleSelection = false
        tabBarCollectionView.delegate = self
        tabBarCollectionView.dataSource = self
        tabBarCollectionView.showsHorizontalScrollIndicator = false
        tabBarCollectionView.register(TabBarCell.self, forCellWithReuseIdentifier: TabBarCell.identifier)
        tabBarCollectionView.isScrollEnabled = false
        tabBarCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: [])

    }
}

extension PagingTabBarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapPagingTabBarCell(scrollTo: indexPath)
        //collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / CGFloat(categoryTitleList.count), height: cellheight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension PagingTabBarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryTitleList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarCell.identifier, for: indexPath) as? TabBarCell else { return UICollectionViewCell()}
        cell.setupView(title: categoryTitleList[indexPath.item])
        return cell
    }

}

