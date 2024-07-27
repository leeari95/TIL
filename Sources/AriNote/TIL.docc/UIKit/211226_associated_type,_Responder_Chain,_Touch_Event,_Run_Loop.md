# 211226 associated type, Responder Chain, Touch Event, Run Loop
# TIL (Today I Learned)


12월 26일 (일)

## 학습 내용
- associated type
- Responder Chain
- Touch Event
- Run Loop 

&nbsp;

## 고민한 점 / 해결 방법

**[associated type]**

* 프로토콜에서 사용되는 제네릭 Placeholder의 느낌이다.
* associated type은 원래 typealias였는데, Swift 2.2부터 Associated Type이란 키워드로 바뀌었다.
```swift
protocol Test {
    associatedtype MyType
    var name: MyType { get }
}
```
* 만약 정의된 프로퍼티가 String이나 다른 타입이 될 수 있는 여지가 있다면 위 예제처럼 associatedtype 키워드를 사용하면 된다.
    * 프로토콜을 채택하여 구현할 시에는 MyType이 아니라 String, Int 등등 원하는 타입으로 정의하여 구현해줄 수 있게 된다.
* associated type은 제약을 줄 수도 있다.
```swift
protocol Test {
    associatedtype MyType: Equatable
    var name: MyType { get }
}
```
* 이렇게 제약사항을 걸어주면 name이 무슨 타입인진 모르겠지만 Equatable을 준수하는 타입이어야 한다고 제약사항을 걸어주게 되는 것이다.
* 따라서 Associated Type은 진짜 타입을 주는 것이 아니라 타입의 견본을 주는 것이라고 볼 수 있다.
    * 사용할 실제 타입은 프로토콜이 적용될 때 까지 지정되지 않으니 유용하게 쓸 수 있다.

---

**[Using Responders and the Responder Chain to Handle Events]**

