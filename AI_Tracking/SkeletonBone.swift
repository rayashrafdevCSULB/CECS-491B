//
//  SkeletonBone.swift
//  AI_Tracking
//
//  Created by Rayyan Ashraf on 3/11/25.
//

import Foundation
import RealityKit

/*
 This file defines the `SkeletonBone` struct, which represents a bone in the AR body tracking system.
 
 Key Components:
 - `fromJoint` and `toJoint`: Represent the two joints that define the bone.
 - `centerPosition`: Calculates the midpoint between the two joints to determine the bone's central position.
 - `length`: Computes the length of the bone by measuring the distance between the two joints.
 
 This struct is used to create and manage the skeletal structure of the tracked body, helping to visualize the bones in RealityKit.
 */

struct SkeletonBone {
    var fromJoint: SkeletonJoint  // The starting joint of the bone
    var toJoint: SkeletonJoint    // The ending joint of the bone
    
    // Computes the center position of the bone by averaging the coordinates of the two joints
    var centerPosition: SIMD3<Float> {
        [(fromJoint.position.x + toJoint.position.x)/2,
         (fromJoint.position.y + toJoint.position.y)/2,
         (fromJoint.position.z + toJoint.position.z)/2]
    }
    
    // Calculates the length of the bone using the simd_distance function
    var length: Float {
        simd_distance(fromJoint.position, toJoint.position)
    }
}

