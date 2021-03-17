//
//  UserDefaults+Ext.swift
//  FocusStart-Notes
//
//  Created by Ермоленко Константин on 17.03.2021.
//

import Foundation

extension UserDefaults {
    static func isFirstLaunch() -> Bool {
        let LaunchedBefore = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: LaunchedBefore)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: LaunchedBefore)
        }
        
        return isFirstLaunch
    }
}
