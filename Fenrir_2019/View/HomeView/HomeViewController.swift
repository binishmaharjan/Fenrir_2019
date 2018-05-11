//
//  HomeViewController.swift
//  Fenrir_2019
//
//  Created by guest on 2018/05/01.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton_Designable!
    
    @IBOutlet weak var nosmokingButton: UIButton!
    @IBOutlet weak var wifiButton: UIButton!
    @IBOutlet weak var parkingButton: UIButton!
    @IBOutlet weak var takeoutButton: UIButton!
    @IBOutlet weak var rangeButton: UIButton!
    
    
    //MARK: Variables
    //GeoLocation
    let locationManager = CLLocationManager()
    var geoInfo: [String : String] = [String : String]()
    
    //Api ID and Format
    let keyId = "490c11803fe8d76234bf418bbb78f1a2"
    let format = "json"
    
    //Loading Spinner
    var  activitySpinner: UIView = UIView()
    
    //Restaurants
    var listOfRestaurant : [AnyObject]?
    var latitude : Double?
    var longitude : Double?
    
    //Flags
    let hit_per_page = 100;
    var noSmokingFlag = 0;
    var wifiFlag = 0;
    var parkingFlag = 0;
    var takeoutFlag = 0;
    var deliveryFlag = 0;
    var range = 2;
    
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customizing Search View
        customizeSearchView()
        
        //Adding listener in the search button
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        
        //Showing the activity indicator searching location screen
        activitySpinner = UIViewController.displaySpinner(onView: self.view,title : "現在地検索")
        
        //Core Location Delegate
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        //Tableview delegate and datasource
        listOfRestaurant = [AnyObject]()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        //Adding action to the checked buttons
        wifiButton.addTarget(self, action: #selector(checkedBoxPressed(_:)), for: .touchUpInside)
        parkingButton.addTarget(self, action: #selector(checkedBoxPressed(_:)), for: .touchUpInside)
        takeoutButton.addTarget(self, action: #selector(checkedBoxPressed(_:)), for: .touchUpInside)
        rangeButton.addTarget(self, action: #selector(checkedBoxPressed(_:)), for: .touchUpInside)
        nosmokingButton.addTarget(self, action: #selector(checkedBoxPressed(_:)), for: .touchUpInside)
        
       
   
    }
    
    //MARK: CheckBox Options
    @objc func checkedBoxPressed(_ sender : UIButton){
        if sender.isSelected{
            sender.isSelected = false
            //Changing the condition
            switch sender.tag{
                case 0 :
                    noSmokingFlag = 0
                case 1 :
                    wifiFlag = 0
                case 2 :
                    parkingFlag = 0
                case 3 :
                    takeoutFlag = 0
                case 4 :
                    sender.setTitle("500m", for: .normal)
                    range = 2
                default: break
            }
        }else{
            sender.isSelected = true
            //Changing the condition
            switch sender.tag{
                case 0 :
                    noSmokingFlag = 1
                case 1 :
                    wifiFlag = 1
                case 2 :
                    parkingFlag = 1
                case 3 :
                    takeoutFlag = 1
                case 4 :
                     sender.setTitle("300m", for: .selected)
                     range = 1
                default: break
            }
        }
    }
    

    //MARK: Alert Box
    //function to display the alert message with the message as parameter
    func displayAlert(message : String){
        let alert : UIAlertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Refresh Button
    //function to refresh the current location
    @IBAction func refreshButtonPressed(_ sender: Any) {
        //Request for the new location
        locationManager.requestLocation()
        //Starting the indicator
        activitySpinner = UIViewController.displaySpinner(onView: self.view,title : "現在地検索")
        
        //Reloading the table data
        listOfRestaurant?.removeAll()
        tableView.reloadData()
    }
}


//MARK: Search View
extension HomeViewController{
    func customizeSearchView(){
        self.searchView.backgroundColor = Colors.color_1
        self.searchView.layer.borderColor = Colors.color_1.cgColor
    }
}

//MARK: Result View
extension HomeViewController{
    
    func searchRequest(latitude : Double , longitude : Double){
        //url component
        var urlComponent : URLComponents = URLComponents(string: "https://api.gnavi.co.jp/RestSearchAPI/20150630/")!
        //adding query
        urlComponent.query = "keyid=\(keyId)&format=\(format)&latitude=\(latitude)&longitude=\(longitude)&no_smoking=\(noSmokingFlag)&wifi=\(wifiFlag)&parking=\(parkingFlag)&takeout=\(takeoutFlag)&deliverly=\(deliveryFlag)&hit_per_page=\(hit_per_page)&range=\(range)"
        
        //Getting the url from urlCompnent
        guard let url = urlComponent.url else {
            return
        }
      
        print(url)
        
        //Starting the data Session
        let defautSession : URLSession = URLSession(configuration: .default)
        var dataTask : URLSessionDataTask
        
        //Setting the session
        dataTask = defautSession.dataTask(with: url, completionHandler: { (data, response, error) in
            if error == nil{
                //Starting the search in main queue
                DispatchQueue.main.async {
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        
                        //Safely taking all the downlaod restaurant from the json
                        guard let rest = json["rest"] as? [AnyObject] else{
                            return
                        }
                        
                        //Saving the list of restaurant globally
                        self.listOfRestaurant = rest
                        
                    }catch{
                        print("Error Catch Block : \(error)")
                    }
                }
                
                //Remove the spinner after data is downloaded
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    //Removing the indicator for searching the location screen
                    UIViewController.removeSpinner(spinner: self.activitySpinner)
                    //Reloading the tableview
                    self.tableView.reloadData()
                })
                
            }else{//Error was not nil
                print("Error 1")
                print(error!)
            }
        })
        
        //Starting the task
        dataTask.resume()

    }
    
    @objc func searchButtonPressed(){
        guard let latitude = self.latitude else {
            displayAlert(message: "エーラが発生しました。")
            return
        }
        guard let longitude = self.longitude else {
            return
        }
        searchRequest(latitude: latitude, longitude: longitude)
        
        //Starting the activity indicator loading screen
        self.activitySpinner = UIViewController.displaySpinner(onView: self.view, title: "検索中")

    }
 
    
}

//MARK: Tableview Delegate and data source
extension HomeViewController : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (listOfRestaurant?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? RestaurantCell
        if let restaurants = listOfRestaurant as? [[String : AnyObject]]{
            if let restaurant = restaurants[indexPath.row] as? [String : AnyObject]{
                
                if let name = restaurant["name"] as? String{
                    cell?.titleLabel.text = name
                }
                
                if let access = restaurant["access"]{
                    if let line = access["line"], let station = access["station"], let station_exit = access["station_exit"], let walk = access["walk"]{
                        cell?.accessLabel.text = "\(line!)\(station!)\(station_exit!)\(walk!)"
                    }
                }
                
                if let access = restaurant["access"]{
                    if let line = access["line"] as? String, let station = access["station"] as? String{
                        cell?.accessLabel.text = "\(line)\(station)"
                    }else{
                        cell?.accessLabel.text = "情報見つかりません"
                    }
                    
                    if  let station_exit = access["station_exit"] as? String, let walk = access["walk"] as? String{
                        cell?.accessLabel.text?.append("\(station_exit)\(walk)分")
                    }else{
                        cell?.accessLabel.text?.append("")
                    }
                }
                
                if let category = restaurant["category"] as? String{
                    cell?.openTimeLabel.text = category
                }
                
                if let image_url = restaurant["image_url"]{
                    if let shop_image1 = image_url["shop_image1"] as? String{
                        if let shop_image1_url = URL(string: shop_image1){
                            if let shop_image1_data = NSData(contentsOf: shop_image1_url){
                                cell?.thumbnail.image = UIImage(data: shop_image1_data as Data)
                            }
                        }
                    }else{
                        cell?.thumbnail.image = UIImage(named: "not found")
                    }
                }
                
              
                
                if let tel = restaurant["tel"] as? String{
                    cell?.phoneLabel.text  = "電話番号：\(tel)"
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailStoryBoard = UIStoryboard(name: "DetailView", bundle: nil)
        let detailViewController = detailStoryBoard.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        detailViewController?.navigationItem.title = "詳細"
        detailViewController?.restaurant = (self.listOfRestaurant?[indexPath.row] as? [String : AnyObject])!
        navigationController?.pushViewController(detailViewController!, animated: true)
    }
}


//MARK: Get Geo Location
extension HomeViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var location : String?
        
        //Reverse Geo Coding
        CLGeocoder().reverseGeocodeLocation(locations[0]) { (placemarks, error) in
                DispatchQueue.main.async {
                    guard let placemark = placemarks?[0], error == nil else {
                        return
                    }
                    
                    //Getting all the required information
                    guard let state = placemark.administrativeArea else{return}
                    guard let city = placemark.locality else{return}
                    guard let address1 = placemark.thoroughfare else{return}
                    guard let address2 = placemark.subThoroughfare else{return}
                    
                    //Making the current location string
                    location = "\(state)\(city)\(address1)\(address2)"
                    
                    //Saving latitude and longitude in global variable
                    self.latitude = locations[0].coordinate.latitude
                    self.longitude = locations[0].coordinate.longitude
                }
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    //Removing the indicator for searching the location screen
                    UIViewController.removeSpinner(spinner: self.activitySpinner)
                    //Filling the label with the current location
                    if error != nil{
                        //Displaying the error
                        self.displayAlert(message: "現在位置取得に失敗しました。")
                    }
                    if let address = location {
                        self.addressLabel.text = address
                    }
                })
            }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error)
    }
    
}

