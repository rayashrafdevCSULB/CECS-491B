/*
This file defines the `ARViewContainer` struct, which is responsible for setting up and managing
an ARKit-based body tracking experience using RealityKit.

It includes:
- An `ARViewContainer` that integrates an ARView into a SwiftUI interface.
- A body skeleton tracking system that detects and updates human body movements in real time.
- An `ARSessionDelegate` extension to handle AR session updates, including tracking body anchors.

The application utilizes ARKit's `ARBodyTrackingConfiguration` to detect and visualize skeletal movement.
*/

import SwiftUI
import ARKit
import RealityKit

// Private variable to store the body skeleton entity
private var bodySkeleton: BodySkeleton?

// Anchor entity to hold the body skeleton in the AR scene
private let bodySkeletonAnchor = AnchorEntity()

// ARViewContainer struct conforming to UIViewRepresentable to create and manage the ARView
struct ARViewContainer: UIViewRepresentable {
    // Specifies the type of UIView being created
    typealias UIViewType = ARView

    // Function to create and configure the ARView
    func makeUIView(context: Context) -> ARView {
        // Initialize ARView with an AR camera mode and automatic session configuration
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)

        // Set up ARKit body tracking configuration
        let configuration = ARBodyTrackingConfiguration()
        configuration.isAutoFocusEnabled = false // Disable autofocus to reduce resource usage
        configuration.environmentTexturing = .automatic // Enable realistic environment textures

        // Run the AR session with the configured body tracking setup
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        // Add the body skeleton anchor to the AR scene
        arView.scene.addAnchor(bodySkeletonAnchor)

        // Return the configured ARView
        return arView
    }

    // Function to update the ARView (currently left empty)
    func updateUIView(_ uiView: ARView, context: Context) {}
}

// Extension of ARView to conform to ARSessionDelegate for handling AR session updates
extension ARView: ARSessionDelegate {
    // Function to configure ARView for body tracking
    func setupForBodyTracking() {
        let configuration = ARBodyTrackingConfiguration() // Create body tracking configuration

        // Run AR session with body tracking and reset previous tracking data
        self.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        // Set the AR session delegate to self to handle session events
        self.session.delegate = self
    }

    // Function to handle session failure and print error messages
    public func session(_ session: ARSession, didFailWithError error: Error) {
        print("ARSession failed: \(error.localizedDescription)")
    }

    // Function to handle updates to AR anchors in the session
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        // Loop through all detected anchors
        for anchor in anchors {
            // Check if the anchor is a body anchor
            if let bodyAnchor = anchor as? ARBodyAnchor {
                if let skeleton = bodySkeleton {
                    // If the BodySkeleton already exists, update all joints and bones
                    skeleton.update(with: bodyAnchor)
                } else {
                    // If the BodySkeleton does not exist, create a new instance
                    // This means a body has been detected for the first time
                    bodySkeleton = BodySkeleton(for: bodyAnchor)

                    // Add the newly created body skeleton to the bodySkeletonAnchor
                    bodySkeletonAnchor.addChild(bodySkeleton!)
                }
            }
        }
    }
}

