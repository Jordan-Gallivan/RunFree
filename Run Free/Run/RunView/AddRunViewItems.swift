//
//  AddRunViewItems.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/26/23.
//

import Foundation
import SwiftUI

struct AddRunViewItems: View {
    @EnvironmentObject private var appData: AppData
    @Environment(\.dismiss) var dismiss
        
    @State private var selectedRows: Set<RunViewItem.ID> = []
    
    
    var body: some View {
        VStack {
            List(selection: $selectedRows) {
                ForEach(appData.runViewItems) { runViewItem in
                    if !runViewItem.isVisible {
                        HStack {
                            if selectedRows.contains(runViewItem.id) {
                                Image(systemName: "circle.inset.filled")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.green, .primary)
                            } else {
                                Image(systemName: "circle")
                            }
                            Text(runViewItem.name)
                                .font(.title2)
                        }
                        .onTapGesture {
                            itemSelected(item: runViewItem.id)
                        }
                    }
                }
                .listStyle(.plain)
            }
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .padding()
                if selectedRows.count > 0 {
                    Button("Add Selected") {
                        addItems()
                    }
                    .padding()
                }
            }
        }
    }
    
    private func addItems() {
        for item in selectedRows {
            if let index = appData.runViewItems.firstIndex(where: { $0.id == item }) {
                appData.runViewItems[index].isVisible = true
            }
        }
        dismiss()
    }
    
    private func itemSelected(item: RunViewItem.ID) {
        if selectedRows.contains(item) {
            selectedRows.remove(item)
        } else {
            selectedRows.insert(item)
        }
        
    }
    
    
}
