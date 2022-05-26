//
//  MenuItemManifist.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/05/03.
//

import AppKit
import Foundation

struct MenuItemManifist: Identifiable {
    var name: String
    var author: String
    var desc: String
    var icon: NSImage?
    var id: UUID
    private var _enabled: Bool = false
    var enabled: Bool {
        get {
            return self._enabled
        }
        set(value) {
            self._enabled = value
        }
    }

    init(name: String, author: String, desc: String, id: UUID, appIcon: NSImage? = nil, enabled: Bool = false) {
        self.name = name
        self.author = author
        self.desc = desc
        self.id = id
        self.icon = appIcon
        self._enabled = enabled
    }
}
