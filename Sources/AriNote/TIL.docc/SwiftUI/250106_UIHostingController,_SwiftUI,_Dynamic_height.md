# 250106 UIHostingController, SwiftUI, Dynamic height


SwiftUI로 만든 뷰의 높이를 구하는 방법을 알아보자.


1월 6일 (금)


# 학습내용


- SwiftUI로 뷰를 만들고 UIHostingController를 이용해 바텀 시트 형태로 띄우는 방법을 학습했다.  
- 바텀 시트의 높이를 콘텐츠 내용에 따라 동적으로 조절하는 방법을 고민했다.  
- SwiftUI 뷰의 실제 크기를 정확하게 계산하기 위해 `sizeThatFits`를 활용하는 방법을 적용했다.


# 고민한 점 / 해결방법

SwiftUI로 만든 뷰의 높이를 외부에서 알려면 아래처럼 하면 된다...!

```swift
let swiftUIView = TestView()
let viewController = UIHostingController(rootView: swiftUIView)
let height = viewController.view.sizeThatFits(CGSize(width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude)).height
print("SwiftUI 뷰의 실제 높이: \(height)")
```

원래는 `intrinsicContentSize`를 사용하여 SwiftUI 뷰의 높이를 구하려 했지만, 제대로 계산되지 않았다.

`intrinsicContentSize`는 고정된 크기만 제공하고, 즉시 계산되기 때문에 동적 레이아웃의 변화를 반영하지 못하는 것으로 보인다.

내가 구현한 SwiftUI 뷰는 여러 개의 `Text`가 `VStack` 내부에 위치해 있는데, `Text`의 길이에 따라 줄 수가 1줄 또는 2줄로 동적으로 변경될 수 있다. 그러나 `intrinsicContentSize`는 항상 1줄이라는 가정 하에 크기를 계산하는 것처럼 동작했다.

이 문제를 해결하기 위해 `sizeThatFits`를 사용했다.

`sizeThatFits`는 레이아웃 상태와 제한 조건을 고려하여 최적의 크기를 계산하고 반환한다. 특히, `Text 크기`나 `이미지 크기`와 같은 동적 콘텐츠에 따라 높이가 변경되는 경우에도 그 변화를 정확하게 반영한다.

---


# 참고 링크

- [https://developer.apple.com/documentation/swiftui/uihostingcontroller/sizethatfits%28in%3A%29?utm_source=chatgpt.com](https://developer.apple.com/documentation/swiftui/uihostingcontroller/sizethatfits%28in%3A%29?utm_source=chatgpt.com)
- [https://stackoverflow.com/a/62992524](https://stackoverflow.com/a/62992524)