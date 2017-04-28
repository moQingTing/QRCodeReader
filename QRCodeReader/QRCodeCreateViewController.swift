//
//  QRCodeCreateViewController.swift
//  QRCodeReader
//
//  Created by mqt on 2017/4/28.
//  Copyright © 2017年 AppCoda. All rights reserved.
//

import UIKit
import CoreImage

class QRCodeCreateViewController: UIViewController {
    
    
    @IBOutlet weak var textFCodeInfo: UITextField!
    
    @IBOutlet weak var btnCreateCode: UIButton!
    
    @IBOutlet weak var imgQRCode: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///生成二维码图片
    @IBAction func touchDidCreateBtn(_ sender: Any) {
        if !(self.textFCodeInfo.text?.isEmpty)!{
            let filter = CIFilter(name: "CIQRCodeGenerator")
            
            //恢复默认设置
            filter?.setDefaults()
            
            //设置数据
            let info = self.textFCodeInfo.text!
            let infoData = info.data(using: String.Encoding.utf8)
            filter?.setValue(infoData, forKeyPath: "inputMessage")
            
            //生成二维码
            let outputImage = filter?.outputImage
            self.imgQRCode.image = UIImage(ciImage: outputImage!)
        }
    }


}

extension CIImage{
    func createNonInterpolatedWithSize(size:CGFloat)->UIImage{
        let extent = self.extent.integral
    
        let scale = CGFloat.minimum(size/extent.width, size/extent.height)
        
//        //创建bitmap 
//        let width = self.extent.width * scale
//        let height = self.extent.width * scale
//        
//        let cs = CGColorSpaceCreateDeviceGray()
        
        return UIImage()

    }
}
