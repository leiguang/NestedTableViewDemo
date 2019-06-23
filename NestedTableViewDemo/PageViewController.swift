//
//  PageViewController.swift
//  NestedTableViewDemo
//
//  Created by Guang Lei on 2019/6/20.
//  Copyright © 2019 leiguang. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var dataSources: [UIViewController] = []
    
    var currentIndex: Int = 0
    
    var indexDidChanged: ((_ newIndex: Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        setViewControllers([dataSources[currentIndex]], direction: .reverse, animated: true, completion: nil)
    }
    
    func slide(to index: Int) {
        guard index >= 0, index < dataSources.endIndex, index != currentIndex else { return }
        if index < currentIndex {
            setViewControllers([dataSources[index]], direction: .reverse, animated: true, completion: nil)
        } else if index > currentIndex {
            setViewControllers([dataSources[index]], direction: .forward, animated: true, completion: nil)
        }
        currentIndex = index
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = dataSources.firstIndex(of: viewController as! NestedTableViewController)!
        guard currentIndex > 0 else {
            return nil
        }
        return dataSources[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = dataSources.firstIndex(of: viewController as! NestedTableViewController)!
        guard currentIndex < dataSources.endIndex - 1 else {
            return nil
        }
        return dataSources[currentIndex + 1]
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
            let currentViewController = viewControllers?.first,
            let currentIndex = dataSources.firstIndex(of: currentViewController),
            currentIndex != self.currentIndex else {
                return
        }
        self.currentIndex = currentIndex
        indexDidChanged?(currentIndex)
    }
}
