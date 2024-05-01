//
//  MainView.swift
//  Journey
//
//  Created by Caleb Elson on 5/1/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            JourneyView()
                .tabItem {
                    Label("Journey", systemImage: "map.circle.fill")
                }
            
            StopListView()
                .tabItem {
                    Label("Stops", systemImage: "mappin.and.ellipse.circle.fill")
                }
        }
    }
}

#Preview {
    MainView()
}
