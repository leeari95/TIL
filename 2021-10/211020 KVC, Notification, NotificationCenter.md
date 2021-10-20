# TIL (Today I Learned)

10월 20일 (수)

## 학습 내용
오늘은 내일 활동학습을 위한 예습을 해보았다. Notification을 학습하는 과정중에 이해가 너무 안되서 예제코드를 찾아보면서 이해하려고 노력했다. KVO는 이전에 [KVC](https://github.com/leeari95/TIL/blob/main/2021-10/211012%20%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8%2C%20Properties%2C%20KeyPath%2C%20KVC%2C%20iOS%2C%20HIG.md)를 학습하면서 배웠던 내용이랑 비슷하여 어렵진 않았다.

&nbsp;
### KVO, Notification들 같은 패턴을 사용하는 이유?
- KVO와 Notification은 인스턴스 간의 통신을 하기 위한 수단이다. 통신을 한다는 것은 데이터, 정보를 주고받는 것이다.
- 하나의 객체가 다른 객체와 **소통**은 하지만 **묶이기(coupled)는 싫을 때** `KVO`, `Notification`, `Observing` 등을 사용한다.
- 두 패턴 모두 특정 이벤트가 일어나면 원하는 객체에 알려주어 해당되는 처리를 하는 방법을 가지고 있다.
- 어플리케이션의 특성상 객체간 소통은 필수적이다. 하지만 한 객체는 그 자체로 존재하면서 소통하고 싶을 뿐 다른 객체에 종속되어 동작하는 것은 '재사용성'과 '독립된 기능 요소'측면에서 볼 때 바람직하지 않다는 것이다.
- 각 타입들끼리 의존하지 않고 서로 연결되지 않은 채 역할을 분담하는 것이 유지 보수와 수정에 용이하다.


&nbsp;

## 문제점 / 고민한 점
- KVO는 알겠는데, Notification에 대한 이해가 어려웠다.
&nbsp;

## 해결방법
- 직접 예제코드를 작성해보면서 이해해보았다.
&nbsp;

## 공부내용 정리
<details>
<summary>KVO, Key-value observing</summary>
<div markdown="1">

KVO는 A객체에서 B객체의 프로퍼티가 변화됨을 감지할 수 있는 패턴이다. Notification이 주로 Controller와 다른 객체 사이의 관계를 다룬다면 KVO는 객체와 객체 사이의 관계를 다루는데 적합하다. 메소드나 다른 액션에서 나타나는 것이 아니라 프로퍼티의 상태에 반응하는 형태이다.

# 장점
* 두 객체 사이의 정보를 맞춰주는 것이 쉽다
* New / old value를 쉽게 얻을 수 있다.
* KeyPath로 옵저빙하기 때문에 nested objects도 옵저빙이 가능하다.
# 단점
* NSobject를 상속받는 객체에서만 사용이 가능하다.
* dealloc될 때 옵저버를 지워줘야 한다.
* 많은 value를 감지할 때는 많은 조건문이 필요하다.

---

* 객체의 프로퍼티의 변경사항을 다른 객체에 알리기 위해 사용하는 코코아 프로그래밍 패턴
* Model과 View와 같이 논리적으로 분리된 파트간의 변경사항을 전달하는데 유용함
* NSObject를 상속한 클래스에서만 KVO를 사용할 수 있다.

---

# Observing을 위한 Setup
```swift
class Person: NSObject {
    let name: String
    @objc dynamic var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}
```

1. age가 변경하는 걸 다른 객체에게 알리고 싶다면 위 예제처럼 NSObject 상속을 받아야한다. 
    SObject를 상속한 클래스에서만 KVO를 사용할 수 있기 때문이다. 
    상속을 해야하므로 class에서만 사용가능하다. 

2. observe하려는 프로퍼티에 @objc attribute와 dynamic modifier를 추가해야한다.

---

# Observer 정의

KeyPath를 사용하여 프로퍼티 KeyPath에 observer를 추가할 수 있다.
- 관찰자 클래스의 인스턴스는 하나 이상의 속성에 대한 변경사항에 대한 정보를 관리한다.
- 관찰자를 만들 때 관찰하려는 속성을 참조하는 키 경로로 메서드를 호출하여 관찰을 시작한다.

```swift
var person = Person(name: "ari", age: 20)

person.observe(\.age , options: [.old, .new]) { (object, change) in
    print("갑자기 \(object.name)의 나이(\(change.oldValue!))가 \(change.newValue!)살이 되어버렸다...")
}
person.age = 24 // 갑자기 ari의 나이(20)가 24살이 되어버렸다...
person.age = 27 //갑자기 ari의 나이(24)가 27살이 되어버렸다...
```

## 프로퍼티 옵저버와 다른점이 뭘까?
* 프로퍼티 옵저버는 타입 정의 내부에 위치 
    KVO는 타입 정의 외부에서 observer를 추가할 때 사용

</div>
</details>
<details>
<summary>Notification</summary>
<div markdown="1">

싱글턴 객체중 하나이므로 이벤트들의 발생 여부를 옵저버를 등록한 객체들에게 Notification을 post하는 방식으로 사용한다. Notification Name이라는 Key 값을 통해 보내고 받을 수 있다.

# 장점
* 많은 줄의 코드가 필요없이 쉽게 구현이 가능하다.
* 다수의 객체들에게 동시에 이벤트의 발생을 알려줄 수 있다.
* Notification과 관련된 정보를 Any? 타입의 object, [AnyHashable : Any]? 타입의 userInfo로 전달할 수 있다.
# 단점
* key 값으로 Notification의 이름과 userInfo를 서로 맞추기 때문에 컴파일시 구독이 잘 되고 있는지, 올바르게 userInfo의 value를 받아오는지 체크가 불가능 하다
* 추적이 쉽지 않을 수도 있다
* Notification post 이후 정보를 받을 수 없다.

---

# Notification
NotificationCenter를 통해 정보를 저장하기 위한 구조체다.
옵저버들에게 전달되는 구조체로 정보가 담겨있고, 해당 알림을 등록한 옵저버에게만 전달된다. 구조체는 아래와 같이 구성되어 있다.

```swift
var name: Notification.Name
var object: Any?
userInfo: [AnyHashable : Any]?
```

### name
전달하고자 하는 notification의 이름 (이걸 통해 알림을 식별한다)

### object 
발송자가 옵저버에게 보내려고 하는 객체. 주로 발송자 객체를 전달하는 데 쓰임

### userInfo 
notification과 관련된 값 또는 객체의 저장소. Extra data를 보내는데 사용 가능

</div>
</details>
<details>
<summary>Notification Center (NSNotificationCenter)</summary>
<div markdown="1">

![](https://i.imgur.com/G0xAvnT.png)
notification이 오면 observer pattern을 통해서 등록된 옵저버들에게 notification을 전달하기 위해 사용하는 클래스.
notification을 발송하면 NotificationCenter에서 메세지를 전달한 observer를 처리할 때까지 대기한다.
즉, 흐름이 동기적으로 흘러간다.
- otification Center를 통해서 앱의 한 파트에서 다른 파트로 데이터를 전달할 수 있다.
- Notification이 오면 등록된 observer list를 스캔한다.
- Notification Center는 어플리케이션 어느 곳에서 어느 객체와도 상호작용을 할 수 있다.

## 상호 작용을 하기 전에 extension으로 Notification.Name을 추가해주면 편리하다.
```swift
// Notification Name 설정
extension Notification.Name {
    static let secret = Notification.Name("Shh")
}
```

NotificationCenter로 Post하기 (발송하기)
Post가 핵심이다. Name의 해당자들에게 일을 수행하라고 시킨다.
```swift
// 노티피케이션 발송
NotificationCenter.default.post(name: Notification.Name.secret, object: nil, userInfo: [NotificationKey.password: "암호는 !@#$"])
```
* name
전달하고자 하는 notification의 이름 (이걸 통해 알림을 식별)
* object
addObserver의 object 부분과 목적이 동일한데, 특정 sender의 notification만 받고 싶은 경우 작성 해주면 된다. filter 기능과 같다고 생각하면 될 것 같다. 없으면 nil
* userInfo
notification과 관련된 값이다. extra data를 보내는데 사용한다.

# Notification Center에 Observer 등록하기
* notification을 observe 해주기 전에 Notification Center에 `addObserver` 과정을 무조건 먼저 거쳐줘야 원하는 신호를 관찰 가능하니까 주의하도록 하자.
* `addObserver`가 있으면 `removeObserver(_:name:object:)`도 있는데 방식은 같다.

```swift
// Notification Name 설정
NotificationCenter.default.addObserver(self, selector: #selector(answerToMaster(notification:)), name: Notification.Name.secret, object: nil)

@objc func answerToMaster(notification: Notification) {
    // notification.userInfo 값을 받아온다.
    guard let key = notification.userInfo?[NotificationKey.password] as? String else {
        return
    }
    print("\(name): \(key)")
}
```

# NotificationCenter는 언제 사용해야할까?
* 앱 내에서 공식적인 연결이 없는 두 개 이상의 컴포넌트들이 상호작용이 필요할 때
* 상호작용이 반복적으로 그리고 지속적으로 이루어져야 할 때
* 일대다 또는 다대다 통신을 사용하는 경우

---

# 예제 코드 풀버전
```swift
// Notification Name 설정
extension Notification.Name {
    static let secret = Notification.Name("Shh")
}

// Notification과 관련된 인스턴스
enum NotificationKey {
    case password
}

class Master {
    func callPassword() {
        print("마스터: 벽면에 쓰여있는 암호를 읊어봐.")
        // NotificationCenter로 Post하기 (발송하기)
        NotificationCenter.default.post(name: Notification.Name.secret, object: nil, userInfo: [NotificationKey.password: "!@#$"])
    }
}

class Friend {
    let name: String
    
    init(name: String) {
        self.name = name
        // NotificationCenter에 Observer 등록하기
        NotificationCenter.default.addObserver(self, selector: #selector(answerToMaster(notification:)), name: Notification.Name.secret, object: nil)
    }
    @objc func answerToMaster(notification: Notification) {
        // notification.userInfo 값을 받아온다.
        guard let object = notification.userInfo?[NotificationKey.password] as? String else {
            return
        }
        print("\(name): 암호는 \(object)")
    }
}

let master = Master()

// 관찰자들 (observer)
let ariOwn = Friend(name: "아리랑")
let ariTwo = Friend(name: "쓰리랑")
let ariThree = Friend(name: "아라리오")

// observer들에게 일을 수행하라고 시킨다
master.callPassword()
/*
마스터: 벽면에 쓰여있는 암호를 읊어봐.
아리랑: 암호는 !@#$
쓰리랑: 암호는 !@#$
아라리오: 암호는 !@#$
/*
```

</div>
</details>
<details>
<summary>Delegation</summary>
<div markdown="1">

Delegate는 보통 Protocol을 정의하여 사용된다. Protocol이란 일종의 기능 명세서 같은 것으로 Delefate로 지정된 객체가 해야하는 메소드들의 원형을 적어놓는다. Delegate 역할을 하려는 객체는 이 Protocol을 따르며 원형만 있던 메소드들의 구현을 한다. 이렇게 세팅 후 이전 객체는 어떤 이벤트가 일어났을 시 Delegate로 지정한 객체에 알려줄 수 있다.

# 장점
* 매우 엄격한 Syntax로 인해 프로토콜에 필요한 메서드들이 명확하게 명시된다.
* 컴파일 시 경고나 에러가 떠서 프로토콜의 구현되지 않은 메소드들을 알려준다
* 로직의 흐름을 따라가기 쉽다
* 프로토콜 메소드로 알려주는 것 뿐만 아니라 정보를 받을 수 있다.
* 커뮤니케이션 과정을 유지하고 모니터링하는 제 3의 객체가 필요없다. (NotificationCenter같은 외부 객체)
* 프로토콜이 컨트롤러의 범위 안에서 정의된다.

# 단점
* 많은 줄의 코드가 필요하다
* delegate 설정에 nil이 들어가지 않게 주의해야한다. 크래시를 일으킬 수 있다.
* 많은 객체들에게 이벤트를 알려주는 것이 어렵고 비효율적이다. (가능은 하다.)

</div>
</details>

---

- 참고링크
    - [KVO](https://developer.apple.com/documentation/swift/cocoa_design_patterns/using_key-value_observing_in_swift)
    - [KVO Option](https://developer.apple.com/documentation/foundation/nskeyvalueobservingoptions)
    - [Notification](https://developer.apple.com/documentation/foundation/notification)
    - [NotificationCenter](https://developer.apple.com/documentation/foundation/notificationcenter)
    - [Blog - Delegation, Notification, 그리고 KVO](https://medium.com/@Alpaca_iOSStudy/delegation-notification-%EA%B7%B8%EB%A6%AC%EA%B3%A0-kvo-82de909bd29)
    - [Blog - KVO](https://zeddios.tistory.com/1220)

