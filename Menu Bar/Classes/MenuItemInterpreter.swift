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
    var cachedModules: [String: Any] = [:]
    
    override init!() {
        super.init()
        cachedModules["menuBar"] = MenuBarJS()
    }
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
        self.scriptURL = script
        self.scriptDirURL = script.deletingLastPathComponent()
        
        let requireBlock: @convention(block) (String) -> (Any?) = { module in
            if let cachedModule = vm.cachedModules[module] {
                return cachedModule
            }

            let expandedModule = URL(fileURLWithPath: module, relativeTo: script.deletingLastPathComponent())
            if let cachedModule = vm.cachedModules[module] {
                return cachedModule
            }

            if !FileManager.default.fileExists(atPath: expandedModule.path) {
                jscontext!.exception = JSValue(newErrorFromMessage: "Module \(expandedModule) not found.", in: jscontext)
                return nil
            }

            let context = MenuItemInterpreter(script: expandedModule, vm: vm)
            _ = try! context.runScript()
            let exported = context.jscontext.globalObject.objectForKeyedSubscript("exports")
            vm.cachedModules[expandedModule.path] = exported
            return exported
        }

        self.jscontext.globalObject.setObject([:], forKeyedSubscript: "exports")
        self.jscontext.globalObject.setObject(requireBlock, forKeyedSubscript: "require")
    }

    func runScript(code: String, path: String) -> JSValue! {
        let result = self.jscontext.evaluateScript(code, withSourceURL: URL(fileURLWithPath: path))
        self.jsVM.cachedModules[path] = result
        return result
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
