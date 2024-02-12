//
//  PagingView.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/18/24.
//

import Foundation
import UIKit

protocol PagingViewProtocol {
    func changeProgramLabel(data: ChannelInfo)
}

class PagingView: UIView {
    var selectedIndex = 0 // 선택된 탭 위치, 기본은 onAir
    var selectedscode = "MBC" //
    var currentTab = 0 // 현재 탭
    
    private let pagingTabBar : PagingTabBarView
    private let viewModel : PagingViewModel?
    private var initialContentOffset : CGFloat = 0.0
    
    var delegate : PagingViewProtocol?
    
    private lazy var screenCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(VerticalPagingCell.self, forCellWithReuseIdentifier: VerticalPagingCell.identifier)
        return collectionView
    }()
    
    init(pagingTabBar: PagingTabBarView) {
        self.pagingTabBar = pagingTabBar
        self.viewModel = PagingViewModel()
        
        super.init(frame: .zero)
        setupLayout()
        
        pagingTabBar.delegate = self
        viewModel?.delegate = self
        
        viewModel?.refreshData(isFirst: true, code: currentTab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension PagingView{
    func setupLayout(){
        addSubview(screenCollectionView)
        
        screenCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([screenCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
                                     screenCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     screenCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     screenCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
    }
}

extension PagingView: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewFrame = collectionView.frame
        return CGSize(width: collectionViewFrame.width, height: collectionViewFrame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pagingTabBar.indicatorViewLeadingConstraint.constant = scrollView.contentOffset.x / CGFloat(pagingTabBar.categoryTitleList.count)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.initialContentOffset = scrollView.contentOffset.x
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let distance = abs(targetContentOffset.pointee.x - initialContentOffset)
        if distance < UIScreen.main.bounds.width { // 스크롤이 다음 셀로 넘어가지 않은경우, return
            return
        }
        let indexPath = IndexPath(row: Int(targetContentOffset.pointee.x / UIScreen.main.bounds.width), section: 0)
        pagingTabBar.tabBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        currentTab = indexPath.item

        refreshCell()
    }


}


extension PagingView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pagingTabBar.categoryTitleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalPagingCell.identifier, for: indexPath) as? VerticalPagingCell else {return UICollectionViewCell()}
        cell.delegate = self
        let data = (indexPath.item == 0) ? viewModel?.tvList : viewModel?.mbicList
        if let cellData = data{
            cell.setupMyview(data: cellData)
        }
        return cell
    }
}

extension PagingView: PagingTabBarProtocol{
    func didTapPagingTabBarCell(scrollTo indexPath: IndexPath) {
        guard currentTab != indexPath.item else { return }
        screenCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        currentTab = indexPath.item
        refreshCell()
    }
}

extension PagingView: PagingViewModelProtocol{
    func viewRefresh(isFirst: Bool, data: [ChannelInfo]) {
        DispatchQueue.main.async {
            if isFirst == true{
                guard self.viewModel?.tvList.isEmpty == false else {return}
                guard let labelData = self.viewModel?.tvList[0] else {return}
                self.delegate?.changeProgramLabel(data: labelData)
            }
            
            for cell in self.screenCollectionView.visibleCells{
                if let cell = cell as? VerticalPagingCell{
                    cell.setupMyview(data: data) // data는 tvList 혹은 mbicList
                    return
                }
            }
            self.screenCollectionView.reloadData()
            
        }
    }

}

extension PagingView: VerticalPagingCellProtocol{
    func previousCellSelected(scode: String?, _ completion: ()->()) {
        if selectedIndex == currentTab && selectedscode == scode{
            completion()
        }
    }
    
    func refreshCell() {
        viewModel?.refreshData(isFirst: false, code: currentTab)
    }
    
    func nowCellSelected(indexPath: IndexPath) {
        if let prevSelectedIndex = viewModel?.indexListByScode[currentTab][selectedscode], prevSelectedIndex != indexPath.item{
            let selectedIndexPath = IndexPath(item: prevSelectedIndex, section: indexPath.section)
            for cell in self.screenCollectionView.visibleCells{
                if let cell = cell as? VerticalPagingCell{
                    cell.videoCollectionView.cellForItem(at: selectedIndexPath)?.isSelected = false
                    cell.videoCollectionView.deselectItem(at: selectedIndexPath, animated: false)
                }
            }
        }
        let tab = currentTab == 0 ? viewModel?.tvList : viewModel?.mbicList
        if let channelList = tab{
            if let newScode = channelList[indexPath.item].scheduleCode{
                guard let chInfo = findChannelInfo(for: newScode) else { return }
                if selectedscode == newScode{
                    return
                }
                currentTab = (chInfo.type == "NVOD") ? 1 : 0
                selectedIndex = currentTab
                selectedscode = newScode
                self.delegate?.changeProgramLabel(data: chInfo)
            }
        }

    }
    
    private func findChannelInfo(for sCode: String) -> ChannelInfo? {
        // tv
        if let chInfoTV = viewModel?.channelListByScode[0][sCode] {
            return chInfoTV
        }
        // ch24
        else if let chInfoCH24 = viewModel?.channelListByScode[1][sCode] {
            return chInfoCH24
        }
        else {
            return nil
        }
    }
}
