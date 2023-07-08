//
//  ViewController.swift
//  Mark
//
//  Created by jyck on 2023/6/25.
//

import UIKit
import GYSide
import LBXPermission
import SVProgressHUD
import Photos

class ViewController: FBVC {
    
    let locationBtn = FBLab()
    let bottomBar = BottomBar()
    
    let camera = CameraManager()
    var videoPreviewView = UIView()
    var preContainter = UIView()
    
    var cardView: CardView = Card7(markstyle: .mark)
    let recordTimeLab = FBLab()
    
    var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavBarWhiteBackBtn("")
        navBar.setLeftButton(image: UIImage(named: "Frame 620"), selected: nil) { [weak self] in
            //            guard let self else { return }
            let vc = Drawer()
            vc.modalPresentationStyle = .overCurrentContext
            self?.gy_showSide({ (config) in
                config.animationType = .translationMask
                config.sideRelative = 0.75
                //                config.timeInterval = 3;
            }, vc)
        }
        
        view.backgroundColor = .black
        
        
        navBar.setRightButton(image: UIImage(named: "Frame 427319812"), selected: UIImage(named: "Frame 427319812")) { [weak self] in
            if !StoreManager.shared.isBuyVip {
                self?.navigationController?.pushViewController(Store())
                return
            }
            self?.onSwitchCamera()
        }
//
//        navBar.setRightButton2(image: UIImage(named: "Frame(1)"), selected: UIImage(named: "Frame")) { [weak self] in
//            self?.onSwitchFlash()
//        }
        
        view.addSubview(preContainter)
        
        
        
        //        view.addSubview(preImageView)
//        view.addSubview(locationBtn)
        view.addSubview(bottomBar)
        bottomBar.frame = CGRect(x: 0, y: view.height - 160 - k_safe_tabbar_bottom, width: view.width, height: 160 + k_safe_tabbar_bottom)
        
        
//        locationBtn.set("定位", font: .medium(12), color: .white, icon: UIImage(named: "Frame 427319814"))
//        locationBtn.fetch(.topImgLab(top: 0, size: 36, spacing: 5, bottom: 0))
//        locationBtn.snp.makeConstraints { make in
//            make.bottom.equalTo(bottomBar.snp.top).offset(-24)
//            make.right.equalTo(-19)
//            make.width.equalTo(36)
//        }
//
//        locationBtn.onTap = {
//            FBShared.shared.start()
//        }
        //FBShared.shared.start()
        FBShared.shared.setup()
        
