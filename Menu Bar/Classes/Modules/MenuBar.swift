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
    @objc init(_ length: CGFloat)

    @objc func remove() -> Bool
}

class MenuItemJS: NSObject, MenuItemJSProtocol {
    var statusItem: NSStatusItem?
    
    @objc required init(_ length: CGFloat) {
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

func MenuBarJSInit(context: JSContext) -> JSValue {
    let exported = JSValue(newObjectIn: context)!
    exported.setObject(NSStatusItem.squareLength, forKeyedSubscript: "SQUARE_LENGTH")
    exported.setObject(NSStatusItem.variableLength, forKeyedSubscript: "VARIABLE_LENGTH")
    let constructor: @convention(block) (CGFloat) -> (MenuItemJS) = { length in
        return MenuItemJS(length)
    }
    exported.setObject(constructor, forKeyedSubscript: "MenuItem")
    return exported
}
