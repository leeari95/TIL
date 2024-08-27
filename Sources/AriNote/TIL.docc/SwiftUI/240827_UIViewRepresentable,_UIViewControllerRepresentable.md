# 240827 UIViewRepresentable, UIViewControllerRepresentable

SwiftUI 환경에서 UIKit 요소를 가져와 사용하는 방법.


8월 27일 (화)


# 학습내용

프로젝트 내에서 일부 화면을 SwiftUI를 베이스로 구현할 수 있을 지 기술 검토를 하던 와중에... 최소버전 `iOS 15.0`에서는 기존 `UIScrollView`의 중요 기능이 SwiftUI의 `ScrollView`에는 없는 경우가 많아서 UIScrollView를 가져다가 사용헤야하는 상황을 만났다.

우리 프로젝트 구조에서는 최소버전 `iOS 18.0`은 되야 스크롤뷰가 그나마 쓸만하다는 판단이 들었고, 그전까지는 UIScrollView를 SwiftUI로 래핑하여 직접 필요한 기능을 구현한 후 사용해야한다는 사실을 알게되었다.

그래서 UIKit의 요소를 SwiftUI로 가져와 사용하려면 어떻게 해야하는지 방법을 찾아보게 되었다.

## UIViewRepresentable

* UIKit의 `UIView`를 SwiftUI에서 사용할 수 있게 하는 프로토콜
  
### 필수 구현 메서드

* `makeUIView(context:)`
  * SwiftUI에서 사용할 UIView 인스턴스를 생성한다.
  * UILabel, UIButton 같은 UIKit의 뷰를 이 메서드에서 생성해주면 된다.
* `updateUIView(_:context:)`
  * SwiftUI의 상태에 따라 UIView를 업데이트 한다.
  * 속성 래퍼 값이 업데이트 되면, 해당 메서드가 불려진다.

```swift
struct MyCustomLabel: UIViewRepresentable {
    @Binding var text: String // 외부에서 이 값이 바뀌면..

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.text = text
        return label
    }

    // 이 메서드가 불려진다.
    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.text = text 
        // 업데이트를 실제로 할지 말지는 구현자의 몫이다.
    }
}
```

## UIViewControllerRepresentable

* UIKit의 UIViewController를 SwiftUI에서 사용할 수 있게 하는 프로토콜

### 필수 구현 메서드

* `makeUIViewController(context:)`
  * UIViewController 인스턴스를 생성한다.
  * UIImagePickerController 같은 커스텀 뷰 컨트롤러를 이 메서드에서 생성해주면 된다.
* `updateUIViewController(_:context:)`
  * SwiftUI의 상태에 따라 UIViewController를 업데이트 한다.

```swift
struct MyCustomViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = MyViewController()
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // 필요한 경우 UIViewController를 업데이트
    }
}
```


## 느낀 점

* 아직 SwiftUI의 기본 컴포넌트만으로는 복잡한 구조의 앱을 다루기는 한계가 있다. (iOS 15, 16 기준...)
  * 뭔놈의 스크롤뷰가 페이징 기능도 없고... offset 추적하는 기능도 없냐.... `TabView` 쓰거나, `offset` 추적기능은 직접 만들어야함.
* 그래서 결국엔 UIKit 컴포넌트를 위와 같은 프로토콜을 통해 구현한 후 사용이 필요한 경우가 종종 있을 것 같다.
* 아직은... 우리 프로젝트에서는 간단한 화면이나 뷰 컴포넌트는 SwiftUI로 구현해볼만 할 것 같지만, 컬렉션뷰나 스크롤뷰를 통한 복잡한 화면 베이스는 UIKit을 사용하는 것이 리소스가 덜 들 것 같다.

다음은 SwiftUI의 요소를 UIKit에서 사용할 때 어떤 식으로 사용해보면 좋을 지 알아봐야겠다.

---


# 참고 링크

- [https://developer.apple.com/documentation/swiftui/uiviewrepresentable](https://developer.apple.com/documentation/swiftui/uiviewrepresentable)
- [https://developer.apple.com/documentation/swiftui/uiviewcontrollerrepresentable](https://developer.apple.com/documentation/swiftui/uiviewcontrollerrepresentable)
- [https://gist.github.com/aronbalog/2fade2ae3f9fa61dff0854aa661d20a6](https://gist.github.com/aronbalog/2fade2ae3f9fa61dff0854aa661d20a6)
- [https://gist.github.com/mbernson/9090953d3f5ca4f129eb72ea58436fdd](https://gist.github.com/mbernson/9090953d3f5ca4f129eb72ea58436fdd)
- [iOS 18 올리면 그때 다시 보자...](https://developer.apple.com/documentation/realitykit/model3d/onscrollvisibilitychange(threshold:_:))