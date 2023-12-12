//
//  AddRunViewItems.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/26/23.
//

import Foundation
import SwiftData
import SwiftUI

/// Sheet to toggle visibility of components not currently displayed
struct AddRunComponents: View {
    @EnvironmentObject private var appData: AppData
    @Environment(\.modelContext) var dbContext
    @Query(sort: \RunComponentModel.position, order: .forward) var runComponents: [RunComponentModel]
    
    var body: some View {
        List {
            ForEach(runComponents, id: \.self) { runComponent in
                if !runComponent.isVisible {
                    Text(runComponent.name)
                        .onTapGesture {
                            runComponent.isVisible.toggle()
                        }
                }
            }
        }
    }
}
