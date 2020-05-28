//
//  ViewController.swift
//  FinaExan
//
//  Created by apple on 5/27/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    
    private var forwardChar: CBCharacteristic?
    private var leftChar: CBCharacteristic?
    private var rightChar: CBCharacteristic?
    private var onOffChar: CBCharacteristic?
    
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var onOffSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        forwardButton.layer.cornerRadius = 5
        leftButton.layer.cornerRadius = 5
        rightButton.layer.cornerRadius = 5
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        if central.state != .poweredOn {
            print("Central is not powered on")
        } else {
            print("Central scanning for", ParticlePeripheral.particleBoatServiceUUID);
            centralManager.scanForPeripherals(withServices: [ParticlePeripheral.particleBoatServiceUUID],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        // We've found it so stop scan
        self.centralManager.stopScan()

        // Copy the peripheral instance
        self.peripheral = peripheral
        self.peripheral.delegate = self

        // Connect!
        self.centralManager.connect(self.peripheral, options: nil)

    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to your Particle Board")
            peripheral.discoverServices([ParticlePeripheral.particleBoatServiceUUID])
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == ParticlePeripheral.particleBoatServiceUUID {
                    print("LED service found")
                    //Now kick off discovery of characteristics
                    peripheral.discoverCharacteristics([ParticlePeripheral.forwardCharacteristicUUID,
                                                             ParticlePeripheral.leftCharacteristicUUID,
                                                             ParticlePeripheral.rightCharacteristicUUID, ParticlePeripheral.onOffSwitchCharacteristicUUID], for: service)
                    return
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == ParticlePeripheral.forwardCharacteristicUUID {
                    print("Available");
                    forwardChar = characteristic
//                    redSlider.isEnabled = true
                } else if characteristic.uuid == ParticlePeripheral.leftCharacteristicUUID {
                    print("Available");
                    leftChar = characteristic
                    
                } else if characteristic.uuid == ParticlePeripheral.rightCharacteristicUUID {
                    print("Available");
                    rightChar = characteristic
                    
                }else if characteristic.uuid == ParticlePeripheral.onOffSwitchCharacteristicUUID {
                    print("Available");
                    onOffChar = characteristic
                }
            }
        }
    }
    
    private func writeCharToBluetooth( withCharacteristic characteristic: CBCharacteristic, withValue value: Data) {
        // Check if it has the write property
        if characteristic.properties.contains(.writeWithoutResponse) && peripheral != nil {

            peripheral.writeValue(value, for: characteristic, type: .withoutResponse)

        }
    }
    
    @IBAction func forwardButtonPress(_ sender: Any) {
        print("Forward")
        writeCharToBluetooth(withCharacteristic: forwardChar!, withValue: "fo".data(using: .ascii)!)
    }
    
    @IBAction func leftButtonPress(_ sender: Any) {
        print("left")
        writeCharToBluetooth(withCharacteristic: leftChar!, withValue: "le".data(using: .ascii)!)
    }
    
    @IBAction func rightButtonPress(_ sender: Any) {
        print("right")
        writeCharToBluetooth(withCharacteristic: rightChar!, withValue: "ri".data(using: .ascii)!)
    }
    
    @IBAction func onOffChange(_ sender: Any) {
        if onOffSwitch.isOn{
            print("on")
            writeCharToBluetooth(withCharacteristic: onOffChar!, withValue: "7".data(using: .ascii)!)
        }else {
            print("off")
            writeCharToBluetooth(withCharacteristic: onOffChar!, withValue: "3".data(using: .ascii)!)
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral == self.peripheral {
        print("Disconnected")

//        redSlider.isEnabled = false

        
         print("Central scanning for", ParticlePeripheral.particleBoatServiceUUID);
                       centralManager.scanForPeripherals(withServices: [ParticlePeripheral.particleBoatServiceUUID],
                                                         options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
}

