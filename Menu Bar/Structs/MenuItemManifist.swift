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
    var mainScript: String = "index.js"
    private var _enabled: Bool = false
    var enabled: Bool {
        get {
            return self._enabled
        }
        set(value) {
            self._enabled = value
        }
    }

    init(name: String, author: String, desc: String, icon: NSImage? = nil, script mainScript: String? = "index.js", enabled: Bool = false) {
        self.init(name: name, author: author, desc: desc, id: UUID(), icon: icon, script: mainScript, enabled: enabled)
    }

    init(name: String, author: String, desc: String, id: UUID, icon: NSImage? = nil, script mainScript: String? = "index.js", enabled: Bool = false) {
        self.name = name
        self.author = author
        self.desc = desc
        self.id = id
        self.icon = icon
        if let mainScript = mainScript {
            self.mainScript = mainScript
        }
        self._enabled = enabled
    }
}
