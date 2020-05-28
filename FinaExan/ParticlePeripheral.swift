//
//  ParticlePeripheral.swift
//  FinaExan
//
//  Created by apple on 5/27/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import CoreBluetooth

class ParticlePeripheral: NSObject {
    /// MARK: - Particle LED services and charcteristics Identifiers
    public static let particleBoatServiceUUID         = CBUUID.init(string: "b4250400-fb4b-4746-b2b0-93f0e61122c6")
    public static let forwardCharacteristicUUID      = CBUUID.init(string: "b4250401-fb4b-4746-b2b0-93f0e61122c6")
    public static let leftCharacteristicUUID         = CBUUID.init(string: "b4250402-fb4b-4746-b2b0-93f0e61122c6")
    public static let rightCharacteristicUUID        = CBUUID.init(string: "b4250403-fb4b-4746-b2b0-93f0e61122c6")
    public static let onOffSwitchCharacteristicUUID  = CBUUID.init(string: "b4250403-fb4b-4746-b2b0-93f0e61122c6")

}
