//
//  QRScannerController.swift
//  QRCodeReader
//
//  Created by Simon Ng on 13/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerController: UIViewController {

    @IBOutlet var messageLabel:UILabel!
    @IBOutlet var topbar: UIView!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //获取AVCaptureDevice对象，用于初始化铺货视频的硬件设备，并配置硬件属性
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do{
            //通过之前获得的硬件设备，获得AVCaptureDeviceInput 对象
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            //初始化captureSession对象
            captureSession = AVCaptureSession()
            
            //给session 添加输入设备
            captureSession?.addInput(input)
            
            //初始化AVCaptureMetadataOutput 对象，并将它作为输出
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            //设置delegate并使用默认的dispatch 队列来执行回调
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeUPCECode,
                AVMetadataObjectTypeCode39Code,
            AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypePDF417Code]
            
            
            //初始化视频预览layer ，并将其作为viewPreview 的 sublayer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            //开始视频捕获
            captureSession?.startRunning()
            
            //初始化二维码选择框并高亮边框
            qrCodeFrameView = UIView()
            if let qrCodeFrameView = qrCodeFrameView{
                
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
                
            }
            
            //信息 label 和顶部栏
            view.bringSubview(toFront: messageLabel)
            view.bringSubview(toFront: topbar)
            
        }catch{
            //如果出现任何错误，仅做输出处理，并返回
            print(error)
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
extension QRScannerController:AVCaptureMetadataOutputObjectsDelegate{
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        //检查：metadataObjects 对象不为空，并且至少包含一个元素
        if metadataObjects == nil || metadataObjects.count == 0{
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        //获取元数据对象
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObjectTypeQRCode{
            //如果元数据是二维码，则更新二维码选择框大小与label 的文本
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = (barCodeObject?.bounds)!
            
            if metadataObj.stringValue != nil{
                messageLabel.text = metadataObj.stringValue
            }
        }
    }
}
