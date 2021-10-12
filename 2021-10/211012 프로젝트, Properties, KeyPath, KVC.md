# TIL (Today I Learned)

10월 12일 (화)

## 학습 내용
새벽에 프로젝트 STEP 1을 피드백 받기전에 좀 더 생각해볼 점은 없는지 완성한 코드를 보면서 고민하는 시간을 가졌다. 그리고 아침에 `알라딘`과 만나서 고민했던 점을 나누고 코드를 개선한 후 PR을 올렸다. 이후에는 개인 공부시간을 가지기로 하고 프로퍼티와 KVC에 대해서 공부해보았다.
 
## 문제점 / 고민한 점
- 가위(1), 바위(2), 보(3)를 좀더 명확하게 표시할 수 없을까?
- 연산 프로퍼티를 이용하여 randomNumber를 만들어보면 어떨까?
- 승패판정을 하는 메소드명을 명확하게 다시 지어주고 싶다.
- 프로퍼티의 종류와 내용을 까먹었다. 복습을 해야겠다.
- 공부하다가 `KeyPath` 라는 키워드를 얻었다. 이게 뭐지?
- 프로젝트 코드를 보면서 개선할 수 있는 부분은 없는지 살펴보았다.
    
&nbsp;

## 해결방법
- 각 숫자를 의미를 담아 프로퍼티로 선언해주었더니 코드 내부의 가독성이 상승했다!
- 일단 연산 프로퍼티를 적용해보았는데, 좋아진건지 모르겠다. 로직은 그대로라... 리뷰어인 `Soll`에게 물어보기로 하였다.
- Naming 파트를 다시한번 참고해보았는데.. 영어가 안된다... 영어공부를 해야할까...? 휴...
- Properties 파트와 KeyPath는 무엇인지 간단하게 정리해보았다.
- 역시 코드는 맨날 봐도 새롭게 다가온다. 좋은 방법이 떠올랐다!
&nbsp;

## 공부내용 정리
<details>
<summary>Properties</summary>
<div markdown="1">

# Properties

프로퍼티 클래스, 구조체 또는 열거형 등에 관련된 값을 뜻한다.
메서드  특정 타입에 관련된 함수를 뜻한다.

# 저장 프로퍼티 (Stored Properties)
클래스, 구조체의 인스턴스와 연관된 값을 저장하는 가장 단순한 개념의 프로퍼티

## 지연 저장 프로퍼티 (Lazy Stored Properties)
인스턴스를 생성할 때 프로퍼티에 값이 필요 없다면 프로퍼티를 옵셔널로 선언해줄 수 있다. 그러나 그것과는 조금 다른 용도로 필요할 때 값이 할당되는 지연 저장 프로퍼티가 있다. 지연 저장 프로퍼티는 호출이 있어야 값을 초기화하며, 이때 `lazy` 키워드를 사용한다.
상수는 인스턴스가 완전히 생성되기 전에 초기화해야 하므로 필요할 때 값을 ㅎ라당하는 지연 저장 프로퍼티와는 맞지 않다. 따라서 지연 저장 프로퍼티는 `var` 키워드를 사용하여 변수로 정의한다.
주로 ‘굳이 모든 저장 프로퍼티를 사용할 필요가 없다면?’ 혹은 ‘인스턴스를 초기화하면서 저장 프로퍼티로 쓰이는 인스턴스들이 한 번에 생성되어야 한다면?’ 이 질문의 답이 지연 저장 프로퍼티 사용이라고 볼 수 있다.
지연 저장 프로퍼티를 잘 사용하면 불필요한 성능저하나 공간 낭비를 줄일 수 있다.

