//
//  SkeletonJoint.swift
//  AI_Tracking
//
//  Created by Rayyan Ashraf on 3/11/25.
//

import Foundation

/*
 This file defines the `SkeletonJoint` struct, which represents a single joint in the AR body tracking system.

 Key Components:
 - `name`: A string that identifies the joint (e.g., "left_knee_joint").
 - `position`: A 3D coordinate representing the joint's position in space using `SIMD3<Float>`.

 This struct is used to track and store the position of individual joints in the AR skeleton, allowing for visualization and skeletal movement updates.
 */

struct SkeletonJoint {
    let name: String  // The name of the joint (e.g., "left_elbow_joint")
    var position: SIMD3<Float>  // The 3D position of the joint in AR space
}