        bottomBar.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(k_nav_bar_height + 160)
        }
        
        
        preContainter.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            make.bottom.equalTo(bottomBar.snp.top)
        }
        preContainter.addSubview(videoPreviewView)
        videoPreviewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(recordTimeLab)
        recordTimeLab.alpha = 0
        recordTimeLab.fetch(.paddingLab(padding: 12))
        recordTimeLab.set("", font: .semibold(14), color: .white)
        recordTimeLab.set(backgournd: UIColor(0xF65757))
        recordTimeLab.cornerRadius = 4
        recordTimeLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom).offset(17)
            make.height.equalTo(27)
            make.width.greaterThanOrEqualTo(58)
        }
        updateCard()
        
        bottomBar.onChangedCallback = onChangCameraMode
        bottomBar.takeBtn.onTap = onTapTakeAction
        bottomBar.albumBtn.onTap = ontapPhototAction
        bottomBar.markBtn.onTap = { [weak self]  in
            if !StoreManager.shared.isBuyVip {
                self?.navigationController?.pushViewController(Store())
                return
            }
            let vc = CardList()
            vc.onTapDone = { [weak self] style in
                self?.cardView = style.cradView
                self?.updateCard()
            }
            self?.navigationController?.pushViewController(vc)
        }
    }
    
    func updateCard() {
        preContainter.subviews.filter({ $0 is CardView }).forEach {
            $0.removeFromSuperview()
        }
        preContainter.addSubview(cardView)
        cardView.config(FBShared.shared.rows[cardView.style] ?? [])
        cardView.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.bottom.equalTo(-17)
        }
    }
    
    private func onChangCameraMode() {
        if !StoreManager.shared.isBuyVip {
            self.navigationController?.pushViewController(Store())
            return
        }
        DispatchQueue.main.async {
            if self.bottomBar.isRecording {
                self.onSwitchVideo()
            } else {
                self.setupPreview()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LBXPermissionCamera.authorize { [weak self] success, firstTime in
            if success {
                self?.setupCamera()
                self?.setupPreview()
            } else {
                let alertVC = UIAlertController(title: "提示", message:  "没有授权访问相机权限，是否前往设置？", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "去设置", style: .default, handler: { _ in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }))
                alertVC.addAction(UIAlertAction(title: "取消", style: .cancel))
                self?.present(alertVC, animated: true)
            }
        }
    }
    
    
    func setupCamera() {
        camera.shouldEnableExposure = true
        
        camera.writeFilesToPhoneLibrary = false
        
        camera.shouldFlipFrontCameraImage = false
        camera.showAccessPermissionPopupAutomatically = false
    }
    
    
    func setupPreview() {
        self.recordTimeLab.alpha = 0
        let state =  camera.addPreviewLayerToView(videoPreviewView, newCameraOutputMode: CameraOutputMode.stillImage)
        if state == .notDetermined {
            let alertVC = UIAlertController(title: "提示", message:  "没有授权访问相册权限，是否前往设置？", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "去设置", style: .default, handler: { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            alertVC.addAction(UIAlertAction(title: "取消", style: .cancel))
            self.present(alertVC, animated: true)
        } else if state == .noDeviceFound {
            Toast.show("抱歉，未找到相机")
        }
        camera.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_) -> Void in }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func onSwitchCamera() {
        recordTimeLab.alpha = 0
        camera.cameraDevice = camera.cameraDevice == .front ? .back : .front
        self.navBar.rightButton2.isEnabled = camera.hasFlash(for: camera.cameraDevice)
        self.navBar.rightButton2.isSelected = camera.flashMode == .on
    }
    
    func onSwitchFlash() {
        camera.flashMode = camera.flashMode == .off ? .on : .off
    }
    
    
    
    func onSwitchVideo() {
        if !StoreManager.shared.isBuyVip {
            self.navigationController?.pushViewController(Store())
            return
        }
        let state =  camera.addPreviewLayerToView(videoPreviewView, newCameraOutputMode: CameraOutputMode.videoWithMic)
        if state == .notDetermined {
            let alertVC = UIAlertController(title: "提示", message:  "没有授权访问相册权限，是否前往设置？", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "去设置", style: .default, handler: { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            alertVC.addAction(UIAlertAction(title: "取消", style: .cancel))
            self.present(alertVC, animated: true)
        } else if state == .noDeviceFound {
            Toast.show("抱歉，未找到相机")
        }
        camera.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_) -> Void in }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FBTimer.shared.remove(target: self)
        camera.stopCaptureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        camera.resumeCaptureSession()
    }
    
    var duration: Int = 0
    func fetchDuration() {
        let h = self.duration / 3600
        let m = self.duration % 3600 / 60
        let s = self.duration % 60
        let text = h > 0 ? String(format: "%02d:%02d:%02d", h,m,s) : String(format: "%02d:%02d", m,s)
        DispatchQueue.main.async {
            self.recordTimeLab.set(text)
        }
    }
    
    func snaphot() -> UIImage? {
        cardView.stcakView.snaphot()
    }
    
    func onTapTakeAction() {
        if !StoreManager.shared.isBuyVip {
            self.navigationController?.pushViewController(Store())
            return
        }
        if bottomBar.isRecording {
            
            if isRecording {
                isRecording = false
                SVProgressHUD.show()
                guard let markImage = snaphot() else { return }
#if targetEnvironment(simulator)
                let copyTo = NSTemporaryDirectory().appendingPathComponent("tempMovie1688460361.543898.MP4")
                if !FileManager.default.fileExists(atPath: copyTo) {
                    if let url = Bundle.main.path(forResource: "tempMovie1688460361.543898.MP4", ofType: nil) {
                        try? FileManager.default.copyItem(atPath: url, toPath: copyTo)
                        printt("复制视频至:", copyTo)
                    }
                }
                let out = NSTemporaryDirectory().appendingPathComponent(Date().string(withFormat: "HH-mm-ss") + ".mp4")
                addWatermark(inputURL: URL(fileURLWithPath: copyTo), outputURL: URL(fileURLWithPath: out), mark: markImage) { exportSession in
                    if exportSession?.status == .completed {
                        Toast.show("Export complete:\(out)")
                    } else if exportSession?.status == .failed {
                        Toast.show("Export failed - \(String(describing: exportSession?.error))")
                    }
                    SVProgressHUD.dismiss()
                }
                //                export(URL(fileURLWithPath: copyTo), mark: markImage)
                
#else
                camera.stopVideoRecording { [weak self] videoURL, error in
                    print(videoURL)
                    let out = NSTemporaryDirectory().appendingPathComponent(Date().string(withFormat: "HH-mm-ss") + ".mp4")
                    self?.addWatermark(inputURL: videoURL!, outputURL: URL(fileURLWithPath: out), mark: markImage) { exportSession in
                        if exportSession?.status == .completed {
                            Toast.show("Export complete:\(out)")
                            self?.save({
                                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: out))
                            })
                        } else if exportSession?.status == .failed {
                            Toast.show("Export failed - \(String(describing: exportSession?.error))")
                        }
                        SVProgressHUD.dismiss()
                    }
                }
#endif
                self.duration = 0
                self.fetchDuration()
                self.recordTimeLab.alpha = 0
                FBTimer.shared.remove(target: self)
                bottomBar.takeBtn.isSelected = false
            } else {
                bottomBar.takeBtn.isSelected = true
                isRecording = true
                self.duration = 0
                self.fetchDuration()
                FBTimer.shared.registerHandler(target: self, interval: 1.0) { [weak self] in
                    guard let self else { return }
                    self.duration += 1
                    self.fetchDuration()
                }
                recordTimeLab.alpha = 1
                camera.startRecordingVideo()
            }
        } else {
            guard let markImage = snaphot() else { return }
            SVProgressHUD.show()
            
            camera.capturePictureWithCompletion { result in
                switch result {
                case .failure:
                    self.camera.showErrorBlock("Error occurred", "Cannot save picture.")
                    SVProgressHUD.dismiss()
                case .success(let content):
                    if let res = content.asImage?.add(image: markImage, to: .zero) {
                        self.save {
                            PHAssetChangeRequest.creationRequestForAsset(from: res)
                        }
                    } else {
                        Toast.show("出错啦，请稍后再试")
                        SVProgressHUD.dismiss()
                    }
                    //                    print(content)
                    
                    break
                }
            }
        }
    }
    
    func save(_ handler: @escaping FBCallback) {
        PHPhotoLibrary.shared().performChanges( handler, completionHandler: {  success, error in
            if !success { print("error creating asset: \(error)") }
            else {
                print("成功了")
                Toast.show("保存成功")
            }
            SVProgressHUD.dismiss()
        })
    }
    
    
    func ontapPhototAction() {
        if !StoreManager.shared.isBuyVip {
            self.navigationController?.pushViewController(Store())
            return
        }
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    private func export(_ url: URL, mark: UIImage) {
        SVProgressHUD.show()
        //input file
        let asset = AVAsset(url: url)
        
        let endTime = CMTimeMakeWithSeconds(asset.duration.seconds, preferredTimescale: asset.duration.timescale)
        
        let mix = AVMutableComposition()
        //input clip
        let videoTrack = mix.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        try? videoTrack?.insertTimeRange(CMTimeRange(start: .zero, end: endTime), of: asset.tracks(withMediaType: .video).first!, at: .zero)
        
        if asset.tracks(withMediaType: .audio).count > 0 {
            let audioAsset = AVURLAsset(url: url)
            let audioTrack = mix.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            try? audioTrack?.insertTimeRange(CMTimeRange(start: .zero, end: endTime), of: audioAsset.tracks(withMediaType: .audio).first!, at: .zero)
        }
        
        // render layer
        guard let videoSize = videoTrack?.naturalSize else {
            SVProgressHUD.show()
            Toast.show("出错啦")
            return
        }
        //adding the image layer
        let watermarkLayer = CALayer()
        watermarkLayer.contents = mark.cgImage
        watermarkLayer.frame = CGRect(x: 0, y: 0 ,width: mark.size.width, height: mark.size.height)
        watermarkLayer.opacity = 1
        
        let parentlayer = CALayer()
        let videoLayer = CALayer()
        
        parentlayer.frame = CGRect(x: 0, y: 0, width: videoSize.height, height: videoSize.height)
        videoLayer.frame = CGRect(x: 0, y: 0, width: videoSize.height, height: videoSize.height)
        parentlayer.addSublayer(videoLayer)
        parentlayer.addSublayer(watermarkLayer)
        
        
        //make it square
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: videoSize.width, height: videoSize.height) //change it as per your needs.
        videoComposition.frameDuration = asset.duration
        videoComposition.renderScale = 1.0
        
        //Magic line for adding watermark to the video
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayers: [videoLayer], in: parentlayer)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: .zero, end: endTime)
        let layerInstruction = AVMutableVideoCompositionLayerInstruction.init(assetTrack: videoTrack!)
        instruction.layerInstructions = [layerInstruction]// as [AVVideoCompositionLayerInstruction]
        videoComposition.instructions = [instruction] as [AVVideoCompositionInstructionProtocol]
        
        guard let exporter = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetMediumQuality) else {
            SVProgressHUD.show()
            Toast.show("出错啦")
            return
        }
        exporter.outputFileType = .mp4
        exporter.outputURL = NSTemporaryDirectory().url?.appendingPathComponent(Date().string(withFormat: "HH:mm:ss") + ".mp4")
        exporter.videoComposition = videoComposition
        
        exporter.exportAsynchronously {
            if exporter.status == .completed {
                Toast.show("Export complete")
            } else if exporter.status == .failed {
                Toast.show("Export failed - \(String(describing: exporter.error))")
            }
            
            SVProgressHUD.dismiss()
        }
    }
    
    
    
