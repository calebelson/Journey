//
//  StopListView.swift
//  Journey
//
//  Created by Caleb Elson on 5/1/24.
//

import SwiftUI
import SwiftData
import CountryPicker

struct StopListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var stops: [Stop]
    @State private var showingAddStopView = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(stops.sorted { $0.current == $1.current ? $0.toDate > $1.toDate : $0.current && !$1.current }) { stop in
                    NavigationLink {
                        StopView(stop: stop, isEditing: true)
                            .toolbar(.hidden, for: .tabBar)
                    } label: {
                        let country = CountryManager.shared.country(withName: stop.countryName)!
                        
                        Image(uiImage: country.flag!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 25)
                        
                        LabeledContent {
                            
                        } label: {
                            let cityName = stop.city != "" ? "\(stop.city), " : ""
                            Text(cityName + country.countryName)
                            
                            let formattedFrom = stop.fromDate.formatted(.dateTime.day().month().year())
                            let formattedTo = stop.current ? "Present" : stop.toDate.formatted(.dateTime.day().month().year())
                            
                            Text(formattedFrom + " - " + formattedTo)
                        }
                    }
                }
                .onDelete(perform: deleteStops)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {
                        showingAddStopView = true
                    }, label: {
                        Label("Add Stop", systemImage: "plus")
                    })
                    .sheet(isPresented: $showingAddStopView) {
                        let country = CountryManager.shared.currentCountry ?? Country.init(countryCode: "US")
                        let newStop = Stop(fromDate: Date(), toDate: Date(), countryName: country.countryName, city: "", current: false)
                        
                        StopView(stop: newStop, isEditing: false)
                    }
                }
            }
        } detail: {
            Text("Select a stop")
        }
        
    }

    private func deleteStops(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(stops[index])
            }
        }
    }
}

#Preview {
    StopListView()
        .modelContainer(for: Stop.self, inMemory: true)
}
