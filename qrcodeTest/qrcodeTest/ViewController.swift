//
//  ViewController.swift
//  qrcodeTest
//
//  Created by 茆明辉 on 15/10/13.
//  Copyright (c) 2015年 com.nyist. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var localTime: UILabel!
    @IBOutlet weak var localTemp: UILabel!
    @IBOutlet weak var localWeather: UILabel!
    @IBOutlet weak var localLocation: UILabel!
    @IBOutlet var imageViewQR: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "http://api.k780.com:88/?app=qr.get&data=test&level=L&size=6")!
        
        let request = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) { (_, data, e) -> Void in
            println(data)
            if e == nil{
                //优化UI速度，加入主线程
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.imageViewQR.image = UIImage(data: data)

                })
            }
        }
        
        NSURLConnection.sendAsynchronousRequest( NSURLRequest(URL: NSURL(string: "http://api.k780.com:88/?app=weather.today&weaid=1&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json")!), queue: NSOperationQueue()){ (_, data, e) -> Void in
            if e == nil{
                //查阅发现可选的需要强制转换
                if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary{
                    let result = json.valueForKey("result") as! NSDictionary
                    
                    //加入主线程优化UI显示速度
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.localLocation.text = result["citynm"] as? String
                        self.localWeather.text = result["weather"] as? String
                        self.localTemp.text = result["temperature"] as? String

                    })
                    
                    
                }
                
            }
        }
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: NSURL(string: "http://api.k780.com:88/?app=life.time&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json")!), queue: NSOperationQueue()) { (_, data, e) -> Void in
            if e == nil{
                if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as?
                    NSDictionary{
                        let result = json.valueForKey("result") as! NSDictionary
                        self.localTime.text = result["datetime_2"] as? String
                }
            }
        }
        
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

