//
//  ContentView.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/01/18.
//

import SwiftUI

struct ContentView: View {
    @StateObject var menuItemModel = MenuItemModel()

    var body: some View {
        VStack {
            Text("Menu Bar")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding()
            Text("Enabled Items")
                .font(.body)
            List {
                if menuItemModel.items.isEmpty {
                    Text("Drag something on here!")
                } else {
                    ForEach(menuItemModel.items.indices, id: \.self) { idx in
                        HStack {
                            Toggle("", isOn: $menuItemModel.items[idx].enabled)
                            MenuItemView(manifist: menuItemModel.items[idx])
                        }
                    }
                }
            }
            .listStyle(.plain)
            .padding()
        }
        .onDrop(of: [.zip, .fileURL], delegate: ZipDropDelegate(model: menuItemModel))
        .alert(isPresented: $menuItemModel.errorAlert) {
            Alert(title: Text("Error"),
                  message: Text(menuItemModel.errorContent!.localizedDescription),
                  dismissButton: .default(Text("OK")))
        }
        .frame(idealWidth: 800, maxWidth: .infinity, idealHeight: 600, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
