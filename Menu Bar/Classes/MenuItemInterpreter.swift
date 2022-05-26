//
//  MenuItemInterpreter.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/05/07.
//

import AppKit
import Foundation
import JavaScriptCore

class MenuItemInterpreter {
    var jscontext: JSContext!

    init() {
        let jscontext = JSContext()
        self.jscontext = jscontext!
    }

    func runScript(code: String) -> JSValue! {
        return self.jscontext.evaluateScript(code)
    }
}
