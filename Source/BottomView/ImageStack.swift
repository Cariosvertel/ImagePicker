import UIKit
import Photos

public class ImageStack {

  public struct Notifications {
    public static let imageDidPush = "imageDidPush"
    public static let imageDidDrop = "imageDidDrop"
    public static let stackDidReload = "stackDidReload"
  }

  public var assets = [PHAsset]()
  private let imageKey = "image"

  public func pushAsset(asset: PHAsset) {
    assets.append(asset)
    NSNotificationCenter.defaultCenter().postNotificationName(Notifications.imageDidPush, object: self, userInfo: [imageKey: asset])
  }

  public func dropAsset(asset: PHAsset) {
    assets = assets.filter() {
      
      if $0 is LocalDirAsset{
        let localFirst = $0 as! LocalDirAsset
        if !(asset is LocalDirAsset){
          return false
        }else {
          let local = asset as! LocalDirAsset
          return localFirst.imageIdentifier == local.imageIdentifier
        }
      }else{
        if asset is LocalDirAsset{
          return false
        }else{
          return $0 == asset
        }
      }
    }
    NSNotificationCenter.defaultCenter().postNotificationName(Notifications.imageDidDrop, object: self, userInfo: [imageKey: asset])
  }

  public func resetAssets(assetsArray: [PHAsset]) {
    assets = assetsArray
    NSNotificationCenter.defaultCenter().postNotificationName(Notifications.stackDidReload, object: self, userInfo: nil)
  }

  public func containsAsset(asset: PHAsset) -> Bool {
    
    let filtered = assets.filter(){
      if $0 is LocalDirAsset{
        let localFirst = $0 as! LocalDirAsset
        if !(asset is LocalDirAsset){
          return false
        }else {
          let local = asset as! LocalDirAsset
          return localFirst.imageIdentifier == local.imageIdentifier
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
