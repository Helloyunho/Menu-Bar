//
//  MenuItemModel.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/05/06.
//

import Foundation
import Zip
import Defaults
import Combine

let defaultItemPath = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Menu Bar", isDirectory: true).appendingPathComponent("plugins", isDirectory: true)

class MenuItemModel: ObservableObject {
    @Published var items = [MenuItemManifist]()
    @Published var errorAlert = false
    var errorContent: Error? = nil
    var anyCancellables = [AnyCancellable]()
    
    static var shared = MenuItemModel()
    
    init() {
        self.errorWrapper {
            try self.loadItems()
        }
    }
    
    func loadItems() throws {
        try FileManager.default.createDirectory(at: defaultItemPath, withIntermediateDirectories: true)
        let items = try FileManager.default.contentsOfDirectory(at: defaultItemPath, includingPropertiesForKeys: [.isDirectoryKey])
        for item in items {
            self.errorWrapper {
                if try item.resourceValues(forKeys: [.isDirectoryKey]).isDirectory ?? false {
                    try self.loadItem(url: item)
                }
            }
        }
    }
    
    func loadItem(url: URL) throws {
        guard let id = UUID(uuidString: url.lastPathComponent) else {
            throw MenuBarError.directoryUUID
        }
        
        let manifistPath = url.appendingPathComponent("manifist").appendingPathExtension("json")
        if !FileManager.default.fileExists(atPath: manifistPath.path) {
            try FileManager.default.removeItem(at: url)
            throw MenuBarError.manifistFileNotFound
        }
        
        let decoder = JSONDecoder()
        let manifistJSON = try decoder.decode(MenuItemManifistJSON.self, from: Data(contentsOf: manifistPath))
        let enabled = Defaults[.enabledItems].contains(id)
        let manifist = MenuItemManifist(name: manifistJSON.name, author: manifistJSON.author, desc: manifistJSON.desc, id: id, script: manifistJSON.script, enabled: enabled)
        self.anyCancellables.append(manifist.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        })
        self.items.append(manifist)
    }

    func loadItems(items: [URL]) {
        for item in items {
            let id = UUID()
            let dest = defaultItemPath.appendingPathComponent(id.uuidString, isDirectory: true)
            self.errorWrapper {
                try Zip.unzipFile(item, destination: dest, overwrite: false, password: nil)
                try self.loadItem(url: dest)
            }
        }
    }

    func deleteItem(item: MenuItemManifist) {
        item.disableItem()
        self.items.removeAll { i in
            i == item
        }
        try? FileManager.default.removeItem(at: defaultItemPath.appendingPathComponent(item.id.uuidString, isDirectory: true))
    }
    
    func errorWrapper(action: () throws -> Void) {
        do {
            try action()
        } catch {
            self.errorContent = error
            self.errorAlert = true
        }
    }
    
    static func getErrorMessage(errorContent: Error?) -> String {
        guard let errorContent = errorContent else {
            return "I don't know... You weren't supposed to see this message..."
        }
        
        switch errorContent {
        case MenuBarError.directoryUUID:
            return "Some directories' name are not valid UUID."
        case MenuBarError.manifistFileNotFound:
            return "Manifist JSON could not be found."
        case MenuBarError.scriptFileNotFound:
            return "Script file could not be found."
        case MenuBarError.jsError(let error):
            return "JS Error: \(error)"
        case is DecodingError:
            return "Failed to parse manifist JSON. \(String(describing: errorContent))"
        default:
            return errorContent.localizedDescription
        }
    }
}
