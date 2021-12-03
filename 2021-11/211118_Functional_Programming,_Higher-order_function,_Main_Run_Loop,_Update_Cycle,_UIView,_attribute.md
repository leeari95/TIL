# 211118 Functional Programming, Higher-order function, Main Run Loop, Update Cycle, UIView, attribute
# TIL (Today I Learned)


11월 18일 (목)

## 학습 내용
- 함수형 프로그래밍, 고차함수 활동학습
- Main Run Loop
- Update Cycle
- UIView methods
- attribute
&nbsp;

## 공부내용 정리

# 함수형 프로그래밍이란?
* 모든 것을 순수 함수로 나누어 문제를 해결하는 기법
* 작은 문제를 해결하기 위한 함수를 작성하여 가독성을 높이고 유지보수를 용이하게 해준다.
* 클린 코드(Clean Code)의 저자 Robert C.Martin은 함수형 프로그래밍을 대입문이 없는 프로그래밍이라고 정의하였다.
* 즉 대입문을 사용하지 않는 프로그래밍이며, 작은 문제를 해결하기 위한 함수를 작성한다.

# 함수형 프로그래밍의 특징
* 부수 효과가 없는 순수 함수를 1급 객체로 간주하여 파라미터로 넘기거나 반환값으로 사용할 수 있으며, 참조 투명성을 지킬 수 있다.

# 부수 효과(Side-Effect)란?
다음과 같은 변화 또는 변화가 발생하는 작업을 의미한다.
* 변수의 값이 변경됨
* 자료 구조를 제자리에서 수정함
* 객체의 필드값을 설정함
* 예외나 오류가 발생하며 실행이 중단됨
* 콘솔 또는 파일 I/O가 발생함

# 순수 함수란?
* Memory or I/O의 관점에서 Side Effect가 없는 함수
* 함수의 실행이 외부에 영향을 끼치지 않는 함수

# 순수 함수로 얻을 수 있는 효과
* 함수 자체가 독립적이며 Side-Effect가 없기 때문에 Thread에 안전성을 보장받을 수 있다.
* Thread에 안전성을 보장받아 병렬 처리를 동기화 없이 진행할 수 있다.

# 참조 투명성(Referential Transparency)이란?
* 동일한 인자에 대해 항상 동일한 결과를 반환해야 한다.
* 참조 투명성을 통해 기존의 값은 변경되지 않고 유지된다. (Immutable Data)

# Swift를 이용한 함수형 프로그래밍 예시
* 함수를 모두 처리하고 싶을 경우

## 명령형 프로그래밍의 예
```swift
class CommandProgramming {
    //명령형 프로그래밍
    
    func doSomething(){
        print("doSomething")
    }
    
    func doAnotherThing(){
        print("doAnotherThing")
    }
    
    func executeAll(){
        doSomething()
        doAnotherThing()
    }
}

//호출부
executeAll()
```

## 함수형 프로그래밍의 예
```swift
class MethodProgramming {
    func doSomething(){
        print("do something")
    }
    
    func doAnotherThing(){
        print("do another thing")
    }
    
    func execute(tasks:[() -> Void]){
        for task in tasks {
            task()
        }
    }
    
}

//호출부
execute(tasks: [doAnotherThing, doSomething])
```
* 함수가 일급 시민이므로 함수를 전달인자 또는 반환값으로 사용할 수 있다.
    * 그래서 execute(tasks: [doAnotherThing, doSomething]) 처럼 함수를 전달인자로 사용할 수 있는 것이다.

---

# Main Run Loop
어플리케이션이 실행되면 iOS의 UIApplication이 메인 스레드에서 main run loop를 실행 시킨다. main run loop는 돌아가면서 터치 이벤트, 위치의 변화, 디바이스의 회전 등의 각종 이벤트들을 처리하게 된다. 이러한 처리 과정은 각 이벤트들에 알맞는 핸들러를 찾아 그들에게 권한을 위임하며 진행된다.

> 버튼의 터치 이벤트를 @IBAction 메소드가 처리하는 것과 같다.

이렇게 발생한 이벤트들을 모두 처리하고 권한이 다시 main run loop로 돌아오게 되고 이 시점을 update cycle이라고 한다.

# Update Cycle
main run loop에서 이벤트가 처리되는 과정에서 버튼을 누르면 크기나 위치가 이동하는 애니메이션과 같이 layout이나 position 값을 바꾸는 핸들러가 실행될 때도 있다. 이러한 변화는 즉각적으로 반영되는 것이 아니다.
시스템은 이러한 layout이나 position이 변화되는 View를 체크한다. 그리고 모든 핸들러가 종료되고 main run loop로 권한이 다시 돌아오는 시점인 update cycle에서 이런 view들의 값을 바꿔주어 position이나 layout의 변화를 적용 시킨다.

