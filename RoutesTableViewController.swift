//
//  RootsTableViewController.swift
//  Riding
//
//  Created by MntDis on 15/11/2019.
//  Copyright © 2019 MntDis. All rights reserved.
//

import UIKit

class RoutesTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    var routes = [Route]()
    @IBOutlet weak var searchBar: UISearchBar!
    
    private func loadSampleRoutes() {
        
        let rockI = UIImage(named: "rock.jpg")
        let bolzanoI = UIImage(named: "bolzano.jpg")
        let marmoladaI = UIImage(named: "marmolada.jpg")
        let escapeI = UIImage(named: "escape.jpg")
        
        let rock = Route(name: "Via Ferrata Zandonella", image: rockI!, lat: "24.1430", lon: "10.6637", bottomBeacon: "The Rock - Start", topBeacon: "The Rock - End", equipments: [
            /*Equipment(name: "Salewa Climbing Rope 20m", image: UIImage(named: "rope.jpg")!, link: URL(string:                            "https://www.google.com")!),
            Equipment(name: "Cramons (Salewa Alpinist Aly Combi)", image: UIImage(named: "cramons.jpg")!, link: URL(string: "https://www.google.com")!),*/
            Equipment(name: "Vayu 2.0", image: UIImage(named: "helmet.jpg")!, link: URL(string: "https://www.google.com")!),
            Equipment(name: "Salewa Ortles PRL", image: UIImage(named: "gloves.jpg")!, link: URL(string: "https://www.google.com")!)
        ])
        let bolzano = Route(name: "The great Escape", image: bolzanoI!, lat: "38.5692", lon: "10.4728", bottomBeacon: "Bolzano - Start", topBeacon: "Bolzano - End", equipments: [
            Equipment(name: "Wildfire Edge", image: UIImage(named: "shoes.jpg")!, link: URL(string:                            "https://www.google.com")!),
            Equipment(name: "Salewa Agner Hybrid", image: UIImage(named: "jacket.jpg")!, link: URL(string:                            "https://www.google.com")!),
            /*Equipment(name: "Climbing Rope 20m", image: UIImage(named: "rope.jpg")!, link: URL(string:                            "https://www.google.com")!),
            Equipment(name: "Cramons (Salewa Alpinist Aly Combi)", image: UIImage(named: "cramons.jpg")!, link: URL(string: "https://www.google.com")!)*/
        ])
        let marmolada = Route(name: "Cima piccola", image: marmoladaI!, lat: "24.1130", lon: "10.5767", bottomBeacon: "Marmolada - Start", topBeacon: "Marmolada - End", equipments:
            [Equipment(name: "Salewa CLimbing Rope 20m (Double 7.9mm)", image: UIImage(named: "rope.jpg")!, link: URL(string: "https://www.google.com")!)])
        let escape = Route(name: "Col die Specie", image: escapeI!, lat: "24.8910", lon: "10.6257", bottomBeacon: "Escape - Start", topBeacon: "Escape - End", equipments:
            [Equipment(name: "Salewa Climbing Rope 20m", image: UIImage(named: "rope.jpg")!, link: URL(string: "https://www.google.com")!)])
        
        routes = [rock, bolzano, marmolada, escape] //+=
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.isUserInteractionEnabled = false
        
        self.navigationController?.delegate = self
        let logo = UIImage(named: "textedLogo.png")
        let imageView = UIImageView(image:logo)
        
        let bannerWidth = navigationController!.navigationBar.frame.size.width
        let bannerHeight = navigationController!.navigationBar.frame.size.height

        let bannerX = bannerWidth / 2 - (logo!.size.width) / 2
        let bannerY = (bannerHeight / 2 - (logo!.size.height) / 2)-10

        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        self.navigationItem.titleView = imageView
        
        loadSampleRoutes()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return routes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "route", for: indexPath) as! RouteTableViewCell

        cell.title.text = routes[indexPath.row].name
        
        cell.imageO.image = routes[indexPath.row].image
        cell.imageO.contentMode = .scaleAspectFill

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "route" {
            guard let routeDetailViewController = segue.destination as? RouteTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedRouteCell = sender as? RouteTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedRouteCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
                          
             let selectedRoute = routes[indexPath.row]
            routeDetailViewController.route = selectedRoute
        }
        
    }

}
