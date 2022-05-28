//
//  Defaults+Extensions.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/05/28.
//

import Foundation
import Defaults

extension Defaults.Keys {
    static let enabledItems = Key<Set<UUID>>("enabledItems", default: [])
}
