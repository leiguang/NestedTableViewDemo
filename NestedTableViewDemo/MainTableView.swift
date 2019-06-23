//
//  MainTableView.swift
//  NestedTableViewDemo
//
//  Created by Guang Lei on 2019/6/23.
//  Copyright © 2019 leiguang. All rights reserved.
//

import UIKit

class MainTableView: UITableView {}

extension MainTableView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer is UIPanGestureRecognizer && otherGestureRecognizer is UIPanGestureRecognizer else {
            return false
        }
        return true
    }
}
