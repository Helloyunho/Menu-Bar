//
//  MenuItemInterpreter.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/05/07.
//

import AppKit
import Foundation
import JavaScriptCore

class JSVMWithModuleCache: JSVirtualMachine {
    var cachedModules = [String: JSValue?]()
}

class MenuItemInterpreter {
    let jscontext: JSContext!
    let scriptURL: URL
    let scriptDirURL: URL
    let jsVM: JSVMWithModuleCache!

    convenience init(script: URL) {
        self.init(script: script, vm: JSVMWithModuleCache()!)
    }
    
    init(script: URL, vm: JSVMWithModuleCache) {
        let jscontext = JSContext(virtualMachine: vm)
        self.jscontext = jscontext!
        self.jsVM = vm
        
        let requireBlock: @convention(block) (String) -> (JSValue?) = { module in
            let expandedModule = NSString(string: module).expandingTildeInPath
            if let cachedModule = vm.cachedModules[expandedModule] {
                return cachedModule
            }
            
            if !FileManager.default.fileExists(atPath: expandedModule) {
                jscontext!.exception = JSValue(newErrorFromMessage: "Module \(expandedModule) not found.", in: jscontext)
                return nil
            }
            
            let context = MenuItemInterpreter(script: URL(fileURLWithPath: expandedModule), vm: vm)
            let value = try! context.runScript()
            context.jscontext.globalObject.objectForKeyedSubscript("exports")
            vm.cachedModules[expandedModule] = value
            return value
        }

        self.jscontext.globalObject.setObject([:], forKeyedSubscript: "exports")
        self.jscontext.globalObject.setObject(requireBlock, forKeyedSubscript: "require")
        self.scriptURL = script
        self.scriptDirURL = script.deletingLastPathComponent()
    }

    func runScript(code: String, path: String) -> JSValue! {
        return self.jscontext.evaluateScript(code, withSourceURL: URL(fileURLWithPath: path))
    }
    
    func runScript(path: String) throws -> JSValue! {
        if !FileManager.default.fileExists(atPath: path) {
            throw MenuBarError.scriptFileNotFound
        }
        
        let scriptContent = try String(contentsOfFile: path)
        return self.runScript(code: scriptContent, path: path)
    }
    
    func runScript(url: URL) throws -> JSValue! {
        return try self.runScript(path: url.path)
    }
    
    func runScript() throws -> JSValue! {
        return try self.runScript(url: self.scriptURL)
    }
}
