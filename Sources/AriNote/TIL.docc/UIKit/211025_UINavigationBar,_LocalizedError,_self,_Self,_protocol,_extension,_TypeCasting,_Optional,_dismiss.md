# 211025 UINavigationBar, LocalizedError, self, Self, protocol, extension, TypeCasting, Optional, dismiss
# TIL (Today I Learned)

10월 25일 (월)

## 학습 내용
오늘은 활동학습 시간에 클래스와 구조체, 참조와 값, 그리고 싱글턴에 대해서 학습해보았다. 예전에 공부한 적이 있었지만 참조타입과 값타입은 역시 접하는 시간마다 매번 어려운 순간같다고 느껴지는 시간이였다. 이후 제이티와 함께 STEP 2 프로젝트를 구현하기 시작하였다.

&nbsp;

## 문제점 / 고민한 점
- STEP 2 요구사항을 구현하기전에 설계를 어떤식으로 하면 좋을까?
- Navigation View Controller가 두개인데.. 왜 두개지? 하나면 되지 않나?
- LocalizedError 프로토콜은 쓰라고 만들어 둔걸까?
- 프로토콜을 채택후 Optional인 프로퍼티를 non-optional로 구현하면 안되는 건가?
- 얼럿을 예, 아니오로 표시하라고 되어있는데.. HIG 지침에는 하지말라고 되어있다. 이럴 경우 요구사항을 지켜야하는걸까?
- self와 Self 차이점을 모르겠다.
- 과일의 재고가 변동이 될때마다 화면에 반영이 되었으면 좋겠는데...
- 프로토콜을 채택한 타입을 사용할 때, 프로토콜에서 정의한 프로퍼티와 이름이 동일한 프로퍼티를 구현했다. 근데 왜 타입에서 구현한 프로퍼티를 안가져오는거지?
- dismiss가 뭐여...

&nbsp;
## 해결방법
- 요구사항을 하나씩 재현해나가며 코드를 어떤식으로 짤지 의논하였다.
- Navigation Bar를 이용하기 위한 설계였다. Navigation View Controller가 아니라면 Navigation Bar Button을 이용할 수가 없어서 버튼을 직접 구현해줘야 했다.
- 구글링을 해보아도 해당 프로토콜을 쓰는 사람을 찾기에는 어려웠다. 추측이지만 EncodingError라는 타입을 쓸 때 사용되는 것 같다.
- 이름은 같고 타입이 다르면 그건 다른 프로퍼티인 것이다. 그러나 파라미터로 어떤 타입을 명시해주냐에 따라 그 타입에 맞는 프로퍼티가 적절하게 들어가는 것 같다는 추측을 해보았다. 질문-답변방에도 올려보았지만 이해가 되지 않았다...
    - **야곰의 답변** String과 String?은 `서로 다른 타입`이다. 파라미터 타입이 `String?`이라면, 그리고 파라미터를 전달할 후보가 `String, String?` 두 가지가 있다면 컴파일러는 당연히 `String?`을 전달해주려고 할 것이다. 다만 최후의 후보가 String 뿐이라서 String? 자리에 `String`이 전달되는 경우 **String**을 `String?으로 포장`해줄 수는 있겠다.
- `self` 자기 자신을 나타내는 프로퍼티다.
- `Self` 자기 자신의 동적 타입을 나타낸다.
- Notification을 활용하여 재고수정 메서드가 호출될 때마다 post, 즉 알림을 발송하게 구현하였다. 그리고 ViewController에다가 옵저버를 추가하는 작업을 해주었다. 
- 모달의 상태를 해제시켜주는, 모달로 제공한 View를 닫아주는 역할의 UIViewController의 인스턴스 메서드이다.
&nbsp;

<details>
<summary>질문했던 내용 메모</summary>
<div markdown="1">

안녕하세요. 늦은밤 실례하겠습니다ㅎㅎ…
프로토콜을 사용해보다가 이상한 걸 발견해서 질문 올려봅니다.
제가 원하는건 해결방법이 아니라 이유가 궁금해서요. 왜그런걸까요?
이 이슈를 재현하는 방법은 아래와 같습니다.

# 샘플 코드
```swift
// 프로토콜 정의
protocol Camper {
    var property: String? { get } // 옵셔널
}
// 프로토콜 기본 구현
extension Camper {
    public var property: String? { // 옵셔널
        return nil
    }
}
// 프로토콜 채택
struct Person: Camper {
    var property: String { // 옵셔널로 구현하지 않았음
        return "Hello"
    }
}

// 테스트 함수
func test(message: String?) {
    print(message) // 내가 기대한 결과 -> Opional("hello")
}

let ari = Person() // 인스턴스 생성
```
# 제가 기대한 결과물
test(message: ari.property) // Optional("hello")

# 실제 결과물
test(message: ari.property) // nil

# 코드 설명
이해를 위해서 내용을 정리해보았습니다.
* 이름이 같지만 타입은 다른 프로퍼티를 extension을 이용하여 사용하는 경우이다.
    * Optinal과 Non-Optional
* 원래 이름은 같고 타입만 다른 프로퍼티는 만들수가 없는데, extension을 이용하면 가능해진다.
* Protocol에서 정의, extension으로 기본 구현을 하고, 그 프로토콜을 채택한 타입(Person)을 만든다.
* 그리고 extension에서 프로토콜이 정의한 프로퍼티를 구현한 프로퍼티를 재구현하는 것이 아니고,
* 타입은 다르지만 이름이 같은 프로퍼티를 만든다.
    * 프로토콜이 정의한 프로퍼티는 Optinal
    * 타입에서 정의한 프로퍼티는 Non-Optional이다.
    * 이름은 동일하다.
* 함수에 파라미터로 프로토콜이 정의한 프로퍼티가 아니라 타입에서 정의한 프로퍼티를 전달한다.
    * 일반적으로 기대하는 결과는 당연히 타입에서 구현한 프로퍼티의 값이 나올 거라는 것이다.
    * 그렇지만 타입을 정의하기 이전에 extension으로 구현한 값이 전달된다.
        * 그것도 함수의 파라미터로 전달할 때에만… 
    * 프로퍼티를 타입을 명시하지않고 변수에 담아준다거나 print문을 사용할 땐 제대로 타입의 프로퍼티를 인식한다.
* 왜 내가 전달한 것은 String인데 왜 함수의 파라미터로 전달할 때에만 String?을 가져오는 것일까?

# 나의 추측
컴파일 시점에 이름이 동일한 프로퍼티가 2개가 있으니 타입이 같은 extension의 프로퍼티를 추론하여 가져온다 라는... 생각이 드네요.
아래처럼 아예 타입을 지정해서 변수에 담아주면 컴파일이 알아서 들어갈 값을 정해서 넣어주는 현상을 볼 수 있습니다.
```swift
let testtest: String? = ari.property // nil
let test: String = ari.property // “Hello”
```

왜 이런 현상이 발생하는지 근거를 찾아보려고 해보았으나 찾지못했어요. 찾지못해서 추측만 해보는 상황이네요…
다른분들의 의견도 궁금해서 올려봅니다.


</div>
</details>

---

- 참고링크
    - [동일한 프로퍼티 이름이 주어졌을 경우](https://stackoverflow.com/questions/62265690/swift-protocol-conformance-when-same-property-name-is-optional)
    - [self vs Self](https://www.hackingwithswift.com/example-code/language/self-vs-self-whats-the-difference)
    - [LocalizedError](https://developer.apple.com/documentation/foundation/localizederror)
    - [UINavigationBar](https://developer.apple.com/documentation/uikit/uinavigationbar)
    - [dismiss](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621505-dismiss)
