# TIL (Today I Learned)

11월 2일 (화)

## 학습 내용
오늘은 STEP 3를 구현하는 것에 대해서 시간을 많이 보냈다. 오후에는 의존모둠과 함께 클래스와 구조체에 대해서 의논하였고 끝나고난 이후에 제이티와 함께 PR과 README를 채워보았다.

&nbsp;

## 문제점 / 고민한 점
- ViewController에 다음 View에 대한 프로퍼티에 접근되지가 않았던 문제를 해결하려면 어떻게 했었지?
- button에 Dynamic Type을 적용시켜주려면?
- button의 Label의 크기가 버튼의 너비에 맞게 fix해주려면 어떻게 해야할까?
- NavigationViewController에 연결되어있는 ViewController를 불러오는 여러가지 방법
- Bundle에 대한 구체적인 개념이 궁금하다.
- Button을 코드로 구현하면 버튼을 클릭할 때 액션이 없다!
- Auto Layout 강의 예제 진행시 remove버튼을 클릭하면 뷰가 안사라지는 현상을 경험했다.

&nbsp;
## 해결방법
- `loadViewIfNeeded()`를 이용하여 View를 미리 load해서 해당 뷰 프로퍼티에 접근하였다. 하지만 적절한 방법인지는 모르겠다. 이리저리 돌아댕기면서 캠퍼들은 어떻게 구현했나 의견을 구해보았는데 didSet을 이용하여 데이터를 전달해주는 방법도 있었다. 보통 뷰간에 데이터를 전달할 때는 직접 전달하기 보다는 값을 담을 프로퍼티를 미리 만들어두고 값을 전달한 다음 해당 화면에서 값을 대입하는 방식을 택한다고 한다. 데이터가 안전하게 전달될 수 있도록 해당 방법을 쓰는 것 같은데, 왜 직접 전달하는게 안좋은 걸까? 이 부분은 리뷰어분께 조언을 구하기로 했다.
- 버튼의 title Label은 Inspector에서 Automatically Adjusts Font를 설정할 수가 없었다. 찾아보았지만 코드로 구현하는 것이 최선이였다. 
    ```swift
    orderStrawberryBananaJuiceButton.titleLabel?.adjustsFontForContentSizeCategory = true
    ```
- 이것도 디스코드를 이리저리 돌아다니면서 nicho, 고사리 팀에서 힌트를 얻었던게 생각이 나서 해결해보았다.
    ```swift
    orderStrawberryBananaJuiceButton.titleLabel?.adjustsFontSizeToFitWidth = true
    ```
- NavigationViewController에 속성값 중에 topViewController 라는 속성을 사용하여 접근할 수도 있고, viewControllers 배열에 접근해서 활용하는 방법, ViewController 속성값 중에 children이라는 속성도 활용할 수 있었다. 
- 번들은 백팩이라고 할 수 있다. 이 가방엔 내가 원하는 무엇이든 담을 수 있는 특별한 주머니가 있고 이 주머니는 어디를 가던 장소에 딱 맞게 바뀌어서 나온다.
- 오늘도 제이티의 꿀팁... Button을 생성해줄때 이니셜라이저 Type에다가 .system이라는 설정값을 줘야 버튼을 누를때 클릭되는 액션[?]이 생긴다
    ```swift
    UIButton(type: .system)
    ```
- 공식문서를 살펴보면 view를 지울 때 `isHidden = true`를 설정해주거나 removeFromSuperview()를 호출하여 뷰를 명시적으로 제거하라고 나와있었다. 둘중 하나를 설정해주지 않는다면 아무리 remove버튼을 눌러도 view가 데이터상에서는 사라지긴 하지만[?] 화면상에서는 사라지지 않고 남아있었다.
- isHidden을 true로 주었을 때
     
     ![](https://i.imgur.com/KBd6H3s.gif)
     
- isHidden을 true로 주지 않았을 때
     
     ![](https://i.imgur.com/rlVjRDr.gif)


&nbsp;

---

- 참고링크
    - [adjustsFontSizeToFitWidth](https://developer.apple.com/documentation/uikit/uilabel/1620546-adjustsfontsizetofitwidth)
    - [adjustsFontForContentSizeCategory](https://developer.apple.com/documentation/uikit/uicontentsizecategoryadjusting/1771731-adjustsfontforcontentsizecategor)
    - [번들과 패키지](https://nshipster.co.kr/bundles-and-packages/)
    - [topviewcontroller](https://developer.apple.com/documentation/uikit/uinavigationcontroller/1621849-topviewcontroller)
    - [children](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621452-children)
    - [buttontype](https://developer.apple.com/documentation/uikit/uibutton/buttontype)
    - [removearrangedsubview](https://developer.apple.com/documentation/uikit/uistackview/1616235-removearrangedsubview)
