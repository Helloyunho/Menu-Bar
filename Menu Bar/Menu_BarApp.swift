//
//  Menu_BarApp.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/01/18.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItems: [NSStatusItem]!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItems = []
        statusItems.append(NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength))
        statusItems.append(NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength))
        statusItems[0].button?.title = "test"
        statusItems[1].button?.title = "test1"
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

@main
struct Menu_BarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appdelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