즉 postion이나 layout값을 변경하는 코드와 실제로 변경되는 값이 반영되는 시점에는 시간차가 존재한다는 뜻이다.

이러한 시간차가 존재한다는 것을 알고 있어야 setNeedsLayout과 layoutIfNeeded의 차이를 알 수 있다.

![](https://i.imgur.com/v8FsiHM.png)

이렇게 시간차가 존재하지만 이 시간차는 사용자가 체감할 수 없을 정도로 짧기 때문에 사용자는 그러한 시간차를 느끼지 못한다. 하지만 개발하는 사람은 이러한 시간차를 인지하고 있어야 정확히 원하는 핸들러를 구현할 수 있다.

# UIView methods
UIView에는 여러 내장 메소드가 존재하는데 중요한 메소드를 알아보자.

## layoutSubviews()
* View의 값을 호출한 즉시 변경시켜주는 메소드
* 호출되면 해당 View의 모든 Subview들의 layoutSubviews() 또한 연달아 호출한다. 
* 그렇기 때문에 비용이 많이 드는 메소드이고 그렇기 때문에 직접 호출하는 것은 지양한다. 
* 이는 시스템에 의해서 View의 값이 재계산되어야 하는 적절한 시점(update cycle)에 자동으로 호출된다.

그렇기 때문에 layoutSubviews를 유도할 수 있는 여러 방법이 존재한다. 이는 일종의 update cycle에서 layoutSubviews의 호출을 예약하는 행위라고 할 수 있다.

UIViewController내의 View가 재계산되어 다시 그려지는 행위가 발생하면, 즉 layoutSubViews가 호출 되고 View의 값이 갱신되고 나면 뒤이어 UIViewController의 메소드인 viewDidLayoutSubViews가 호출된다. 그렇기 때문에 갱신된 View 값에 의존하는 행위들은 viewDidLayoutSubViews에 명시를 해주어야 한다.

> 예를 들어 Layer값은 자동으로 변경되지 않기 때문에 속한 View의 frame이 변경되면 viewDidLayoutSubViews안에 Layer의 frame을 변경하는 코드를 작성해주어야 한다.

layoutSubviews를 update cycle에서 호출되게끔 자동으로 예약 해주는 상황들이 몇가지 존재한다. 즉 다음 상황에서는 시스템이 자동으로 size와 position이 변경되어야 하는 View라고 체크를 하고 updatecycle에서는 layoutSubviews가 호출되어 체크된 View의 layer와 position에 변경된 값을 반영한다.
* View의 크기를 조절할 때
* Subview를 추가할 때
* 사용자가 UIScrollView를 스크롤할 때
* 디바이스를 회전시켰을 때(Portrait, Landscape)
* View의 Auto Layout contraint 값을 변경시켰을 때
위에 나열된 시점에는 자동으로 update cycle에서 layoutSubviews를 호출하는 행위를 예약하는 것이다. 하지만 이렇게 자동으로 예약하는 행위 이외에도 수동으로 예약할 수 있는 메소드도 존재한다.

## setNeedsLayout()
layoutSubviews를 예약하는 행위 중 가장 비용이 적게 드는 방법이 setNeedsLayout을 호출하는 것이다. 
* 이 메소드를 호출한 View는 재계산되어야 하는 View라고 수동으로 체크가 된다.
* update cycle에서 layoutSubviews가 호출되게 된다.

이 메소드는 비동기적으로 작동하기 때문에 호출되고 바로 반환된다. 그리고 View의 보여지는 모습은 update cycle에 들어갔을 때 바뀌게 된다.

## layoutIfNeeded()
* 이 메소드는 setNeedsLayout과 같이 수동으로 layoutSubviews를 예약하는 행위이지만 해당 예약을 바로 실행시키는 동기적으로 작동하는 메소드다. 
* Update cycle이 올 때까지 기다려 layoutSubviews를 호출시키는 것이 아니라 그 즉시 layoutSubviews를 발동시키는 메소드다.

만일 main run loop에서 하나의 View가 setNeedsLayout을 호출하고 그 다음 layoutIfNeeded를 호출한다면 그 즉시 View의 값이 재계산되고 화면에 반영하기 때문에 setNeedsLayout이 예약한 layoutSubviews 메소드는 update cycle에서 반영해야할 변경된 값이 존재하지 않기 때문에 호출되지 않는다.

이러한 동작 원리로 layoutIfNeeded는 그 즉시 값이 변경되어야 하는 애니메이션에서 많이 사용된다. 만일 setNeedsLayout을 사용한다면 애니메이션 블록에서 그 즉시 View의 값이 변경되는 것이 아니라 추후 update cycle에서 값이 반영되므로 값의 변경은 이루어지지만 애니메이션 효과는 볼 수 없는 것이다.
setNeedsLayout과 layoutIFNeeded의 차이점은 동기적으로 동작하느냐 비동기적으로 동작하느냐의 차이다.

---

# attribute
attribute는 선언 또는 타입등에 대한 부가 정보를 나타낸다.
스위프트에는 세가지 종류의 attribute가 있는데 선언에 부여하는 attribute, 타입에 부여하는 attribute, 스위치 케이스에 부여하는 attribute이 있다.
attribute은 @ 표시를 속성 이름 앞에 명시한다.

```swift
@속성 이름
@속성 이름(파라미터)
```

## 선언속성
선언에만 사용할 수 있다
(클래스의 선언, 함수의 선언, 열거형의 선언, 프로토콜의 선언)

## available
* 특정 플랫폼 또는 운영체제의 버전에 관련된 속성이다.
* available 속성은 매개변수가 두개 이상 나열되는 리스트다.

매개변수로 사용할 수 있는 플랫폼 이름
* iOS (iOSApplicationExtension)
* macOS (macOSApplicationExtension)
* watchOS (watchOSApplicationExtension)
* tvOS (tvOSApplicationExtension)
* swift
모든 플랫폼에 적용할 수 있도록 하려면 리스트에 애스터리스크(*)를 적어주면 된다.

나머지 매개변수는 추가정보를 나타내는데 쓰인다.
중요한 남김말이나 생명주기 등의 자세한 정보를 나타낼 수 있다.
- unavailable, introduced, deprecated, obsoleted, message, renamed

## unavailable
해당 플랫폼에서 사용할 수 없는 선언임을 나타낸다.
```swift
@available(tvOS, unavailable)
class SomeClass {}
// tvOS에서 사용할 수 없는 클래스
```
## introduced
이 선언이 어떤 버전에서 처음으로 소개(작성)되었는지 나타낸다.
콜론(:) 뒤에 버전 번호를 덧붙여준다. 버전 번호는 양수로 나타낸다.
```swift
class SomeClass {
    // 이 프로퍼티는 스위프트 4.0에서 작성했으므로
    // 스위프트 4.0 이상에서만 사용할 수 있다.
    @available(swift, introduced: 4.0)
    var multilineString: String {
    return """
    여러줄
    문자열은
    스위프트 4.0 이상에서
    사용할 수 있습니다.
    """
    }
}
```
## deprecated
이 선언이 어떤 버전에서 사용이 제한(중지)되었는지 나타낸다.
특별히 버전을 명시하고 싶지 않다면 뒤에 콜론과 버전을 생략해도 된다.
```swift
@available(*, deprecated: 2.0.0)
class SomeClass {}
// 이 클래스는 2.0.0 버전부터 사용이 제한되었습니다.
```
## obsoleted
이 선언이 어떤 버전부터 버려진 것인지 나타낸다. 버려진 선언은 더이상 사용할 수 없다.
```swift
@available(*, obsoleted: 2.0.0)
class SomeClass {}
// 이 클래스는 2.0.0 버전부터 사용이 불가능합니다.
```
## message
사용이 제한되거나 불가능한 선언을 사용하려고 할 때 컴파일러로 프로그래머에게 전달할 경고 또는 오류 메세지다.
메세지는 문자열 리터럴로 작성한다.
```swift
@available(*, deprecated: 2.0.0, message: "아마도 쓰지 않는 것이 좋을 걸?")
class SomeClass {}
// 이 클래스는 2.0.0 버전부터 사용이 제한되었습니다.

Let instance = SomeClass() // 플랫폼 버전이 기준 버전보다 높다면 컴파일러 경고
// ‘SomeClass’ is deprecated: 아마도 쓰지 않는 것이 좋을 걸?
```
## renamed
해당 선언이 교체되어 다른 이름으로 변경되었을 때 그 다른 이름을 나타낸다.
다른 이름으로 교체된 선언을 사용하려 할 때 컴파일러를 통해 프로그래머에게 다른 클래스를 사용할 것을 제안할 경고 또는 오류 메세지다. 메세지는 문자열 리터럴로 작성한다.
```swift
@available(*, deprecated: 2.0.0, message: "아마도 쓰지 않는 것이 좋을 걸?", renamed: "NewClass")
class SomeClass {}
// 이 클래스는 2.0.0 버전부터 사용이 제한되었습니다.

@available(*, unavailable, message: "사용 불가", renamed: "NewClass")
class AnotherClass {}
// 이 클래스는 사용 불가능합니다.

@available(*, introduced: 2.0.0)
class NewClass {}

let someInstance = SomeClass() // 플랫폼 기준 버전보다 높다면 컴파일러 경고
let anotherInstance = AnotherClass() // 컴파일러 오류
let newInstance = NewClass() // 플랫폼 버전이 기준 버전보다 낮자면 컴파일러 오류
```
available 속성의 매개변수로 여러 플랫폼과 여러 매개변수를 동시에 전달할 수 있다.
introduced 매개변수를 생략하고 곧바로 버전을 명시해줄 수도 있다.
몇가지 플랫폼에서 사용할 것을 한정할 때는 사용하고 싶은 플랫폼 이름과 최소 버전을 명시해 주면 된다.
그리고 리스트의 맨 마지막은 꼭 애스터리스크(*)로 끝나야 한다.
```swift
// 예시
@available(iOS 11.0, *)
func someFunction() { }

@available(iOS 11.0, macOS 10.13, watchOS 4.0, *)
func anotherFunction() { }
```

# discardableResult
반환 값을 유의미하게 사용하지 않고 버려도 되는 함수들이 있을 때가 있는데, 이때 컴파일러 경고가 발생하지 않도록 하려면 discardableResult 속성을 함수나 메서드의 정의에 부여하면 된다.
```swift
@discardableResult
Func someFunction() { }
```
# objc
스위프트로 선언된 코드를 Objective-C의 코드에서 사용할 수 있도록 하려면 objc 속성을 사용한다.
* 중첩 타입, 제네릭 열거형 등은 objc 속성을 사용할 수 없다.
* objc 속성이 부여된 클래스는 Objective-C의 클래스를 꼭 상속받아야 한다.
* objc 속성이 부여된 클래스를 상속받는 클래스는 암시적으로 objc 속성이 부여된다.
* objc 속성이 부여된 프로토콜은 objc 속성이 부여되지 않은 스위프트의 프로토콜을 상속받을 수 없다.
* objc 속성이 부여된 프로토콜을 상속받는 프로톸ㄹ은 암시적으로 objc 속성이 부여된다.
```swift
@objc
class SomeClass {}
// 오류 - Objective-C의 클래스를 상속받지 않았습니다.

// Objective-C의 클래스를 상속받으면 암시적으로 @objc 속성이 부여됩니다.
Class AnotherClass: NSObject { }

protocol ParentProtocol {}

@objc
Protocol SomeProtocol: ParentProtocol { }
// 오류 - ParentProtocol은 objc 속성이 없습니다.
```

objc 속성이 부여된 열거형은 Objective-C 코드에서 사용할 수 있다.
다만 원시값 타입을 Int로 지정해주어야 한다. 스위프트로 작성한 각 열거형 case의 이름은 Objective-C 코드에서 Objective-C 스타일의 열거형 case 이름으로 나타낸다. 예를들어 스위프트의 Planet 열거형의 earth 케이스는 Objective-C 코드에서 PlanetEarth라는 이름으로 나타낸다.
```swift
@objc
enum Planet: Int {
    case mercury, venus, earth, mars, jupiter
    // Objective-C 이름
    // PlanetMercury, PlanetVenus, PlanetEarth, PlanetMars. PlanetJupiter
}
```
스위프트와 Objective-C의 명명 규칙이 다르기 때문에 주의해야 한다.
자동으로 변경되지 않는 이름은 수동으로 이름을 정해줘야 할 때도 있다.
objc 속성을 부여할 때 매개변수로 이름을 전달하면 해당 선언이 Objective-C 코드에서는 매개변수로 전달한 이름으로 사용한다.
다만 이름을 변경할 수 있는 선언은 클래스, 열거형, 열거형 case, 프로토콜, 메서드, 접근자, 설정자, 이니셜라이저 등이 있다.
```swift
@objc(Example)
 // Objective-C 코드에서는 ExampleClass 클래스의 이름이 Example이라고 보인다.
class ExampleClass: NSObject {
    @objc var enabled: Bool {
    // Objective-C 코드에서는 enabled 프로퍼티 이름이 isEnabled: 라고 보인다
        @objc(isEnabled) get {
            return true
        }
    }

    // Objective-C 코드에서는 print(name:) 메서드의 이름이 printWithName: 이라고 보인다.
    @objc(printWithName:)
    func print(name: String) { }

    // Objective-C 코드에서는 init(name:) 메서드의 이름이 initWithName: 이라고 보인다.
    @objc(initWithName:)
    init(name: String) { }
}
```
# nbnobjc
*  Objective-C 코드에서는 사용이 불가능하다.
* objc 속성이 부여된 메서드로 재정의할 수 없다.
* objc 속성이 요구하는 프로토콜 요구사항을 충족할 수 없다.

# testable
* 테스트를 위해 컴파일한 모듈에 정의한 내부 접근수준 정의를 공개 접근수준로 정의한 것 처럼 만들어준다.
* 외부에서 가져다 테스트할 수 있도록 부여할 수 있는 속성이다.
* 테스트를 위한 코드는 공개 접근수준과 내부 접근수준으로 testable 속성과 함께 정의한 클래스나 클래스 요소에 개방 접근수준의 접근수준처럼 접근하여 테스트할 수 있다.

# objcMembers
* Objc 속성을 부여할 수 있다.
* 정의 하나만 Objective-C 노출하려는 경우에 주로 사용한다.
* 많은 양의 정의를 노출하고자 한다면 익스첸션에 그 정의를 묶어 objc 속성을 주는 것이 좋다.
* 불필요한 곳에 objc 속성을 남용하면 바이너리크기가 커질 뿐만 아니라 성능에 영향을 미칠 수도 있다.
* 클래스나 라이브러리 크기가 클 때 모든 멤버가 Objective-C 멤버로 노출될 필요가 없다면 objcMembers를 사용한다.

# dynamicMemberLookup
* 실행중(Runtime)에 이름으로 멤버(프로퍼티 등)를 찾을 수 있다.
* 이 속성을 적용한 타입은 subscript(dynamicMemberLookup:) 서브스크립트를 정의해야한다.
* 이 속성을 적용한 타입의 인스턴스에 정확한 멤버 표현(예를 들어 점 표기법 등)에서 적절한 멤버를 찾지 못하면 서브스크립트에 매개변수로 그 멤버의 이름이 전달한 subscript(dynamicMemberLookup:) 서브스크립트가 호출된다.
* 서브스크립트의 매개변수는 키경로 혹은 멤버 이름을 모두 수용할 수 있다.
* 해당 속성을 적용한 클래스를 상속받으면 상속받은 클래스도 dynamicMemberLookup 속성이 적용된다.
* KeyPath, ReferenceWritableKeyPath 등의 타입을 매개변수로 전달받을 수 있다.
    * 멤버 이름을 ExpressibleByStringLiteral 프로토콜을 준수하는 타입의 매개변수로 전달받을 수도 있다.
* 멤버의 이름으로 멤버를 찾는 것은 실행중에 데이터가 존재할지 확신할 수 없는 상황에서 사용하기 좋다.

```swift
@dynamicMemberLookup
Struct Contacts {
    private let contacts: [String: String] = ["Ari" : "010-2222-3333",
                                       "Ara": "010-4444-55555"]
    subscript(dynamicMemberLookup member: String) -> String {
        return contacts[member] ?? "114"
    }
}
Let contacts = Contacts()

// Dynamic Member Lookup 사용
let aris = contacts.Ari

// 서브스크립트 직접 호출
let aras = contacts[dynamicMember: "Ara"]

// 찾을 수 없는 경우
let somebody = contacts.somebody
let anybody = contacts[dynamicMember: "anybody"]
```

&nbsp;

---

- 참고링크
    - [함수형 프로그래밍이란? - 1](https://mangkyu.tistory.com/111)
    - [함수형 프로그래밍이란? - 2](https://borabong.tistory.com/5)
    - [Demystifying iOS Layout](https://tech.gc.com/demystifying-ios-layout/)
    - [Main event Loop](https://developer.apple.com/library/archive/documentation/General/Conceptual/Devpedia-CocoaApp/MainEventLoop.html)
    - [iOS swift — setNeedsLayout vs layoutIfNeeded vs layoutSubviews()](https://abhimuralidharan.medium.com/ios-swift-setneedslayout-vs-layoutifneeded-vs-layoutsubviews-5a2b486da31c)
    - [[ios] setNeedsLayout vs layoutIfNeeded](https://baked-corn.tistory.com/105)
    - 스위프트 프로그래밍 3판 `548p` - `564p`
