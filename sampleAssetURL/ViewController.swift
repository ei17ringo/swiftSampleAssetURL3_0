//
//  ViewController.swift
//  sampleAssetURL
//
//  Created by Eriko Ichinohe on 2016/06/08.
//  Copyright © 2016年 Eriko Ichinohe. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices


class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var displayImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func save(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {    //追記
            //写真ライブラリ(カメラロール)表示用のViewControllerを宣言
            let controller = UIImagePickerController()
            
            controller.delegate = self
            //新しく宣言したViewControllerでカメラとカメラロールのどちらを表示するかを指定
            controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //トリミング
            controller.allowsEditing = true
            //新たに追加したカメラロール表示ViewControllerをpresentViewControllerにする
            self.present(controller, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func saveMovie(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.allowsEditing = false
            picker.delegate = self
            picker.videoQuality = UIImagePickerControllerQualityType.typeHigh
            
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func display(_ sender: UIButton) {
        
        //UserDefaultから取り出す
        // ユーザーデフォルトを用意する
        let myDefault = UserDefaults.standard
        
        // データを取り出す
        let strURL = myDefault.string(forKey: "selectedPhotoURL")

        if strURL != nil{
            
            let url = URL(string: strURL as String!)
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
            let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
            let manager: PHImageManager = PHImageManager()
            manager.requestImage(for: asset,targetSize: CGSize(width: 5, height: 500),contentMode: .aspectFill,options: nil) { (image, info) -> Void in
                self.displayImageView.image = image
            }
        
        }
    }
    
    
    //カメラロールで写真を選んだ後
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        

        let assetURL:AnyObject = info[UIImagePickerControllerReferenceURL]! as AnyObject
        
        let strURL:String = assetURL.description
        
        print(strURL)
        
        
        // ユーザーデフォルトを用意する
        let myDefault = UserDefaults.standard
        
        // データを書き込んで
        myDefault.set(strURL, forKey: "selectedPhotoURL")

        // 即反映させる
        myDefault.synchronize()
        
        
        
        //閉じる処理
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

