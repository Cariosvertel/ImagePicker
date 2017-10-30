import UIKit
import Photos

open class ImageStack {

  public struct Notifications {
    public static let imageDidPush = "imageDidPush"
    public static let imageDidDrop = "imageDidDrop"
    public static let stackDidReload = "stackDidReload"
  }

  open var assets = [PHAsset]()
  fileprivate let imageKey = "image"

  open func pushAsset(_ asset: PHAsset) {
    assets.append(asset)
    NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.imageDidPush), object: self, userInfo: [imageKey: asset])
  }

  open func dropAsset(_ asset: PHAsset) {
    if let local = asset as? LocalDirAsset {
      assets = assets.filter({ (assetInArray) -> Bool in
        if let localInArray = assetInArray as? LocalDirAsset{
          return localInArray.imageIdentifier != local.imageIdentifier
        }
        return true
      })
    }else{
      assets = assets.filter {$0 != asset}
    }
    NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.imageDidDrop), object: self, userInfo: [imageKey: asset])
  }

  open func resetAssets(_ assetsArray: [PHAsset]) {
    assets = assetsArray
    NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.stackDidReload), object: self, userInfo: nil)
  }

  open func containsAsset(_ asset: PHAsset) -> Bool {
    let filtered = assets.filter(){
      if $0 is LocalDirAsset{
        
        let localFirst = $0 as! LocalDirAsset
        
        if asset is LocalDirAsset{
          let valid = asset as! LocalDirAsset
          
          return localFirst.imageIdentifier == valid.imageIdentifier
        }else {
          return false
        }
      }else{
        if asset is LocalDirAsset{
          return false
        }else{
          return $0 == asset
        }
      }
    }
    return filtered.count > 0
  }
}
