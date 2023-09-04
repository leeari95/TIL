# 230904 keyboardLayoutGuide

# TIL (Today I Learned)

9월 4일 (월)

## 학습 내용

- iOS 15부터 지원되는 keyboardLayoutGuide를 간단히 알아보자.

&nbsp;

## 고민한 점 / 해결 방법

기존 프로젝트에서 키보드의 높이에 따라 레이아웃을 업데이트하는 로직을 `keyboardLayoutGuide`을 활용하여 개선하는 작업을 진행하였다.

생각보다 많은 코드가 제거되었고, 간편하게 뷰를 구성할 수 있었다.

&nbsp;

### 사용 방법

```swift
// UIKit Constraint setup example
view.keyboardLayoutGuide.topAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true

// SnapKit Constarint setup example
view.keyboardLayoutGuide.snp.makeConstraints { make in
  make.top.eqaulTo(textView.snp.bottom)
}

textView.snp.makeConstraints { make in 
  make.bottom.eqaulTo(view.keyboardLayoutGuide.snp.top)
}
```

* keyboardLayoutGuide는 키보드가 화면에 표시되고 있지 않으면 뷰의 하단 SafeArea와 일치한다.
* 키보드가 화면에 표시되면 키보드를 기준으로 레이아웃이 따라간다.
* 터치 포인트가 겹치면 키보드 dismiss 제스처를 트래킹한다.

&nbsp;

### 간단 요약

* 기존에 Notification을 통해서 키보드의 높이를 가져와서 계산하던 로직은 더이상 필요 없어지게 되었다.
* 키보드가 올라왔을 때 가려지지 말아야하는 뷰가 있다면 keyboardLayoutGuide를 기준으로 레이아웃을 설정해주면 된다!
* 더 자세한 활용법은 공식문서의 샘플 프로젝트를 참고해보자!

&nbsp;

# Reference

* https://developer.apple.com/documentation/uikit/uiview/3752221-keyboardlayoutguide
* https://developer.apple.com/documentation/uikit/keyboards_and_input/adjusting_your_layout_with_keyboard_layout_guide
* https://developer.apple.com/videos/play/wwdc2023/10281/
