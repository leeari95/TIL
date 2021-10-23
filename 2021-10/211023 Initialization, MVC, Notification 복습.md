# TIL (Today I Learned)

10월 23일 (토)

## 학습 내용
오늘은 불타는 토요스터디를 통해서 이니셜라이저와 MVC 패턴, Notification에 대해서 복습하였다.

&nbsp;

## 문제점 / 고민한 점
- 구조체에서는 Memberwise initalizer로 이니셜라이저를 따로 생성하지 않아도 되는데 클래스는 안되네?
- 초기화를 할때 구지 이니셜라이저를 쓰지 않고 기본값을 쓰는 경우는 언제일까?
- View와 Controller는 분리하기가 어려운 구조인 것 같은데, 왜그럴까?
- ViewController는 너무 많은 역할을 하는 것 같다...
- MVC 패턴에서 Notification을 사용할 때 Observer는 어디에, post는 어디에 두면 좋을까?

&nbsp;
## 해결방법
- 클래스는 프로퍼티에 기본값이 없다면 이니셜라이저 구현이 필수적이다. 구조체는 기본값이 없고 이니셜라이저가 없어도 Memberwise initalizer라는 것으로 자동적으로 init이 구현된다.
- 이니셜라이저 델리게이트는 구조체는 그냥 init을 새로 구현하면되고 클래스는 convenience init을 만들어서 구현할 수 있다.
```swift=
// Memberwise  initalizer
struct Human {
    let name: String
    var age: Int
}

// Initializer Delegation, initalizer Extension
extension Human {
    init() {
        self.init(name: "", age: 0)
    }
}


// class 내부에는 반드시 한 개 이상의 Designated initalizer가 있어야 한다.
class Person {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    convenience init() {
        self.init(name: "") // Designated initalizer 호출
    }
}
```
- [공식문서](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID204)에 `Default Property Values`부분을 확인해보면 '항상 동일한 초기값'을 가지는 경우에 기본값을 제공하라고 나와있다. 예를 들어 아이폰의 이름이 항상 "OO의 IPhone" 인것처럼 초기값 제공이 필요한 경우에만 프로퍼티에 기본값을 제공하고 나머지 경우에는 코드의 유연성을 위해서 이니셜라이저를 쓰는 것이 좋을 것 같다.
- 애초에 ViewController가 상속받는 클래스 이름 자체가 UIViewController이다. View를 가지고 있는 Controller라서 분리자체가 어려운 것 같다. 또한 Model의 인스턴스까지 생성해줘야 하고, View의 Life Cycle까지 관리하기 때문에 분리하기 어렵고, 분리가 안되니까 재사용도, 테스트도 불가능한 것이라고 보여진다.
- Notification을 사용하여 옵저버등록과 발송을 어디서 어디로 해야하는지 헷갈렸었는데, 오늘 `Wody`가 나의 궁금증을 해소시켜주었다. 옵저버는 말그대로 신호를 받는, 즉 관찰자이기 때문에 신호가 올때까지 기다렸다가 신호가 오면 일을 해야 한다. 따라서 Model이 될 수 있을 것같고, Post는 신호를 보내서 일을 시키는 것이기 때문에 Controller가 될 수 있을 것 같다.

## 오늘의 깨달음
- `허황`이 '그럼 인스턴스를 Controller가 아니라 Model 파일 외부 전역변수로 생성해주면 되지않나?' 라는 질문을 해서 '그럼 인스턴스가 전역으로 떠돌아 다니게 되니까 메모리 낭비가 될 것 같다'고 `Wody`가 답변해주었다. 다른 뷰로 가게되도 인스턴스가 살아있다. 즉, 불필요한 순간에 메모리를 쓰고 있다는 것이다. 이걸 듣고 설계할 때 나도 불필요하게 쓰이는 데이터가 없는지도 고려해야겠다는 생각이 들었다.
    - 데이터는 꼭 필요한 곳에서만 생성하고 죽게 설계한다.

&nbsp;

---

- 참고링크
    - [ViewControllers](https://developer.apple.com/documentation/uikit/view_controllers)
    - [UINavigationController](https://developer.apple.com/documentation/uikit/uinavigationcontroller)
    - [App Life Cycle](https://developer.apple.com/documentation/uikit/app_and_environment/managing_your_app_s_life_cycle)
