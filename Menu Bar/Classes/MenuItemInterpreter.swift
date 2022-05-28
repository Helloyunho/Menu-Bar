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
        self.jscontext.globalObject.setObject([:], forKeyedSubscript: "exports")
    }

    func runScript(code: String) -> JSValue! {
        return self.jscontext.evaluateScript(code)
    }
    
    func runScript(path: String) throws -> JSValue! {
        if !FileManager.default.fileExists(atPath: path) {
            throw MenuBarError.scriptFileNotFound
        }
        
        let scriptContent = try String(contentsOfFile: path)
        return self.runScript(code: scriptContent)
    }
    
    func runScript(url: URL) throws -> JSValue! {
        return try self.runScript(path: url.path)
    }
}
