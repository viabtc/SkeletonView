//
//  CollectionSkeleton.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 02/11/2017.
//  Copyright © 2017 SkeletonView. All rights reserved.
//

import UIKit

enum CollectionAssociatedKeys {
    static var dummyDataSource = "dummyDataSource"
    static var dummyDelegate = "dummyDelegate"
    static var kOldScrollEnabled =             "kOldScrollEnabled"
    static var kSetScrollEnabled =             "kSetScrollEnabled"
    
}

protocol CollectionSkeleton {
    
    var skeletonDataSource: SkeletonCollectionDataSource? { get set }
    var skeletonDelegate: SkeletonCollectionDelegate? { get set }
    var estimatedNumberOfRows: Int { get }
    
    func addDummyDataSource()
    func updateDummyDataSource()
    func removeDummyDataSource(reloadAfter: Bool)
    func disableUserInteraction()
    func enableUserInteraction()
    
}

extension CollectionSkeleton where Self: UIScrollView {
    
    var isOldScrollEnabled: Bool {
        get {
            if let enabled = objc_getAssociatedObject(self, &CollectionAssociatedKeys.kOldScrollEnabled) as? Bool {
                return enabled
            }
            return true
        }
        set {
            objc_setAssociatedObject(self, &CollectionAssociatedKeys.kOldScrollEnabled, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var isSetScrollEnabled: Bool {
        get {
            if let enabled = objc_getAssociatedObject(self, &CollectionAssociatedKeys.kSetScrollEnabled) as? Bool {
                return enabled
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &CollectionAssociatedKeys.kSetScrollEnabled, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var estimatedNumberOfRows: Int { return 0 }
    func addDummyDataSource() {}
    func removeDummyDataSource(reloadAfter: Bool) {}

    func disableUserInteraction() {
        if isUserInteractionDisabledWhenSkeletonIsActive {
            isUserInteractionEnabled = false
            if isSetScrollEnabled {
                isScrollEnabled = self.isOldScrollEnabled
            } else {
                isSetScrollEnabled = true
                isOldScrollEnabled = isScrollEnabled
                isScrollEnabled = false
            }
        }
    }
    
    func enableUserInteraction() {
        if isUserInteractionDisabledWhenSkeletonIsActive {
            isUserInteractionEnabled = true
            if isSetScrollEnabled {
                isScrollEnabled = self.isOldScrollEnabled
            } else {
                isSetScrollEnabled = true
                isOldScrollEnabled = isScrollEnabled
                isScrollEnabled = true
            }
        }
    }
    
}

