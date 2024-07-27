# 211019 Nested Type, operator, Dictionary, Sequence, LocalizedError, Error Handling
# TIL (Today I Learned)

10월 19일 (화)

## 학습 내용
오늘은 제이티와 STEP 1에 대한 코드를 리팩토링 하기로 하였다. 잠깐 코드를 보면서 생각해봤던 부분을 나누었고, README와 PR내용을 같이 적어보면서 고민했던 점과 의문점, 조언을 얻고 싶은 점을 정리해보면서 애매하게 알고있는 개념들을 다시 같이 공부해보기도 하면서 시간을 보냈다. 같이 글로 정리하면서 느낀 것은 코드를 작성할 때는 대충 감으로 지식을 아는 느낌이였다면 말로 설명하려고 하거나 글로 정리하려니 정확한 내용을 전달해야해서 정확한 근거를 찾게 된다는 것이다. 글로 정리하면서 대충 알고 있던 지식들을 다시한번 복습하게 되면서 정확히 알아가던 유익한 시간이였다. 이후 README 작성을 마치고 PR을 보낸 후 각자 피드백이 올 때 까지 개인 공부 시간을 가지기로 하고 마무리 했다.

&nbsp;

## 문제점 / 고민한 점
- 과일 재고를 관리하는 메서드가 너무 low한 것 같다.
- 초기값을 전역변수로 선언해주면 어떨까?
- 파라미터는 함수타입인데, 왜 연산자만 넣어도 잘 작동할까?
- Nested Type을 이용하여 연관된 타입을 내부에 작성해주었는데, 이게 가독성 측면에서 좋은걸까?
- 예외처리를 구현해주었는데, do-catch문을 사용하지 않았다. 이유는 에러처리는 그것을 사용하는 공간에서 해야된다고 생각했기 때문인데, Controller에서 사용할 때 구현해주려 했다. 근데 Model에서 미리 구현해놔야 하는 건지 헷갈리기 시작했다.
- Dictionary의 init(uniqueKeysWithValues:)는 Sequence를 두개를 받아 초기화를 하는데, Array도 들어가네...? Array도 Sequence인가? Sequence가 정확히 뭘까?
- LocalizedError 프로토콜을 알게되었다. 쓰임새가 궁금해졌다.

&nbsp;

## 해결방법
- 과일 재고를 관리하는 메서드를 이용하여 명확하게 add,sub로 나누어 메서드를 별도로 구현해주었다.
- 전역변수로 선언해주고 private 키워드를 주었다. let으로 상수이기 때문에 전역변수도 괜찮다고 생각이 들었는데, 리뷰어분께도 조언을 들어보기로 하였다.
- swift integer operators를 검색해서 타고 들어가니 연산자가 어떻게 구성되어있는지 나와있었다. 연산자도 함수형태이기 때문에 파라미터로 전달하여도 문제없었던게 맞았다! 어느정도 예측은 하고있었으나 근거를 찾고 싶었다. 🤣
```swift=
static func + (lhs: Int, rhs: Int) -> Int
```
- 연관된 타입을 정의된 타입(구조체나 클래스) 내부에서만 사용한다면 문제없겠지만 만약 외부에서도 널리 사용하게 된다면 밖으로 빼주는 것이 맞을 것 같다는 생각이 들었다.
- 리뷰어인 흰에게도 물어보고, 2기, 3기 선배분들 한태도 물어보았다. 결론은 정답은 없다. 그 문제를 해결하려고 MVC, MVVM, Viper 등의 아키텍처가 나왔는데, 여전히 뭐가 더 낫니 아니니 말이 많기 때문이다. 그러나 MVC 관점에서 보면 컨트롤러가 에러 핸들링을 하는게 적절하다. 다만 massive view controller라는 문제도 있으니 알고 지나가면 좋을 것 같다.
- Array는 Sequence 프로토콜을 기반으로 작성되었다는 사실을 알게되었다. 그래서 Array 타입을 사용할 때 Sequence의 대부분의 기능을 제공해준다. map, filter뿐만 아니라 Sequence 안에서 특정 조건을 만족하는 첫번째 요소를 찾는 기능 까지 모두 다 Sequence 프로토콜 안에 정의되어 있다.
    - Sequence는 두가지 중요한 특징이 있는데 무한하거나, 유한하다. 그리고 한번만 이터레이트(iterate)할 수 있다.
- LocalizedError는 오류와 오류가 발생한 이유를 설명하는 메세지를 제공하는 프로토콜이다. 프로퍼티가 모두 Optional 형태로 정의있어서 구현해도 되고 안해도된다. 어떤 역할을 하는 지는 이름이 직관적이라서 이름만 봐도 어떤 역할인지 알 수 있었다.
&nbsp;

---

- 참고링크
    - [Swift integer operator +](https://developer.apple.com/documentation/swift/int/2885932)
    - [Nested Types](https://docs.swift.org/swift-book/LanguageGuide/NestedTypes.html)
    - [Dictionary uniquekeyswithvalues](https://developer.apple.com/documentation/swift/dictionary/3127165-init)
    - [Sequence](https://developer.apple.com/documentation/swift/sequence)
    - [Swift의 Sequence와 Collection](https://academy.realm.io/kr/posts/try-swift-soroush-khanlou-sequence-collection/)
    - [protocol LocalizedError](https://developer.apple.com/documentation/foundation/localizederror)
