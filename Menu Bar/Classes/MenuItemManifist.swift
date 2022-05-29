//
//  MenuItemManifist.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/05/03.
//

import AppKit
import Foundation
import SwiftUI
import Defaults
import JavaScriptCore

class MenuItemManifist: Identifiable, Equatable, ObservableObject {
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
            if value {
                self.enableItem()
            } else {
                self.disableItem()
            }
            self._enabled = value
        }
    }
    var interpreter: MenuItemInterpreter?
    
    @Published var error: Error? = nil
    
    static func == (lhs: MenuItemManifist, rhs: MenuItemManifist) -> Bool {
        return lhs.id == rhs.id
    }

    convenience init(name: String, author: String, desc: String, icon: NSImage? = nil, script mainScript: String? = "index.js", enabled: Bool = false) {
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
        if enabled {
            self.enableItem()
        } else {
            self.disableItem()
        }
    }
    
    func enableItem() {
        Defaults[.enabledItems].insert(self.id)
        self.interpreter = MenuItemInterpreter(script: URL(fileURLWithPath: self.mainScript, relativeTo: defaultItemPath.appendingPathComponent(self.id.uuidString)))
        self.interpreter?.jscontext.exceptionHandler = self.exceptionHandler
        do {
            _ = try self.interpreter!.runScript()
        } catch {
            self.error = error
        }
    }

    func disableItem() {
        Defaults[.enabledItems].remove(self.id)
        self.interpreter = nil
    }
    
    func exceptionHandler(_: JSContext?, _ error: JSValue?) {
        if let error = error {
            self.error = MenuBarError.jsError(error.toString())
        }
    }
}
