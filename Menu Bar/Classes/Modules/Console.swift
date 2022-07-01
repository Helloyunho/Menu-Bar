//
//  Console.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/06/27.
//

import Foundation
import JavaScriptCore

@objc protocol ConsoleJSProtocol: JSExport {
    @objc func log() -> Void
}

class ConsoleJS: NSObject, ConsoleJSProtocol {
    @objc func log() {
        if let args = JSContext.currentArguments() as? [JSValue?] {
            logger.log("\(args.map { $0?.toString() ?? "" }.joined(separator: " "))")
        } else {
            logger.log("")
        }
    }
}