//    var cropFilter: CIFilter?
    func addWatermark(inputURL: URL, outputURL: URL, mark: UIImage,  handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let mixComposition = AVMutableComposition()
        let asset = AVAsset(url: inputURL)
        let videoTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
        let timerange = CMTimeRangeMake(start: .zero, duration: asset.duration)
        
        let compositionVideoTrack:AVMutableCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))!
        
        do {
            try compositionVideoTrack.insertTimeRange(timerange, of: videoTrack, at: .zero)
            compositionVideoTrack.preferredTransform = videoTrack.preferredTransform
        } catch {
            print(error)
        }
        
        
   
         // Create your context and filter
         // I'll use metal context and CIFilter

        
        // Original video size
        let videoSize = videoTrack.naturalSize.applying(videoTrack.preferredTransform)
        
        let cropSize = CGSize(width: self.preContainter.size.width * UIScreen.main.nativeScale, height: self.preContainter.size.height * UIScreen.main.nativeScale)
        let rate = videoSize.width / cropSize.width
        let width = videoSize.width.abs * rate
        let height = videoSize.height.abs * rate
        let targetSize = CGSize(width: videoSize.width.abs, height: floor(videoSize.height.abs * (cropSize.width / cropSize.height)))
//            printt("targetSize",targetSize)

        // Define your crop rect here
        // I would like to crop video from it's center
        let cropRect = CGRect(
            x: 0,
            y: (videoSize.height.abs - targetSize.height) / 2.0 ,
            width: targetSize.width,
            height: targetSize.height
        )
        

