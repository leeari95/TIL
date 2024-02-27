# 240227 PhotoKit, PHPickerViewController, PHPickerConfiguration, PHAssetCollection

# TIL (Today I Learned)

2월 27일 (화)

## 학습 내용

- 사용자 앨범에서 사진만 간단히 가져오는 방법
    - PhotoKit의 PHPickerViewController를 사용하여 사용자 앨범 불러오기
    - 사용자 앨범에서 사진 가져오기

&nbsp;

## 고민한 점 / 해결 방법

### PhotoKit

PhotoKit은 사용자의 기기와 iCloud에 있는 사진에 대한 권한을 제공한다.

![image](https://github.com/leeari95/TIL/assets/75905803/3a13b3b5-ca70-45cf-8ad8-e8daaaac5d12)

#

### PHPickerViewController

![image](https://github.com/leeari95/TIL/assets/75905803/5e028574-faee-4b39-9fab-27b662efc32f)

iOS 14에서 새롭게 추가된 기능이다.

특징은…
* 기존에 느린 이미지 로딩과 복구 UI를 개선하였다.
* 라이브러리 사용 권한 요청 없이 이미지를 가져올 수 있다.
    * 왜냐하면 PHPicker는 Limited Photo library access를 사용하기 때문이다. 즉, 사용자가 접근하도록 선택한 Asset에만 접근 가능하다는 이야기다.
    * 사용자가 접근하도록 선택한 Asset은 사용자가 직접 선택한 이미지나 비디오 파일에만 접근 가능하다는 것으로 정리할 수 있다.
    * 이 과정에서 중요한 점은 PHPickerViewController가 앱에 사용자의 전체 사진 라이브러리에 대한 접근 권한을 주지 않는다는 것이다.
    * 특정 항목들만 앱이 사용할 수 있게 되기 때문에 이 방식은 사용자의 개인 정보 보호를 강화하며 앱이 필요로 하는 최소한의 데이터에만 접근하도록 한다.
* 사용자가 동시에 여러 미디어 항목을 선택할 수 있다.
* 사용자가 허락한 미디어만 사용 가능 및 이미지를 안정적으로 처리한다

#

### PHPickerViewController를 사용하여 간단하게 사용자 사진을 가져오는 방법


> PHPickerConfiguration을 생성하여 각 속성들을 설정해준다.

* https://developer.apple.com/documentation/photokit/phpickerconfiguration

```swift
var configuration = PHPickerConfiguration()
configuration.selectionLimit = 1 // 사진 선택 가능 갯수
configuration.selection =  .default // 사진 선택 스타일 
configuration.preferredAssetRepresentationMode = .current // 어떤 형식으로 받을지 결정하는 설정. 가장 최근 상태로 받아온다. 예를 들어, 사용자가 사진을 편집했다면 편집된 최신 버전을 받게 된다.
configuration.filter = .images // 사진만 필터링하여 가져오도록 하는 설정.
```

#

> 이후 PHPickerViewController를 생성하여 configuration을 할당해준다.

* https://developer.apple.com/documentation/photokit/phpickerviewcontroller

```swift
let pickerViewController = PHPickerViewController(configuration: configuration)
```

#

> 해당 이미지 피커는 delegate를 할당할 수 있다.

* https://developer.apple.com/documentation/photokit/phpickerviewcontroller/3606606-delegate

```swift
pickerViewController.delegate = self
rootViewController.present(pickerViewController, animated: true, completion: nil)
```

#

> 이 delegate를 통해 이미지 선택이 모두 완료되었을 때 시점에 동작을 커스텀할 수 있다.
> 해당 delegate 메소드를 활용하여 results에 담겨져있는 데이터로 UIImage를 추출하여 사용하면 된다.

* https://developer.apple.com/documentation/photokit/phpickerviewcontrollerdelegate

```swift

// PHPickerViewControllerDelegate 메소드.
func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    // 사진을 한 장만 선택했을 때 간단한 예시.
    let itemProviders = results.compactMap { $0.itemProvider }
    guard let itemProvider = itemProviders.first else { return }
    
    if itemProvider.canLoadObject(ofClass: UIImage.self) {
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            
            guard let self = self,
                  let image = image as? UIImage else { return }
                  
            // UI 업데이트를 위해 main thread로 변경
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
}
```

#

### 사용자 디바이스에 있는 앨범 목록을 가져오려면...?

* https://developer.apple.com/documentation/photokit/phassetcollection

`PHAssetCollection.fetchAssetCollections(with:subtype:options:)` 메소드를 통해 앨범들을 가져올 수 있다.
이 때는 사용자에게 [앨범 접근 권한 요청](https://developer.apple.com/documentation/photokit/phphotolibrary/3616053-requestauthorization)을 하여 권한을 가져와야한다.
보통은 사용자 앨범을 가져와서 아래처럼 커스텀하게 앨범 목록을 표시해주려고 할 때 사용하는 듯 하다.

![image](https://github.com/leeari95/TIL/assets/75905803/ea4ab887-e6db-4d73-b3f7-e3ad862adf9f)

#

#### album vs smertAlbum

* album
    * 앨범은 사용자가 직접 만든 앨범 목록들을 가져오게 된다.
* smartAlbum
    * iOS 시스템에 의해 자동으로 생성되고 관리되는 앨범을 의미한다.
    * 예를 들어, '최근 항목', '즐겨찾는 항목', '셀피' 등과 같은 카테고리가 여기에 속한다.
    * 스마트 앨범은 특정 규칙이나 기준에 따라 자동으로 사진을 분류한다.



# Reference

* https://developer.apple.com/documentation/photokit
* https://developer.apple.com/documentation/photokit/phpickerviewcontroller
* https://developer.apple.com/documentation/photokit/delivering_an_enhanced_privacy_experience_in_your_photos_app
