//
//  CustomVideoView.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/18/24.
//

import Foundation
import UIKit

class LiveInfoView: UIView {
    var categoryTitleList : [String]?
    var pagingTabBar: PagingTabBarView = {
        let view = PagingTabBarView(categoryTitleList: ["온에어", "엠빅"])
        view.translatesAutoresizingMaskIntoConstraints = false     
        view.backgroundColor = .white
        return view
    }()
    
    lazy var pagingView: PagingView = {
        let view = PagingView(pagingTabBar: pagingTabBar)
        view.delegate = self
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var programLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = "test label"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(categoryTitleList: [String]) {
        super.init(frame: .zero)
        self.categoryTitleList = categoryTitleList
        self.backgroundColor = .white
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        
        self.addSubview(pagingTabBar)
        self.addSubview(pagingView)
        self.addSubview(programLabel)
        
        programLabel.backgroundColor = .white

        NSLayoutConstraint.activate([programLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                                     programLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     programLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                     programLabel.heightAnchor.constraint(equalToConstant: 30),
                                     
                                     pagingTabBar.topAnchor.constraint(equalTo: self.programLabel.bottomAnchor),
                                     pagingTabBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     pagingTabBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                     pagingTabBar.heightAnchor.constraint(equalToConstant: pagingTabBar.cellheight+5),
                                     
                                     pagingView.topAnchor.constraint(equalTo: pagingTabBar.bottomAnchor),
                                     pagingView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                     pagingView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     pagingView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)])
    }
}

extension LiveInfoView: PagingViewProtocol {
    func changeProgramLabel(data:ChannelInfo) {
        guard let typetitle = data.typeTitle, let title = data.title else {
            return
        }
        programLabel.text = "\(typetitle) - \(title)"
    }
}
