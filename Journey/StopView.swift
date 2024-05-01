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
    @Environment(\.dismiss) var dismiss
    @Bindable var stop: Stop
    let isEditing: Bool
    @State private var isShowingCountryPicker = false
    
    var body: some View {
        NavigationView {
            
            Form {
                Section(header: Text("Dates")) {
                    Toggle(isOn: $stop.current, label: {
                        Text("Current location")
                    })
                    DatePicker("From: ", selection: $stop.fromDate, displayedComponents: .date)
                    if !stop.current {
                        DatePicker("To: ", selection: $stop.toDate, displayedComponents: .date)
                            .disabled(stop.current)
                    }
                }
                
                Section(header: Text("Location")) {
                    TextField("City name", text: $stop.city)
                    
                    Button(action: {
                        isShowingCountryPicker = true
                    }, label: {
                        let country = CountryManager.shared.country(withName: stop.countryName)!
                        HStack {
                            Image(uiImage: country.flag ?? UIImage(systemName: "x.circle")!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 20)
                            
                            Text(country.countryName)
                        }
                        
                    }).sheet(isPresented: $isShowingCountryPicker) {
                        CountryPickerViewProxy { chosenCountry in
                            stop.countryName = chosenCountry.countryName
                        }
                    }
                }
            }
            .navigationTitle("Stop")
            .toolbar {
                if !isEditing {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
            }
            
        }
        // Keep save button at the bottom of the screen
        .safeAreaInset(edge: .bottom, spacing: 0) {
                    footerView
                }
    }
    
    var footerView: some View {
        Button(action: {
            if isEditing {
                updateStop()
            } else {
                addStop()
            }
            
            dismiss()
        }, label: {
            if stop.fromDate > stop.toDate && !stop.current {
                Text("Invalid dates")
            } else {
                Text("Save")
            }
        })
        .disabled(stop.fromDate > stop.toDate && !stop.current)
    }
    
    // TODO: Implement update
    private func updateStop() {
    }
    
    private func addStop() {
        modelContext.insert(stop)
    }
}

#Preview {
    StopView(stop: Stop(fromDate: Date(), toDate: Date(), countryName: "New Zealand", city: "", current: false), isEditing: false)
}
