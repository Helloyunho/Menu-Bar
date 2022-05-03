//
//  MenuItemManifist.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/05/03.
//

import Foundation
import AppKit

struct MenuItemManifist: Identifiable {
    var name: String
    var author: String
    var desc: String
    var appIcon: NSImage? = nil
    var id: UUID
}
