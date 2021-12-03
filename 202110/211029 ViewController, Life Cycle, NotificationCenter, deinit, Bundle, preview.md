# TIL (Today I Learned)

10월 29일 (금)

## 학습 내용
오늘은 ViewController의 Life Cycle에 대한 활동학습을 진행하였다. 혼자 예습삼아 공부했던 것보다 팀원들과 다양한 이야기를 나누며 훨씬 많은 것들을 깨닫는 유익한 시간이였다. 이후에는 오토레이아웃 강의를 다시 보기 시작했다.
&nbsp;

## 문제점 / 고민한 점
- NotificationCenter의 `removeObserver`를 어디서 하면 좋은걸까?
- modal을 켰을 때의 Life Cycle이 어떤 방식으로 동작하지?
- 모달을 내릴까 말까 하는 모션을 취할때 Life Cycle의 동작방식은 어떻게 될까?
- 오토레이아웃을 보다가 Preiview에 대한 것을 알게되서 찾아보다가 `UIKit에서도 실시간 Preiview 기능`을 사용할 수 있다는 점을 찾아보게 되었다.
- `Bundle`이란?
&nbsp;
## 해결방법
- 팀원들과 의논 끝에 `deinit`에다가 remove하면 적절할 것 같다고 이야기를 나누었다. `이유`는 화면이 잠깐 modal로 다른곳으로 세어나가도 noti를 받아서 view에 대한 업데이트가 필요할 경우에는 View가 잠깐 사라져도 옵저버는 유지되어야 한다는 이유에서 그렇게 결론이 났다.
- modal로 뷰가 넘어갈때에는 Navigation과는 다르게 이전 뷰가 사라지지 않고 남아있는 상태에서 NextView가 didAppear되었다.
    -  ### Disappearing 상태는 두가지 경우로부터 만들어진다.
        새로운 ViewController가 등장하여 현재의 화면을 덮는 경우
        이전화면으로 돌아가기 위해 현재의 ViewController가 사라지는 경우
- modal을 내릴듯 말듯한 제스처를 취해볼 생각을 못해서 신기했다. `ViewWillDisappear`와 `ViewWillAppear`,`ViewDidAppear`가 번갈아가며 호출되는 과정을 보면서 Life Cycle에 대한 이해도가 높아지는 것을 느꼈다.
- 야곰의 오토레이아웃 강의를 보다가 preview를 보는 방법을 알게되었다.
    ![](https://i.imgur.com/B3W7GfY.gif)
    ![](https://i.imgur.com/Y8143ov.gif)
    근데 위 방법은 코드로 작성한 부분은 적용이 되지가 않는다.
    `SwiftUI`은 `UIKit`와 다르게 코드를 작성하면서 실시간으로 Preview를 볼 수 있다는 것이 기억이나서 구글링 해보다가 UIKit에서도 실시간으로 Preview를 보면서 화면을 구현할 수 있다는 사실을 알게되었다. 훑어보니 `SwiftUI`를 import해서 `UIViewRepresentable, PreviewProvider` 두개의 프로토콜을 이용하여 Preview를 구현할 수 있는 방법이었다. 아직은 코드가 잘 이해가 가지 않기도 하고, 코드로 화면을 구현하는 방법이 익숙하지 않아서 나중에 스토리보드 말고 only code로 화면을 구현하게되는 날에 다시한번 써먹어보면 좋을 것 같다는 생각이 들었다.
- 알고보니 한달전에 이미 Bundle에 대해서 [공부한 기록](https://leeari95.tistory.com/46)이 있었다. (어쩐지.. 익숙하더라니... 왜 기억에없지....)다시보면서 복습을 해보았다.
&nbsp;

---

- 참고링크
    - [Xcode Previews](https://www.avanderlee.com/xcode/xcode-previews/)
