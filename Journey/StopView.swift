//
//  AddStop.swift
//  Journey
//
//  Created by Caleb Elson on 4/30/24.
//

import SwiftUI
import SwiftData
import CountryPicker

struct StopView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    var stop: Stop
    @State private var selectedCountry: String = ""
    @State private var fromDate = Date()
    @State private var toDate = Date()
    @State private var currentLocation = false
    @State private var country: Country = CountryManager.shared.currentCountry ?? Country.init(countryCode: "US")
    @State private var isShowingCountryPicker = false
    @State private var cityLabel = ""
    
    var body: some View {
        //NavigationView {
        Form {
            Section(header: Text("Dates")) {
                Toggle(isOn: $currentLocation, label: {
                    Text("Current location")
                })
                DatePicker("From: ", selection: $fromDate, displayedComponents: .date)
                DatePicker("To: ", selection: $toDate, displayedComponents: .date)
                    .disabled(currentLocation)
            }
            
            Section(header: Text("Location")) {
                TextField("City name", text: $cityLabel)
                Button(country.countryName) {
                    isShowingCountryPicker = true
                }.sheet(isPresented: $isShowingCountryPicker) {
                    CountryPickerViewProxy { chosenCountry in
                        country = chosenCountry
                    }
                }
            }
            Section {
                Button(action: {}, label: {
                    if fromDate > toDate && !currentLocation {
                        Text("Invalid dates")
                    } else {
                        Text("Save")
                    }
                })
            }
            .disabled(fromDate > toDate && !currentLocation)
        }
        
        Button(action: {
            addStop()
            isPresented = false
            
        }, label: {
            if fromDate > toDate && !currentLocation {
                Text("Invalid dates")
            } else {
                Text("Save")
            }
        })
        .disabled(fromDate > toDate && !currentLocation)
        //}
    }
    
    private func addStop() {
        let newStop = Stop(fromDate: fromDate, toDate: (currentLocation ? Date() : toDate), countryName: country.countryName, countryFlag: country.flag!.description, city: cityLabel, current: currentLocation)
        modelContext.insert(newStop)
    }
}

#Preview {
    StopView(isPresented: .constant(true), stop: Stop(fromDate: Date(), toDate: Date(), countryName: "New Zealand", countryFlag: "New Zealand", city: "Auckland", current: false))
}