//        let context = CIContext(mtlDevice: MTLCreateSystemDefaultDevice(), options: [.workingColorSpace : NSNull()])
        
        printt("裁剪尺寸:\(cropRect) videoSize:\(videoSize)  targetSize:\(targetSize)")
        let watermarkFilter = CIFilter(name: "CISourceOverCompositing")!
        let watermarkImage = CIImage(cgImage: mark.cgImage!)
        
        
//        let cropFilter = CIFilter(name: "CICrop")!
        let videoComposition = AVMutableVideoComposition(asset: asset) { [weak self] (filteringRequest) in
            guard let self else { return }
//            let scaleX = cropSize.width / videoSize.width
//            let scaleY = cropSize.height / videoSize.height
            // Handle video frame (CIImage)
//            let outputImage = filteringRequest.sourceImage
//            // Add the .sourceImage (a CIImage) from the request to the filter.
//            cropFilter.setValue(outputImage, forKey: kCIInputImageKey)
//            // Specify cropping rectangle with converting it to CIVector
//            cropFilter.setValue(CIVector(cgRect: cropRect), forKey: "inputRectangle")
//
//            // Move the cropped image to the origin of the video frame. When you resize the frame (step 4) it will resize from the origin.
//            let imageAtOrigin = cropFilter.outputImage!.transformed(
//                by: CGAffineTransform(translationX: -cropRect.origin.x, y: -cropRect.origin.y)
//            )
//            filteringRequest.
//            request.finish(with: imageAtOrigin, context: self.context)
            
            let source = filteringRequest.sourceImage.clampedToExtent()
            watermarkFilter.setValue(source, forKey: "inputBackgroundImage")
            let transform = CGAffineTransform(translationX: 24, y: 24)
            //            let transform = CGAffineTransform(translationX: filteringRequest.sourceImage.extent.width - watermarkImage.extent.width - 2, y: 0)
            watermarkFilter.setValue(watermarkImage.transformed(by: transform), forKey: "inputImage")
            filteringRequest.finish(with: watermarkFilter.outputImage!, context: nil)
        }
        
        
        
        videoComposition.renderSize = cropRect.size
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPreset640x480) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.videoComposition = videoComposition
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
    
}

extension ViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
