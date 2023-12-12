//
//  RunView.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/8/23.
//

import Foundation
import SwiftUI
import SwiftData

struct RunView: View {
    @EnvironmentObject private var appData: AppData
    @EnvironmentObject private var controller: PolarController
    @Environment(\.modelContext) var dbContext
    @Query(sort: \RunComponentModel.position, order: .forward) var runComponents: [RunComponentModel]
    
    // Query Settings Model.  Only one model in context, ensured at application initialization
    @Query private var settingsQuery: [SettingsModel]
    private var settings: SettingsModel { settingsQuery.first! }
    
    @State private var editActive: Bool = false // toggles overriden edit mode of List
    @State private var editRunComponentSettings: Bool = false   // activates sheet to edit individual components
    @State private var settingsDetent: PresentationDetent = .medium // initial component settings sheet size
    @State private var addRunComponents: Bool = false   // activates AddRunViewItems sheet
    // initial AddRunViewItems sheet size
    @State private var addRunComponentDetent: PresentationDetent = PresentationDetent.fraction(CGFloat(0.25))
    
    
    var body: some View {
        VStack {
            List {
                ForEach(runComponents, id: \.self) { runComponent in
                    // verify component is visible and only display zones if in use by user
                    if runComponent.isVisible &&
                        (runComponent.runComponentType != .zones  || (runComponent.runComponentType == .zones && settings.useHeartRateZones )) {
                        RunComponentView(runViewComponent: runComponent)
                            .onTapGesture {
                                // override tap gesture in edit mode to customize component settings
                                if editActive && runComponent.runComponentType != .zones {
                                    appData.selectedComponentToEdit = runComponent
                                    editRunComponentSettings = true
                                }
                            }
                            .listRowSeparator(.hidden)
                    }
                }
                .onMove { source, destination in
                    var updatedPositions = runComponents
                    updatedPositions.move(fromOffsets: source, toOffset: destination)
                    for (index, item) in updatedPositions.enumerated() {
                        item.position = index
                    }
                }
                .onDelete { indexes in
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
                            controller.hrStreamStart()
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
                        controller.hrStreamStop()
                    }
                    .buttonStyle(DefaultButton(buttonColor: .red, textColor: .white))
                    Spacer()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    appData.viewPath.removeLast()
                }, label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                            .symbolRenderingMode(.palette)
                            .foregroundColor(.accentColor)
                        Text("Weather")
                            .foregroundColor(.accentColor)
                    }
                })
            }
            ToolbarItem {
                Button(editActive ? "Done" : "Edit") {
                    editActive.toggle()
                }
            }
            ToolbarItem {
                if editActive {
                    Button(action: {
                        addRunComponents.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
                } else {
                    SettingsButton()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            // disable screen idling
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            // re-enable screen idling
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .sheet(isPresented: $editRunComponentSettings) {
            // customize component settings
            RunComponentSettingsView()
                .presentationDetents(
                    [.medium],
                    selection: $settingsDetent
                )
        }
        .sheet(isPresented: $addRunComponents) {
            // add components not currently displayed
            AddRunViewItems()
                .presentationDetents(
                    [PresentationDetent.fraction(CGFloat(0.25)), PresentationDetent.fraction(CGFloat(0.10))],
                    selection: $addRunComponentDetent
                )
        }
    }
    
    private func deleteRunViewItems(_ indexes: IndexSet) {
        // duplicate items to be deleted
        var itemsToDelete: Set<RunComponentModel> = []
        var updatedPositions = runComponents
        indexes.forEach { index in
            itemsToDelete.insert(runComponents[index])
        }
        
        // iterate over queried components, move components to delete to end of array
        itemsToDelete.forEach { item in
            for i in 0..<updatedPositions.count {
                if updatedPositions[i].name == item.name {
                    updatedPositions.remove(at: i)
                    updatedPositions.append(item)
                    break
                }
            }
        }
        
        // toggle isVisible for delted items
        for i in 1...itemsToDelete.count {
            updatedPositions[updatedPositions.count - i].isVisible = false
        }
        
        // update position of each component
        for (index, item) in updatedPositions.enumerated() {
            item.position = index
        }
    }
}
