//
//  Console.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/06/27.
//

import Foundation
import JavaScriptCore

struct Console {
    static let log: @convention(block) (JSValue?) -> Void = { value in
        if value?.isUndefined ?? false {
            logger.log("")
        } else {
            logger.log("\(value?.toString() ?? "")")
        }
    }
}
