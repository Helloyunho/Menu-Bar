//
//  MenuBar.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/06/27.
//

import Foundation
import JavaScriptCore
import AppKit

class MenuItemJS: NSObject, JSExport {
    var statusItem: NSStatusItem
    
    init(item: NSStatusItem) {
        self.statusItem = item
    }
}

@objc protocol MenuBarJSProtocol: JSExport {
    var SQUARE_LENGTH: CGFloat { get }
    var VARIABLE_LENGTH: CGFloat { get }
    
    @objc func makeMenuItem(_ length: CGFloat) -> MenuItemJS
    @objc func removeMenuItem(_ item: MenuItemJS)
}

class MenuBarJS: NSObject, MenuBarJSProtocol {
    dynamic var SQUARE_LENGTH: CGFloat {
        return NSStatusItem.squareLength
    }
    dynamic var VARIABLE_LENGTH: CGFloat {
        return NSStatusItem.variableLength
    }
    
    @objc func makeMenuItem(_ length: CGFloat) -> MenuItemJS {
        let item = NSStatusBar.system.statusItem(withLength: length)
        return MenuItemJS(item: item)
    }
    
    @objc func removeMenuItem(_ item: MenuItemJS) {
        NSStatusBar.system.removeStatusItem(item.statusItem)
    }
}
