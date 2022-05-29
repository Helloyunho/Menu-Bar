//
//  ContentView.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/01/18.
//

import SwiftUI

struct ContentView: View {
    @StateObject var menuItemModel = MenuItemModel.shared
    @State var selectedItem: MenuItemManifist? = nil

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
                    Text("You have no items right now. Find some menu items and drop on here!")
                } else {
                    ForEach(menuItemModel.items.indices, id: \.self) { idx in
                        HStack {
                            Toggle("", isOn: $menuItemModel.items[idx].enabled)
                            MenuItemView(manifist: menuItemModel.items[idx])
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedItem = menuItemModel.items[idx]
                        }
                        .contextMenu {
                            Button("Delete") {
                                menuItemModel.deleteItem(item: menuItemModel.items[idx])
                            }
                        }
                        .padding([.leading])
                        .background(selectedItem == menuItemModel.items[idx] ? Color.accentColor : Color.clear)
                    }
                }
            }
            .listStyle(.plain)
            .padding()
        }
        .onDrop(of: [.zip, .fileURL], delegate: ZipDropDelegate(model: menuItemModel))
        .alert(isPresented: $menuItemModel.errorAlert) {
            Alert(title: Text("Error"),
                  message: Text(MenuItemModel.getErrorMessage(errorContent: self.menuItemModel.errorContent)),
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
