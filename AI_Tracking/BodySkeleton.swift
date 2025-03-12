/*
This file defines the `BodySkeleton` class, which is responsible for creating, updating, and rendering
a human skeleton representation using ARKit's body tracking capabilities.

It includes:
- A system for managing AR body joints and bones using RealityKit.
- Initialization of tracked joints with appropriate sizes and colors.
- Methods to update joint and bone positions based on AR body anchor updates.
- Functions to create joint and bone entities for visualization.

The class utilizes ARKit’s `ARSkeletonDefinition` and `ARBodyAnchor` to track human movement in real time.
*/

import Foundation
import RealityKit
import ARKit

// BodySkeleton class to represent a tracked body in AR
class BodySkeleton: Entity {
    // Dictionary to store joint entities, mapped by joint names
    var joints: [String: Entity] = [:]

    // Dictionary to store bone entities, mapped by bone names
    var bones: [String: Entity] = [:]

    // Required initializer to create a body skeleton based on ARBodyAnchor data
    required init(for bodyAnchor: ARBodyAnchor) {
        super.init()

        // Ensure RealityKit loads required resources (Fix for missing shaders)
        Task {
            do {
                try await Entity(named: "default")
            } catch {
                print("RealityKit Shader Loading Error: \(error.localizedDescription)")
            }
        }

        // Loop through all joints defined in the default 3D body skeleton
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            var jointRadius: Float = 0.05
            var jointColor: UIColor = .green

            // Adjust joint size and color based on its type
            switch jointName {
            case "neck_1_joint", "neck_2_joint", "neck_3_joint", "neck_4_joint", "head_joint",
                 "left_shoulder_1_joint", "right_shoulder_1_joint":
                jointRadius *= 0.5 // Reduce size for neck and shoulder joints

            case "jaw_joint", "chin_joint", "left_eye_joint", "left_eyeLowerLid_joint",
                 "left_eyeUpperLid_joint", "left_eyeball_joint", "nose_joint",
                 "right_eye_joint", "right_eyeLowerLid_joint", "right_eyeUpperLid_joint",
                 "right_eyeball_joint":
                jointRadius *= 0.2 // Smaller size for facial joints
                jointColor = .yellow

            case _ where jointName.hasPrefix("spine_"):
                jointRadius *= 0.75 // Larger size for spine joints

            case "left_hand_joint", "right_hand_joint":
                jointRadius *= 1 // Keep default size for hands
                jointColor = .green

            case _ where jointName.hasPrefix("left_hand") || jointName.hasPrefix("right_hand"):
                jointRadius *= 0.25 // Smaller size for hand joints
                jointColor = .yellow

            case _ where jointName.hasPrefix("left_toes") || jointName.hasPrefix("right_toes"):
                jointRadius *= 0.5 // Reduce size for toe joints
                jointColor = .yellow

            default:
                jointRadius = 0.05 // Default size for other joints
                jointColor = .green
            }

            // Create an entity for the joint and add it to the skeleton
            let jointEntity = createJointEntity(radius: jointRadius, color: jointColor)
            joints[jointName] = jointEntity
            self.addChild(jointEntity)
        }

        // Call update once to set initial joint positions
        self.update(with: bodyAnchor)

        // Loop through all bones and create corresponding entities
        for bone in Bones.allCases {
            guard let skeletonBone = createSkeletonBone(bone: bone, bodyAnchor: bodyAnchor) else { continue }

            // Create an entity for the bone and add it to the skeleton
            let boneEntity = createBoneEntity(for: skeletonBone)
            bones[bone.name] = boneEntity
            self.addChild(boneEntity)
        }
    }

    // Default required initializer (not implemented for this class)
    required init() {
        fatalError("init() has not been implemented")
    }

    // Function to update joint and bone positions based on the latest ARBodyAnchor data
    func update(with bodyAnchor: ARBodyAnchor) {
        // Align BodySkeleton with the bodyAnchor (rooted at the hip joint)
        self.setTransformMatrix(bodyAnchor.transform, relativeTo: nil)

        // Update transforms for each tracked joint entity
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            if let jointEntity = joints[jointName],
               let jointEntityTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: jointName)) {
                jointEntity.setTransformMatrix(jointEntityTransform, relativeTo: self)
            }
        }

        // Update bone positions and orientations
        for bone in Bones.allCases {
            let boneName = bone.name
            guard let entity = bones[boneName],
                  let skeletonBone = createSkeletonBone(bone: bone, bodyAnchor: bodyAnchor)
            else { continue }

            // Position the bone entity at the center of the corresponding joint pair
            entity.position = skeletonBone.centerPosition

            // Adjust bone orientation based on joint alignment
            entity.look(at: skeletonBone.toJoint.position, from: skeletonBone.centerPosition, relativeTo: nil)
        }
    }

    // Function to create a spherical entity representing a joint
    private func createJointEntity(radius: Float, color: UIColor = .white) -> Entity {
        let mesh = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(color: color, roughness: 0.8, isMetallic: false)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        return entity
    }

    // Function to create a skeleton bone representation
    private func createSkeletonBone(bone: Bones, bodyAnchor: ARBodyAnchor) -> SkeletonBone? {
        guard let fromJointEntity = joints[bone.jointFromName],
              let toJointEntity = joints[bone.jointToName] else {
            return nil
        }

        // Get world-space positions of the joints
        let fromPosition = fromJointEntity.position(relativeTo: nil)
        let toPosition = toJointEntity.position(relativeTo: nil)

        // Create skeleton joints
        let fromJoint = SkeletonJoint(name: bone.jointFromName, position: fromPosition)
        let toJoint = SkeletonJoint(name: bone.jointToName, position: toPosition)

        // Create and return skeleton bone
        return SkeletonBone(fromJoint: fromJoint, toJoint: toJoint)
    }

    // Function to create a box-shaped entity representing a bone
    private func createBoneEntity(for skeletonBone: SkeletonBone, diameter: Float = 0.04, color: UIColor = .white) -> Entity {
        let mesh = MeshResource.generateBox(size: [diameter, diameter, skeletonBone.length], cornerRadius: diameter / 2)
        let material = SimpleMaterial(color: color, roughness: 0.5, isMetallic: true)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        return entity
    }
}

