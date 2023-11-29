//
//  ContentView.swift
//  Run Free
//
//  Created by Jordan Gallivan on 10/12/23.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject private var appData: AppData
    @EnvironmentObject var weatherData: FetchWeather
    @Environment(\.colorScheme) var colorScheme
    @State var showAddRunViewItems: Bool = false
    @State var selectedForecasts: Set<Forecast> = []
    
    var body: some View {
        NavigationStack(path: $appData.viewPath) {
            Group {
                switch weatherData.result {
                case .empty:
                    EmptyView()
                case .inProgress:
                    WeatherLoadingView()
                case let .success(weather):
                    VStack {
                        
                        Spacer()
                        Text("Current Weather")
                            .foregroundColor(.secondary)
                            .font(.title2)
                            .padding([.bottom], 2)
                        CurrentWeatherView(metar: weather.metar, colorScheme: colorScheme)
                            .padding([.leading, .trailing, .bottom], 5)
                        Divider()
                        
                        Text("Next 5 Hours")
                            .foregroundColor(.secondary)
                            .font(.title2)
                        VStack(spacing: 0) {
                            List {
                                ForEach(weather.taf.forecasts, id: \.self) { forecast in
                                    ForecastLine(forecast: forecast, colorScheme: colorScheme, expandedView: selectedForecasts.contains(forecast))
                                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                        .listRowSeparator(.hidden)
                                        .onTapGesture {
                                            if selectedForecasts.contains(forecast) {
                                                selectedForecasts.remove(forecast)
                                            } else {
                                                selectedForecasts.insert(forecast)
                                            }
                                        }
                                }
                            }
                            .listStyle(.plain)
                            
                        }
                        Divider()
                        
                        Spacer()
                        
                        RunButton()
                        
                        Spacer()
                        Spacer()


                    }
                    .padding(.top, 30)
                    .frame(maxWidth: .infinity)
                    .listStyle(.plain)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            SettingsButton()
                        }
                    }
                case let .failure(error):
                    VStack {
                        Image(systemName: "icloud.slash")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.red, .primary)
                            .font(.largeTitle)
                        Text("Error Loading Weather")
                            .font(.title)
                        RunButton()
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            SettingsButton()
                        }
                    }
                }
            }
            .navigationDestination(for: String.self, destination: { viewID in
                if viewID == "Settings View" {
                    SettingsView()
                } else if viewID == "Run View" {
                    RunView(showAddRunViewItems: $showAddRunViewItems)
                } else if viewID == "Weather View" {
                    WeatherView()
                }
                
            })
            .sheet(isPresented: $showAddRunViewItems) {
                AddRunViewItems()
            }
        }
        .task {
            await self.weatherData.reload()
        }
        .refreshable {
            await self.weatherData.reload()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