## 연산 프로퍼티 (Computed Properties)
저장 프로퍼티와 다르게 특정 상태에 따른 값을 연산하는 프로퍼티이다. 인스턴스 내.외부의 값을 연산하여 적절한 값을 돌려주는 접근자의 역할이나 은닉화된 내부의 프로퍼티 값을 간접적으로 설정하는 설정자의 역할을 할 수도 있다.
연산 프로퍼티는 접근자인 `get` 메서드만 구현해둔 것처럼 `읽기 전용 상태`로 구현하기는 쉽지만, `쓰기 전용 상태로 구현할 수 없다는 단점`이 있다.

## 프로퍼티 감시자 (Property Observers)
프로퍼티의 값이 변경됨에 따라 적절한 작업을 취할 수 있다. 프로퍼티 감시자는 `프로퍼티의 값이 새로 할당될 때마다 호출`한다. 이때 변경되는 값이 현재의 값과 같더라도 호출한다. 지연 저장 프로퍼티에는 사용할 수 없다. 일반 저장 프로퍼티에만 사용할 수 있다. 또한 프로퍼티 재정의해 상속받은 저장 프로퍼티 또는 연산 프로퍼티에도 적용할 수 있다.
프로퍼티 감시자에는 프로퍼티의 값이 변경되기 직전에 호출하는 `willSet` 메서드와 프로퍼티의 값이 변경된 직후에는 호출하는 `didSet` 메서드가 있다. willSet은 변경될 값이고, didSet은 `변경되기 전의 값`이다. 매개변수의 이름을 따로 지정하지 않으면 `willSet은 newValue`가, `didSet은 oldValue`라는 매개변수 이름이 **자동 지정**된다.
- 만약 프로퍼티 감시자가 있는 프로퍼티를 함수의 입출력 매개변수의 전달인자로 전달한다면 항상 `willSet과 didSet 감시자`를 호출한다. 함수 내부에서 값이 변경되든 되지 않든 간에 함수가 종료되는 시점에 값을 다시 쓰기 때문이다.

</div>
</details>
<details>
<summary>Keypath</summary>
<div markdown="1">

# Keypath

프로퍼티의 위치만 `참조`하도록 할 수 있는 방법이다. C로 치면 `포인터`라고 보면 될 것 같다.
`\타입이름.경로.경로.경로`

## 키 패스를 사용하는 이유
키패스는 `Metaprogramming`의 한 형태이다. 속성에 대한 위치를 `참조`하여 인스턴스의 속성을 동적으로 읽거나 쓴다.
```swift
struct Address {
    var town: String
}

struct Person {
    var address: Address
}

let address = Address(town: "어딘가")
var ari = Person(address: address)
let ariTown = ari[keyPath: \Person.address.town] // 가져오기
print(ariTown) // 어딘가

ari[keyPath: \Person.address.town] = "어디야" // 수정하기
print(ari[keyPath: \Person.address.town]) // 어디야
```
## 키패스의 종류
- `AntyKeyPath` 타입이 지워진 KeyPath
- `PartialKeyPath` 부분적으로 타입이 지워진 KeyPath
- `KeyPath `Read-only, 읽기 전용
- `WritableKeyPath` value type 인스턴스에 사용 가능. 변경 가능한 모든 프로퍼티에 대한 read & write access 제공 
- `eferenceWritableKeyPath` 클래스의 인스턴스에 사용 가능. 변경 가능한 모든 프로퍼티에 대한 read & write access 제공. 

# KVC
Key-Value Coding의 약자이다. 객체의 값을 직접 가져오지않고, Key 또는 KeyPath를 이용해서 간접적으로 데이터를 가져오거나 수정하는 방법이다.

</div>
</details>
&nbsp;

---
- 참고링크
    - [Properties](https://docs.swift.org/swift-book/LanguageGuide/Properties.html)
    - [KeyValueCoding](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/index.html)
    - [archive/KVC](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/KeyValueCoding.html)
    - [Key-Value Coding(KVC) / KeyPath in Swift](https://zeddios.tistory.com/1218)
    - [KeyPath](https://learnappmaking.com/swift-keypath-how-to/)
