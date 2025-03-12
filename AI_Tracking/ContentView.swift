//
//  ContentView.swift
//  AI_Tracking
//
//  Created by Rayyan Ashraf on 3/11/25.
//

import SwiftUI

/*
 This file defines the `ContentView` struct, which serves as the main user interface for the AR body tracking application.
 
 Key components:
 - `ContentView`: A SwiftUI view that embeds the `ARViewContainer`, which is responsible for rendering the AR experience.
 - `.edgesIgnoringSafeArea(.all)`: Ensures that the AR view extends to cover the entire screen.
 - `ContentView_Previews`: A preview provider for SwiftUI previews in Xcode.
 
 This file acts as the entry point for displaying the AR tracking interface in the app.
 */

struct ContentView: View {
    var body: some View {
        // Embeds the ARViewContainer in the SwiftUI interface
        ARViewContainer()
            .edgesIgnoringSafeArea(.all) // Ensures the AR view covers the entire screen
    }
}

// Provides a preview of ContentView for SwiftUI Previews in Xcode
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

