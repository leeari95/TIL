# TIL (Today I Learned)

10월 26일 (화)

## 학습 내용
오늘은 STEP 2의 코드를 개선하고, 이후 PR 작성과 README 작성을 진행하였다.

&nbsp;

## 문제점 / 고민한 점
- Application의 가로모드와 세로모드를 제어할 수 있는 방법이 뭐지?
- NavigationViewController가 두개인 이유?
- madal의 경우 세로모드에서는 위에서 아래로 내리는 제스처를 사용할 수 있는데 가로모드에서 하려면 어떻게 해야하는거지?
- UIButton과 UILabel에 대해서 알아보자
- UI 관련 타입들을 네이밍할 때 끝에 Label이나 Button을 넣어주는 것이 널리 쓰이는 방법 같은데 적절한걸까?

&nbsp;
## 해결방법
- `Device Orientation`
    - 이 부분을 통해서 세로모드, 가로모드를 제어할 수 있다.
![](https://i.imgur.com/g4JYmeB.png)
- Navigation Bar의 아이템들을 활용해야하기 때문에 2개가 있다고 생각했다.
- 아이폰의 기본앱 `메일`을 바탕으로 실험해보았으나 가로모드에서는 위에서 쓸어내려서 modal을 끌 수가 없었다. 세로모드에서만 가능한 걸로...
- 이론적으로 정리해서 적어보았는데, 내일 Stepper도 함께 배워야할 것 같다.
- 이 부분은 적절한건지 감이 안와서 리뷰어에게 질문해보기로 하였다.

&nbsp;

---

- 참고링크
    - [iOS 디바이스 회전 처리에 대한 정리](https://jongwonwoo.medium.com/ios-%EB%94%94%EB%B0%94%EC%9D%B4%EC%8A%A4-%ED%9A%8C%EC%A0%84-%EC%B2%98%EB%A6%AC%EC%97%90-%EB%8C%80%ED%95%9C-%EC%A0%95%EB%A6%AC-340f37204a27)
    - [UIDeviceorientation](https://developer.apple.com/documentation/uikit/uideviceorientation)
    - [UIButton](https://developer.apple.com/documentation/uikit/uibutton)
    - [UIStepper](https://developer.apple.com/documentation/uikit/uilabel)
