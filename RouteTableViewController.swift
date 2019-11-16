//
//  RouteTableViewController.swift
//  MntDis
//
//  Created by MntDis on 15/11/2019.
//  Copyright © 2019 MntDis. All rights reserved.
//

import UIKit
import EstimoteBluetoothScanning
import EstimoteProximitySDK

class RouteTableViewController: UITableViewController, ESTBeaconManagerDelegate, EBSUniversalScannerDelegate {

    @IBOutlet weak var imageViewO: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var coordinates: UILabel!
    
    @IBOutlet weak var beaconStatus: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var beaconPosition: UILabel!
    @IBOutlet weak var beaconDash: UILabel!
    @IBOutlet weak var beaconDistance: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var difficulty: UILabel!
    @IBOutlet weak var visitors: UILabel!
    @IBOutlet weak var durancy: UILabel!
    
    @IBOutlet weak var suggestedEquipment: UILabel! // Unused?
    
    @IBOutlet weak var equipmentsTable: UITableView!
    
    var route: Route?
    
    struct Content {
        let title: String
        let subtitle: String
    }
    var proximityObserver: ProximityObserver!
    var nearbyContent = [Content]()
    
    let universalScanner = EBSUniversalScanner()
    
    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "ranged region")
    
    let viaFerrataKey = [
        "60514:7116": [
            "A": 50,
            "B": 150,
            "C": 325
        ]
    ]
    
    let escapeKey = [
        "7780:12603": [
            "A": 50
        ]
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        self.beaconManager.startRangingBeacons(in: self.beaconRegion)
        print("BeaconsRanging Started")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.beaconManager.stopRangingBeacons(in: self.beaconRegion)
        print("BeaconsRanging Ended")
    }
    
    func placesNearBeacon(_ beacon: CLBeacon) -> [String]? {
        let beaconKey = "\(beacon.major):\(beacon.minor)"
        if route != nil {
            if route?.name == "Via Ferrata Zandonella" {
                if let places = self.viaFerrataKey[beaconKey] {
                    let sortedPlaces = Array(places).sorted { $0.1 < $1.1 }.map { $0.0 }
                    return sortedPlaces
                }
            } else if route!.name == "The great Escape" {
                if let places = self.escapeKey[beaconKey] {
                    let sortedPlaces = Array(places).sorted { $0.1 < $1.1 }.map { $0.0 }
                    return sortedPlaces
                }
            }
        }
        return nil
    }
    
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let nearestBeacon = beacons.first,
           let places = placesNearBeacon(nearestBeacon) {
            // TODO: update the UI here
            switch nearestBeacon.proximity {
            case .near:
                print("Near", nearestBeacon.rssi)
                if !(beaconPosition.text?.contains("Near"))! {
                    beaconPosition.text? = "Near"
                }
                if beaconStatus.textColor != UIColor.systemGreen {
                    updateBeaconLabel()
                }
                break
            case .immediate:
                if !(beaconPosition.text?.contains("Immediate"))! {
                    beaconPosition.text? = "Immediate"
                }
                if beaconStatus.textColor != UIColor.systemGreen {
                    updateBeaconLabel()
                }
                break
            case .far:
                if !(beaconPosition.text?.contains("Far"))! {
                    beaconPosition.text? = "Far"
                }
                if beaconStatus.textColor != UIColor.systemGreen {
                    updateBeaconLabel()
                }
                break
            default:
                if beaconStatus.textColor != UIColor.label {
                    updateBeaconLabel()
                }
            }
            
            let percentage = -((nearestBeacon.rssi - -100)*100) / (-100 - -25)
            beaconDistance.text = percentage.description + "%"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //equipmentsTable.delegate = self
        tableView.allowsSelection = false
        activityIndicator.startAnimating()
            
        if route != nil {
            imageViewO.image = route?.image
            imageViewO.contentMode = .scaleAspectFill
            name.text = route?.name
            coordinates.text = "Latitude: \(route?.lat ?? "calculating") - Longitude: \(route?.lon ?? "calculating")"
            // Rotate arrow
        }
        
        universalScanner.delegate = self
        universalScanner.startScanForDevicesRepresented(byClasses: [EBSScanInfoEstimoteTelemetryA.self, EBSScanInfoEstimoteTelemetryB.self])
        
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
        
        let estimoteCloudCredentials = CloudCredentials(appID: "lol-5o4", appToken: "aa163db7df0353d1f11b28c80500f23a")

        proximityObserver = ProximityObserver(credentials: estimoteCloudCredentials, onError: { error in
            print("ProximityObserver error: \(error)")
        })

        let zone = ProximityZone(tag: "lol-5o4", range: ProximityRange.near)
        zone.onContextChange = { contexts in
            self.nearbyContent = contexts.map {
                self.difficulty.text = "Difficulty: " + $0.attachments["difficulty_list"]!
                self.visitors.text = "Visitors: " + $0.attachments["visitors"]!
                self.durancy.text = "Durancy: " + $0.attachments["time"]!
                return Content(title: $0.attachments["lol-5o4/title"]!, subtitle: $0.deviceIdentifier)
            }
        }

        proximityObserver.startObserving([zone])
        
    }
    
    func universalScanner(_ universalScanner: EBSUniversalScannerProtocol, didScanEstimoteDevice scanInfo: EBSScanInfo) {
        if let scanInfo = scanInfo as? EBSScanInfoEstimoteTelemetryB {
            if Int(scanInfo.temperatureInCelsius) > 18 && Int(scanInfo.temperatureInCelsius) < 22 {
                temperature.text = "Temperature: \(scanInfo.temperatureInCelsius)°C"
            }
        }
    }
    
    func universalScanner(_ universalScanner: EBSUniversalScannerProtocol, didFailToScanWithError error: Error) {
        NSLog("scanner error: \(error)")
    }
    
    func updateBeaconLabel() {
        if beaconStatus.textColor == UIColor.systemGreen {
            beaconStatus.textColor = UIColor.label
            beaconStatus.text = "Searching for beacon .."
            activityIndicator.startAnimating()
        } else {
            beaconStatus.textColor = UIColor.systemGreen
            beaconStatus.text = "Beacon detected!"
            activityIndicator.stopAnimating()
        }
        activityIndicator.isHidden = !activityIndicator.isHidden
        print(checkMark.isHidden)
        checkMark.isHidden = !checkMark.isHidden
        print(checkMark.isHidden)
        beaconPosition.isHidden = !beaconPosition.isHidden
        beaconDistance.isHidden = !beaconDistance.isHidden
        beaconDash.isHidden = !beaconDash.isHidden
        temperature.isHidden = !temperature.isHidden
        difficulty.isHidden = !difficulty.isHidden
        visitors.isHidden = !visitors.isHidden
        durancy.isHidden = !durancy.isHidden
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView == self.tableView {
            // #warning Incomplete implementation, return the number of sections
            return 3
        } else {
            return (route?.equipments.count)!
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView != self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "equipment", for: indexPath) as! EquipmentTableViewCell
            cell.imageViewO.image = route?.equipments[indexPath.row].image
            cell.label.text = route?.equipments[indexPath.row].name
        }

        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == equipmentsTable {
            return 80.0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