* 앱은 responder 객체를 이용하여 이벤트를 핸들링한다.
* responder 객체는 UIResponder클래스의 인스턴스이고, 공통적으로 UIView, UIViewController, UIApplication 객체를 서브클래스 한다.
* Responder는 이벤트 데이터를 받거나 처리하고, 아니면 다른 Responder 객체로(해당 이벤트를 해결할 수 있는)전달해야 한다.
* 앱이 이벤트를 받으면 UIKit은 가장 적절한 first responder에게 이벤트를 보낸다.
* 처리되지 않은(Unhandled)이벤트는 responder chain에 의해서 resopnder객체로 전달된다.
* ![](https://i.imgur.com/7FTLl6M.png)
* 만약 텍스트필드가 이벤트를 핸들링하지 않으면, UIKit은 이벤트를 상위 UIView로 보낸다.
* 윈도우까지 이벤트가 전달됐음에도 이벤트를 핸들링할 수 없으면 이벤트는 UIApplication까지 전달되며, and possibly to the app delegate if that object is an instance of UIResponder and not already part of the responder chain….??

**[이벤트의 first responder 결정하기]**

> UIKit은 이벤트의 타입에 따라서 FirstResponder 객체를 지정한다.

* **Touch event** 터치가 일어난 뷰
* **Press event** 초점을 갖는 객체
* **Shake-motin event** 직접 지정했거나 UIKit이 지정한 객체
* **Remote-Control event** 직접 지정했거나 UIKit이 지정한 객체
* **Editing menu messages** 직접 지정했거나 UIKit이 지정한 객체

> Note
> 가속 움직임, 자이로스콥, 자력 탐지와 같은 모션 이벤트는 리스폰더를 따르지 않는 대신 코어모션이 지정된 객체에 이런 이벤트를 전달한다.

* 컨트롤은 액션 메세지를 사용해 직접 관련이 있는 목표 객체와 소통한다.
* 사용자 컨트롤과 상호작용하면 컨트롤은 목표 객체에 액션메세지를 보낸다.
* 액션 메세지는 이벤트가 아니다.그러나 여전히 Responder chain을 이용한다.
* 컨트롤러 목표 객체가 `nil`일 때 `UIKit`은 목표 객체로 부터 시작해 메뉴는 `cut(_:)`, `copy(_:)`, `paste(_:)`와 같은 이름을 가진 메소드를 구현한 Responder 객체를 탐색하기 위해 앞서 설명한 동작을 사용한다.
* GestureRecognizer는 터치와 프레스 이벤트를 뷰가 받기전에 받는다.
* 만약 뷰의 `GestureRecognizer`가 터치의 연속을 인식하는 것에 실패한다면, `UIKit`은 뷰에 터치를 보낸다.
* 만약 뷰가 터치를 처리하지 않는다면 `UIKit`은 터치를 `Responder chain`으로 전달한다.
* GestureRecognizer의 이벤트 처리와 관련한 내용은 [Handling UIKit Gestures](https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/handling_uikit_gestures)를 살펴보기 바란다.

**[어떤 Responder가 터치 이벤트를 가져야하는지 결정하기]**

* UIKit은 터치 이벤트가 어디에서 발생했는지 결정하기 위해 view-based hit testing을 사용한다.
* 구체적으로 UIKit은 뷰 계층구조에서 뷰 객체의 bounds에 터치 위치를 비교한다.
* UIView의 `hitTest(_:with:)` 메소드는 뷰 계층구조를 따라 터치이벤트에 대한 First Responder가 될 수 있는 특정 터치를 포함한 가장 깊은 하위뷰를 탐색한다.

> Note
> 만약 터치 위치가 뷰의 bounds 밖에 있다면, `hitTest(_:with:)` 메소드는 해당 뷰와 그 뷰의 모든 하위뷰를 무시한다. 결과적으로 뷰의 `clipsToBounds` 속성이 `false`일 경우 뷰 bounds의 하위뷰 밖은 터치가 발생했다고 하더라도 반환되지 않는다. hit-testing 동작에 대한 더 많은 정보는 `UIView`에서 [`hitTest(_:with:)`](https://velog.io/@panther222128/Responder-Chain#:~:text=https%3A//developer.apple.com/documentation/uikit/uiview/1622469%2Dhittest) 메소드를 살펴보기 바란다.

* 터치가 발생하면 `UIKit`은 `UITouch`객체를 생성하고 이를 뷰에 연관시킨다.
* 터치 위치 혹은 다른 파라미터가 변경되면 `UIKit` 같은 `UITouch` 객체에 새로운 정보를 업데이트 한다.
* 변경되지 않는 속성은 오직 View이다.
    * 터치 위치가 기존 뷰 밖으로 이동하더라도 터치의 뷰 속성에서 값은 변경되지 않는다.
* 터치가 끝나면 `UIKit`은 `UITouch` 객체를 해제한다.

**[Responder Chain을 바꾸기]**

* Responder 객체의 다음 속성을 override하므로써 Responder Chain을 변경할 수 있다. 이렇게 할 경우 다음 Responder는 반환한 객체가 된다.
* 많은 `UIKit` 클래스가 이미 이 속성을 override하고 있으며 특정 객체를 반환한다. 아래 내용을 포함한다.
    * `UIKit` 객체. 만약 View가 ViewController의 root View이면, 다음 Responder는 ViewController이다. 그렇지 않다면 다음 Responder는 뷰의 Super view이다.
    * `UIViewController` 객체
        * 만약 뷰 컨트롤러의 뷰가 윈도우의 root View이면 다음 Responder는 Window 객체다.
        * 만약 ViewController가 다른 뷰 컨트롤러에 의해 제시되었었다면, 다음 Responder는 해당 뷰 컨트롤러를 제시한 ViewController이다.
    * `UIWindow` 객체. 윈도우의 다음 Responder는 `UIApplication` 객체다.
    * `UIApplication` 객체. 다음 리스폰더는 AppDelegate이다. AppDelegate가 `UIResponder`의 인스턴스일 때에만 그렇다. View, ViewController, App 객체 자체일 때는 그렇지 않다.

---

**[Touches, Presses, and Gestures]**

> gesture recognizers에 있는 앱의 이벤트 처리 로직을 캡슐화하므로써 앱에서 해당 코드를 재사용할 수 있게 한다.

* 표준 `UIKit` 뷰와 컨트롤을 사용해 앱을 빌드하고 있다면, `UIKit`은 자동으로 터치 이벤트(멀티 터치 포함)을 자동으로 처리한다.
* 그러나 컨텐츠를 보여주기 위한 커스텀 뷰를 사용하는 경우 뷰에서 발생하는 터치 이벤트 모두는 직접 처리해야한다.
* 터치이벤트를 직접 처리하는 방법은 두가지가 있다.
    * 터치를 추적하기 위해 gesture recognizers를 사용한다. Handling UIKit Gestures를 참고바란다.
    * `UIView` 서브 클래스에서 직접 터치를 추적한다 Handling Touches in Your View를 참고바란다.

---

**[Handling UIKit Gestures]**

> Gestrue recognizer를 사용하는 것은 뷰에서 발생하는 Touch나 Press 이벤트를 다룰 수 있는 가장 간단한 방법이다. 어떤 뷰든간에 한개 혹은 여러개의 Gesture에 대한 Recognizer를 붙일 수 있다. Gestrue recognizer는 뷰 위에서 발생하는 일련의 패턴이 존재하는 이벤트들 (Double-Tap, Swipe, Pinch 등등)을 처리하기 위해 Target-Action 패턴을 사용하고 이벤트가 발생하면 Target객체에 이러한 사실을 전달하여 해당 이벤트를 처리할 수 있는 액션 메소드를 호출한다.

![](https://i.imgur.com/TFTEfOX.png)

* Gestrue Recognizer에는 두 종류가 있다.
    * 불연속 Gestrue Recognizer
        * 이벤트를 인식한 후 액션 메소드를 한번만 호출
        * UITapGestrueRecognizer
    * 연속 Gestrue Recognizer
        * 최초 이벤트 인식 후 이벤트의 변화를 추적하며 액션 메소드를 변화에 맞춰 호출
        * UIPanGestureRecognizer

**[Configuring a Gesture recognizer]**

* Gesture recognizer 구성 단계
    * 스토리 보드에서 Gesture Recognizer를 뷰 위에 드래그하여 올려놓는다.
    * 액션 메소드를 구현한다.
    * 액션 메소드와 Gesture Recognizer를 연결한다.
* 코드로 이를 구현할 때는 `addGestureRecognizer(_:)`를 사용한다.

**[Responding to Gestures]**

* 액션 메소드를 통해 Gesture를 적절히 처리해준다.
* 위에서 언급했듯 불연속적 Gesture는 버튼과 같이 한번의 Gesture에 대해 액션 메소드는 한번만 호출된다.
* 연속적 Gesture에 대해서는 이벤트를 추적하고 이에 맞게 액션 메소드 여러번 호출된다.
* `UIGestureRecognizer`에는 `state`라는 프로퍼티가 있고 이를 활용하여 액션 메소드를 구성할 수 있다.
* 연속 Gesture Recognizer에선 `.began`, `.changed`, `.ended`, `.cancelled`를 사용할 수 있다.
    * 예를 들어 `.changed`상태에선 뷰의 속성을 임의로 변경시키고, `.ended`에서는 이를 확정 짓는 등의 행위를 할 수 있다.

---

**[Run Loop]**

* Global Thread에선 Timer가 동작하지 않는 이유는 뭘까?
    * 해당 답을 찾기 위해 Run Loop에 대해서 공부해보자.
* Run Loop가 뭘까?
    * Run Loop 객체는 소켓, 파일, 키보드 마우스 등의 입력소스를 처리하는 이벤트 처리 루프다.
    * 쓰레드가 일해야 할 때는 일하고 일이 없으면 쉬도록 하는 목적으로 고안되었다.
    * Run Loop 입장에서 Timer는 입력이 아닌 특수한 유형이지만 Timer의 이벤트 또한 처리한다.
* 요약 하자면 Run Loop는 입력 소스를 처리하는 `이벤트 처리 루프`이고, `Timer` 또한 같이 처리한다는 것 같다.

**[Thread와 Run Loop]**

* Run Loop는 어디에 사용될까?
    * Thread의 외부 입력 소스 및 Timer를 처리할 때 사용된다.
* 중요 핵심 단어 Thread
    * Thread는 모두 각자의 Run Loop를 가질 수 있다.
    * Thread를 생성할 때 Run Loop가 자동으로 생성된다.
    * 다만 Run Loop는 자동으로 실행되지 않는다.
* 자동으로 생성 되는 것은 맞지만 자동으로 실행되진 않는다.
* Run Loop 실행에 대한 관리는 프로그래머의 몫이다.
    * Main Run Loop는 예외이다.
    * ![](https://i.imgur.com/OFvM1l2.png)
    * Main Thread는 애플리케이션이 실행될 때 프레임워크 차원에서 자동으로 RunLoop를 설정하고 실행한다. 이를 Main RunLoop라고 한다.
* 따라서 Thread를 생성했는데 이 Thread가 입력소스나 Timer를 처리해야 한다면, `Run Loop를 직접 얻어서 실행`시켜 주어야 한다.
* 내가 생성한 Thread에 대한 Run Loop를 생성해서 얻으려면 다음 메소드를 이용한다.
```swift
class var current: RunLoop { get }
```
* 현재 실행중인 쓰레드 내에서 다음과 같이 작성하면 현재 Thread에 대한 RunLoop를 얻을 수 있다.
```swift
let runLoop = RunLoop.current
```
* 그러나 내가 RunLoop를 얻는 것 만으로는 입력 소스 및 타이머를 처리해주진 않는다.
* Run이라는 것을 통해 RunLoop를 직접 실행 시켜주어야 하는데, 이것에 대해 알기 위해 Run Loop가 어떻게 작동하는지 알아보자

**[RunLoop의 작동 원리]**

* RunLoop는 루프 수행할 때 총 2가지 Event Source를 수신한다.
    * Input Source
        * 다른 Thread나 Application으로부터 온 비동기 이벤트를 전달한다.
    * Timer
        * 예약된 시간 또는 반복 간격으로 발생하는 동기 이벤트를 전달한다.

![](https://i.imgur.com/vfgJdur.png)

> **Input Source** 핸들러에 비동기 이벤트를 전달하고 runUntilDate 메소드가 종료
> **Timer Source** 핸들러에 이벤트를 전달하지만 런 루프를 종료하진 않음
> 런 루프는 동작에 대해 노티피케이션을 생성
> 등록된 런 루프 옵저버를 통해 알림을 수신하고 추가 처리를 위해 스레드에 구현하는 것이 가능

* 왼쪽 그림에서 노란색 루프를 한바퀴 도는 작업이 한번의 실행이라고 생각했을 때,
    * RunLoop는 한번의 실행 동안 내 Thread에 도착한 이벤트를 받고, 이에 대한 핸들러를 수행하는 객체
* 루프라고 해서 RubnLoop가 자체적으로 계속 이벤트가 들어오나 안들어오나 실행을 반복 한다고 생각할 수 있겠지만, RunLoop는 내부적으로 반복 실행을 하지 않는다.
* 한번 Event Source를 읽고 전달하는 실행이 끝나면, 그대로 대기한다.
    * 그 다음 Event Source가 들어와도 RunLoop는 대기 상태이기 때문에 Event를 받을 수 없는 것이다.
* 따라서 Thread 내에서 프로그래머가 명시적으로 for, while 등을 이용해 RunLoop를 반복 실행 시켜주어야 한다.

**[RunLoop를 실행시키는 방법]**

* 아까 Global Thread에서 왜 Timer가 실행되지 않은지에 대해 원인을 정리해보자면,
    * Global Thread를 손수 생성했고
    * 내가 생성한 Global Thread의 RunLoop는 실행되고 있지 않기 때문에,
    * Timer를 작동 시켰지만, 내 Thread의 RunLoop가 이 Event를 처리하지 못해서 실행이 안됐던 것이였다.
* 따라서 Global Thread에서 RunLoop를 실행 시키는 방법은 아래 메소드를 활용하는 것이다.
* ![](https://i.imgur.com/jOKErSA.png)
* Loop를 Running 시키는 방법 중 4가지 메소드를 알아보자
    * `run()`
        * receiver를 영구 루프에 넣고, 이 기간 동안 모든 부착된 Input Sourcer의 데이터를 처리한다.
    * `run(mode:before:)`
        * 루프를 한 번 실행하여 지정된 모드에서 지정된 날짜까지 input을 blocking한다.
            * RunLoop Mode에 대해서 참고해보자.
    * `run(until:)`
        * 지정된 날짜까지 루프를 실행하고, 그 기간 동안 루프는 부착된 모든 Inptu Source들의 데이터를 처리한다.
        * 보통 RunLoop를 반복 실행할 때 이 메소드를 사용한다.
        * 만약 더이상 RunLoop가 필요없어지면 아래 코드 예제의 while문을 false로 해주어 RunLoop가 더이상 작동하지 않도록 설정하면 된다.
        ```swift
        while isRunning {
            runLoop.run(until: Date().addingTimeInterval(0.1))
        }
        ```
    * `acceptInput(forMode:before:)`
        * 지정된 날짜까지 또는 지정된 모드에 대해서만 입력을 허용하여 루프를 한번만 실행한다.

**[언제 RunLoop를 사용할까?]**

* Input Source를 통해 다른 Thread와 통신하는 경우
* Timer를 사용해야 하는 경우
* Perform Selector Source를 사용해야 하는 경우
* 주기적인 일을 계속 수행해야 하는 경우
* 

---

- 참고링크
    - https://taekki-dev.tistory.com/34
    - https://zeddios.tistory.com/382
    - https://seizze.github.io/2019/11/26/iOS%EC%9D%98-Responder%EC%99%80-Responder-Chain-%EC%9D%B4%ED%95%B4%ED%95%98%EA%B8%B0.html
    - https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/using_responders_and_the_responder_chain_to_handle_events
    - https://velog.io/@panther222128/Touches-Presses-and-Gestures#:~:text=0-,https%3A//developer.apple.com/documentation/uikit/touches_presses_and_gestures,-%22Encapsulate%20your%20app%27s
    - https://baked-corn.tistory.com/130
    - https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/implementing_a_custom_gesture_recognizer/implementing_a_continuous_gesture_recognizer?changes=_4
    - https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Multithreading/RunLoopManagement/RunLoopManagement.html
    - https://babbab2.tistory.com/68
