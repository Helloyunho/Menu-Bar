//
//  MenuBar.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/06/27.
//

import Foundation
import JavaScriptCore
import AppKit

@objc protocol MenuItemJSProtocol: JSExport {
    init(_ length: CGFloat)

    @objc func remove() -> Bool
}

class MenuItemJS: NSObject, MenuItemJSProtocol {
    var statusItem: NSStatusItem?
    
    required init(_ length: CGFloat) {
        self.statusItem = NSStatusBar.system.statusItem(withLength: length)
    }

    @objc func remove() -> Bool {
        if let statusItem = statusItem {
            NSStatusBar.system.removeStatusItem(statusItem)
            return true
        }
        return false
    }
}

@objc protocol MenuBarJSProtocol: JSExport {
    var SQUARE_LENGTH: CGFloat { get }
    var VARIABLE_LENGTH: CGFloat { get }
    var MenuItem: MenuItemJS.Type { get }
}

class MenuBarJS: NSObject, MenuBarJSProtocol {
    dynamic var SQUARE_LENGTH: CGFloat {
        return NSStatusItem.squareLength
    }
    dynamic var VARIABLE_LENGTH: CGFloat {
        return NSStatusItem.variableLength
    }
    dynamic var MenuItem: MenuItemJS.Type {
        return MenuItemJS.self
    }
}
