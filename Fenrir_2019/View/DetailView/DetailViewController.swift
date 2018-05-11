//
//  DetailViewController.swift
//  Fenrir_2019
//
//  Created by guest on 2018/05/05.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var access1Label: UILabel!
    @IBOutlet weak var access2Label: UILabel!
    @IBOutlet weak var opentimeLabel: UILabel!
    @IBOutlet weak var detailMapView: MKMapView!
    
    //MARK: Variables
    var restaurant : [String : AnyObject] = [String : AnyObject]()
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        //print(restaurant)
        getName()
        getAddress()
        getTel()
        getAccess()
        getOpenTime()
        getImage()
        setMapView()
       
       
    }
    
    //function to get address
    func getAddress(){
        if let address = restaurant["address"] as? String{
            let add = address.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: false)
            zipCodeLabel.text = String(add[0])
            addressLabel.text = String(add[1])
        }
    }
    
    //function to get phone number
    func getTel(){
        if let tel = restaurant["tel"] as? String{
            telLabel.text = tel
        }
    }
    
    //func to get access
    func getAccess(){
        if let access = restaurant["access"]{
            if let line = access["line"] as? String, let station = access["station"] as? String{
                access1Label.text = "\(line)\(station)"
            }else{
                access1Label.text = "情報見つかりません"
            }
            
            if  let station_exit = access["station_exit"] as? String, let walk = access["walk"] as? String{
                access2Label.text = "\(station_exit)\(walk)分"
            }else{
                access2Label.text = "情報見つかりません"
            }
        }
    }
    
    //function to get open time
    func getOpenTime(){
        if let opentime = restaurant["opentime"] as? String {
            opentimeLabel.text = opentime.replacingOccurrences(of: "<BR>", with: "\n")
        }else{
            opentimeLabel.text = "情報見つかりません"
        }
    }
    
    //function to get the title
    func getName(){
        if let name = restaurant["name"] as? String{
            nameLabel.text = name
        }
    }
    
    //function to get image
    func getImage(){
        //Customizing the layer
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = Colors.color_4.cgColor
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        
        //Getting the image
        if let image_url = restaurant["image_url"]{
            if let shop_image1 = image_url["shop_image1"] as? String{
                if let shop_image1_url = URL(string: shop_image1){
                    if let shop_image1_data = NSData(contentsOf: shop_image1_url){
                       imageView.image = UIImage(data: shop_image1_data as Data)
                    }
                }
            }
        }
    }
    
    //function to set the initial place at the map view
    func setMapView(){
        if let latitude = restaurant["latitude"] as? String, let longitude = restaurant["longitude"] as? String{
            //Customizing the map view
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let coordinate = CLLocationCoordinate2DMake(Double(latitude)!, Double(longitude)!)
            let region = MKCoordinateRegion(center:coordinate, span: span)
            detailMapView.setRegion(region, animated: true)
            
            //Set the coordinates
            let objAnn = MKPointAnnotation()
            objAnn.coordinate = coordinate
            objAnn.title = nameLabel.text
            objAnn.subtitle = addressLabel.text
            self.detailMapView.addAnnotation(objAnn)
        }
    }
    
    
    @IBAction func directionButtonPressed(_ sender: Any) {
        //Open Map to show direction
        if let latitude = restaurant["latitude"] as? String, let longitude = restaurant["longitude"] as? String{
            let url = URL(string: "http://maps.apple.com/maps?daddr=\(Double(latitude)!),\(Double(longitude)!)")!
            if #available(iOS 10.0, *) {
                //For iOS Greater than 10.0
                UIApplication.shared.open(url)
            } else {
                //For ios Lower than 10.0
                UIApplication.shared.openURL(url)
            }
        }
    }
    


}
