//
//  RunView.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/8/23.
//

import Foundation
import SwiftUI

struct RunView: View {
    @EnvironmentObject private var appData: AppData
    @State private var editActive: Bool = false
    @Binding var showAddRunViewItems: Bool
    
    var body: some View {
        VStack {
            List {
                ForEach(appData.runViewItems, id: \.anyHashableID) { runViewItem in
                    if runViewItem.isVisible {
                        runViewItem
                    }
                }
                .onMove { source, destination in
                    appData.runViewItems.move(fromOffsets: source, toOffset: destination)
                }
                .onDelete { indexes in
//                    for index in indexes {
//                        appData.runViewItems[index].isVisible = false
//                    }
                    deleteRunViewItems(indexes)
                }
            }
            .listStyle(.plain)
            .environment(\.editMode, .constant(editActive ? EditMode.active : EditMode.inactive))
            
            
            if !appData.timerPaused {
                Button(appData.timerActive ? "  Stop  " : "   Run!   " ) {
                    if !appData.timerActive {
                        Task(priority: .high) {
                            await appData.activateElapsedTimer()
                        }
                    } else {
                        appData.pauseElapsedTimer()
                    }
                }
                .buttonStyle(DefaultButton(buttonColor: appData.timerActive ? .red : .green, textColor: .white))
            } else {
                HStack {
                    Spacer()
                    Button("Resume") {
                        Task(priority: .high) {
                            await appData.activateElapsedTimer()
                        }
                    }
                    .buttonStyle(DefaultButton(buttonColor: .green, textColor: .white))
                    Spacer()
                    Button("  Reset  ") {
                        appData.deactivateElapsedTimer()
                    }
                    .buttonStyle(DefaultButton(buttonColor: .red, textColor: .white))
                    Spacer()
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button(editActive ? "Done" : "Edit") {
                    editActive.toggle()
                }
            }
            ToolbarItem {
                if editActive {
                    Button(action: {
                        showAddRunViewItems.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
                } else {
                    SettingsButton()
                }
            }
        }
    }
    
    private func deleteRunViewItems(_ indexes: IndexSet) {
        var itemsToDelete: Set<RunViewItem> = []
        indexes.forEach { index in
            itemsToDelete.insert(appData.runViewItems[index])
        }
        itemsToDelete.forEach { item in
            for i in 0..<appData.runViewItems.count {
                if appData.runViewItems[i].name == item.name {
                    appData.runViewItems.remove(at: i)
                    appData.runViewItems.append(item)
                    break
                }
            }
        }
        for i in 1...itemsToDelete.count {
            appData.runViewItems[appData.runViewItems.count - i].isVisible = false
        }
    }
}
