//
//  NestedTableViewController.swift
//  NestedTableViewDemo
//
//  Created by Guang Lei on 2019/6/20.
//  Copyright © 2019 leiguang. All rights reserved.
//

import UIKit

class NestedTableViewController: UITableViewController {
    
    var isFingerTouching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int.random(in: 10...50)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "\(title ?? "nil") - \(indexPath.row)"
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("nested offset y: \(scrollView.contentOffset.y)")
        if MainTableViewController.nestedTableViewCanScroll {
            if scrollView.contentOffset.y < 0 {
                if isFingerTouching {
                    MainTableViewController.mainTableViewCanScroll = true
                    MainTableViewController.nestedTableViewCanScroll = false
                    scrollView.contentOffset = .zero
                }
            } else {
                MainTableViewController.mainTableViewCanScroll = false
            }
        } else {
            scrollView.contentOffset = .zero
        }
    }
    
    // MARK: - Table view scroll delegate
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isFingerTouching = true
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        isFingerTouching = false
    }
}
