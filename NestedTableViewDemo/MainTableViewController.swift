//
//  MainTableViewController.swift
//  NestedTableViewDemo
//
//  Created by Guang Lei on 2019/6/20.
//  Copyright © 2019 leiguang. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    let searchBarHeight: CGFloat = 44
    let segmentControlHeight: CGFloat = 44
    var nestedTableViewHeight: CGFloat = 0
    var mainTableViewInitialContentOffsetY: CGFloat?
    static var mainTableViewCanScroll: Bool = true

    let pageViewControllerDataSources: [UIViewController] = zip((0...2), ["One", "Two", "Three"]).map { (index, title) in
        let vc = NestedTableViewController()
        vc.title = title
        return vc
    }
    
    var segmentControl = UISegmentedControl(items: ["One", "Two", "Three"])
    var pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentControl()
        setupPageViewController()
        
        print("tableView.contentOffset.y: \(tableView.contentOffset.y)")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nestedTableViewHeight = UIScreen.main.bounds.height - view.safeAreaInsets.top -  segmentControlHeight
        if mainTableViewInitialContentOffsetY == nil {
            mainTableViewInitialContentOffsetY = tableView.contentOffset.y
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupSegmentControl() {
        segmentControl.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
    }
    
    func setupPageViewController() {
        pageViewController.dataSources = pageViewControllerDataSources
        pageViewController.indexDidChanged = { [weak self] index in
            guard let self = self, self.segmentControl.selectedSegmentIndex != index else { return }
            self.segmentControl.selectedSegmentIndex = index
        }
    }
    
    func addPageControllerView(to contentView: UIView) {
        addChild(pageViewController)
        contentView.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: pageViewController.view.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: pageViewController.view.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: pageViewController.view.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor).isActive = true
    }
    
    @objc func segmentControlValueChanged(_ segmentControl: UISegmentedControl) {
        guard segmentControl.selectedSegmentIndex != pageViewController.currentIndex else { return }
        pageViewController.slide(to: segmentControl.selectedSegmentIndex)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        addPageControllerView(to: cell.contentView)
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return segmentControl
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return segmentControlHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return nestedTableViewHeight
    }
    
    // MARK: - Table view scroll delegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("main offset y: \(scrollView.contentOffset.y)")
        let criticalOffsetY = searchBarHeight + (mainTableViewInitialContentOffsetY ?? 0)
        let criticalOffset = CGPoint(x: scrollView.contentOffset.x, y: criticalOffsetY)
        if scrollView.contentOffset.y > criticalOffsetY {
            scrollView.contentOffset = criticalOffset
            NestedTableViewController.nestedTableViewCanScroll = true
        } else {
            if MainTableViewController.mainTableViewCanScroll {
                NestedTableViewController.nestedTableViewCanScroll = false
            } else {
                scrollView.contentOffset = criticalOffset
            }
        }
    }
}
