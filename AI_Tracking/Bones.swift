//
//  Bones.swift
//  AI_Tracking
//
//  Created by Rayyan ashraf on 3/11/25.
//
/*
This file defines the `Bones` enumeration, which represents the key bones in a human skeleton for AR body tracking.

Each bone is defined as a case in the `Bones` enum and consists of:
- A `name` property that generates a unique identifier based on the joints it connects.
- A `jointFromName` property that specifies the starting joint of the bone.
- A `jointToName` property that specifies the ending joint of the bone.

These definitions allow the app to construct and visualize the skeletal structure by connecting corresponding joints in AR.
*/

import Foundation

enum Bones: CaseIterable {
    case leftShoulderToLeftArm
    case leftArmToLeftForearm
    case leftForearmToLeftHand
    
    case rightShoulderToRightArm
    case rightArmToRightForearm
    case rightForearmToRightHand

    case spine7ToLeftShoulder
    case spine7ToRightShoulder

    case neck1ToSpine7
    case spine7ToSpine6
    case spine6ToSpine5

    case hipsToLeftUpLeg
    case leftUpLegToLeftLeg
    case leftLegToLeftFoot

    case hipsToRightUpLeg
    case rightUpLegToRightLeg
    case rightLegToRightFoot
    
    var name: String {
        return "\(self.jointFromName)-\(self.jointToName)"
    }
    
    var jointFromName: String {
        switch self {
        case .leftShoulderToLeftArm:
            return "left_shoulder_1_joint"
        case .leftArmToLeftForearm:
            return "left_arm_joint"
        case .leftForearmToLeftHand:
            return "left_forearm_joint"
            
        case .rightShoulderToRightArm:
            return "right_shoulder_1_joint"
        case .rightArmToRightForearm:
            return "right_arm_joint"
        case .rightForearmToRightHand:
            return "right_forearm_joint"
            
        case .spine7ToLeftShoulder:
            return "spine_7_joint"
        case .spine7ToRightShoulder:
            return "spine_7_joint"
            
        case .neck1ToSpine7:
            return "neck_1_joint"
        case .spine7ToSpine6:
            return "spine_7_joint"
        case .spine6ToSpine5:
            return "spine_6_joint"
            
        case .hipsToLeftUpLeg:
            return "hips_joint"
        case .leftUpLegToLeftLeg:
            return "left_upLeg_joint"
        case .leftLegToLeftFoot:
            return "left_leg_joint"
        
        case .hipsToRightUpLeg:
            return "hips_joint"
        case .rightUpLegToRightLeg:
            return "right_upLeg_joint"
        case .rightLegToRightFoot:
            return "right_leg_joint"
        }
    }
    
    var jointToName: String {
        switch self {
        case .leftShoulderToLeftArm:
            return "left_arm_joint"
        case .leftArmToLeftForearm:
            return "left_forearm_joint"
        case .leftForearmToLeftHand:
            return "left_hand_joint"
            
        case .rightShoulderToRightArm:
            return "right_arm_joint"
        case .rightArmToRightForearm:
            return "right_forearm_joint"
        case .rightForearmToRightHand:
            return "right_hand_joint"
            
        case .spine7ToLeftShoulder:
            return "left_shoulder_1_joint"
        case .spine7ToRightShoulder:
            return "right_shoulder_1_joint"
            
        case .neck1ToSpine7:
            return "spine_7_joint"
        case .spine7ToSpine6:
            return "spine_6_joint"
        case .spine6ToSpine5:
            return "spine_5_joint"
            
        case .hipsToLeftUpLeg:
            return "left_upLeg_joint"
        case .leftUpLegToLeftLeg:
            return "left_leg_joint"
        case .leftLegToLeftFoot:
            return "left_foot_joint"
            
        case .hipsToRightUpLeg:
            return "right_upLeg_joint"
        case .rightUpLegToRightLeg:
            return "right_leg_joint"
        case .rightLegToRightFoot:
            return "right_foot_joint"
        }
    }
}
