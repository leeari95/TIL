# 211227 Responder Chain, Touch Event, DispatchSemaphore
# TIL (Today I Learned)


12월 27일 (월)

## 학습 내용
- Responder Chain, Touch Event 활동학습
- 은행창구매니저 STEP2 리뷰
- 은행창구매니저 STEP3 설계과정

&nbsp;

## 고민한 점 / 해결 방법
**[활동학습 내용 정리]**

* Shake-motin event가 발생했을 때 제스처를 처리하는 곳은 UIApplicationDelegate가 될 것 같다.
* Remote-Control event
    * 에어팟 버튼 기능, 이어폰의 리모콘 기능
* UIResponder 
    * Resopnder하고 handling 하기 위한 추상 클래스
    * 터치 이벤트를 핸들링하기 위한 메소드가 있다.
    * ![](https://i.imgur.com/zgn6a6I.png)
    * 실제로는 위 메소드를 UIView에서 override해서 주로 사용한다.
* UIEvent
    * 사용자의 인터렉션을 표현해주는 객체
    * 앱은 상당히 다양한 종류의 이벤트를 받을 수 있다.
    * 이벤트를 받아서 처리할거냐 무시할거냐는 프로그래머의 몫
* UITouch
    * 사용자가 터치한 위치, 사이즈, 움직임, 세기 까지 나타내는 객체
    * 이벤트 핸들링을 위해서 리스폰더 객체 안에 UIEvent와 함께 전달된다.
* 제스처는 왜 필요할까?
* 제스처 인식기에서 행동을 인식하여 일을 수행할 수 있는 방식 중 타깃-액션 방식이 있다.
* 터치이벤트를 받았다고 Responder를 하는 것은 아니다.
* 공식문서를 참조할 때 See Also를 통해 관련문서를 확인하자.
    * 하단에 `{}` 표시가 되어있는 링크는 예제코드가 있다.

---

* **Q1 : iOS 환경에서 사용자의 터치 이벤트를 알아채거나 제어할 수 있는 방법의 종류를 알아봅시다**
* 터치 이벤트를 알아채는 객체
    * UIResponder
* 사용자의 터치 이벤트를 제어할 수 있는 방법
    * Responder Recognizer에서 행동을 인식하여 일을 수행하는 방식-> Taget-Action, Delegate
*  **Q2 : iOS 환경에서 사용자가 일으킬 수 있는 이벤트의 종류는?**
    * https://developer.apple.com/documentation/uikit/uievent/eventtype
    * https://developer.apple.com/documentation/uikit/uievent/eventsubtype
    * case touches
        * 이벤트는 화면의 터치와 관련이 있습니다.
    * case motion
        * 이벤트는 사용자가 기기를 흔들 때와 같이 기기의 움직임과 관련이 있습니다.
    * case remoteControl
    * 이벤트는 원격 제어 이벤트입니다. 원격 제어 이벤트는 장치에서 멀티미디어를 제어하기 위한 목적으로 헤드셋 또는 외부 액세서리에서 수신된 명령으로 발생합니다.
    * case presses
        * 이벤트는 물리적 버튼의 누름과 관련이 있습니다.
* **Q3 : 뷰 위에 텍스트 필드가 있고 텍스트 필드 위에 탭 제스쳐 인식기가 있는 상황에서 각 상황에서 사용자가 텍스트 필드 위를 탭 했을 때 어떤어떤 객체가 어떤 메서드를 통해 반응하나요?**
> Text Field Properties

|USER INTERACTIVE|	CONTROL STATE|
| :--------: | :--------: | 
|true|	enabled|
|false|	enabled|
|true|	disabled|
|false|	disabled|

* ![](https://i.imgur.com/LQW9zWA.png)

* MyField의 `touchesBegan(_:with:)`가 먼저 반응하고 ViewController의 `didTap(_:)`이 반응한 후 My Field의 `touchesCancelled(_:with:)`가 호출된다.
* MyView의 `touchesBegan(_:with:)`가 두번 호출되고, 이후 MyView의 `touchesEnded(_:with:)`가 두번 호출된다.
* MyView의 `touchesBegan(_:with:)`가 두번 호출되고, 이후 MyView의 `touchesEnded(_:with:)`가 두번 호출된다.
* MyView의 `touchesBegan(_:with:)`가 두번 호출되고, 이후 MyView의 `touchesEnded(_:with:)`가 두번 호출된다.

* **Q4 : Responder Chain과 Gesture Recognizer는 이벤트 제어에서 상호간 상관관계일까요? 별개관계일까요? 그렇게 생각한 이유는 무엇인가요?**
    * 상관관계도 아니고 그렇다고 별개관계라고 보기에도 애매한 존재이다.

---

**[DispatchSemaphore]**

* Semaphore란?
    * 공유자원에 대한 접근을 막아주는 것
    * 공유자원이 뭐일지는 만들기 나름이다.
* DisPatchSemaphore는 디스패치에 대한 Semaphore이다.
* 디스패치는 Task라고 볼 수 있다.
    * Task == Closure
* DispatchSemaphore에 value 파라미터를 2로 준다면 Race Condition이 발생할 가능성이 있는 것인가?
    * 은행 창구 매니저 프로젝트로 실험해보았는데, value의 수가 적고, 접근할 공유자원의 수도 적다면 Race Condition이 발생할 수 있는 가능성이 적은 편이다.
    * 또한 공유자원에 접근을 하지 않는다면 DispatchSemaphore의 value가 1이 아니더라도 Thread-Safe하지 않은 것이지, 무조건 Race Condition이 발생한다고 볼 수는 없다. 발생 가능성이 있다고 보면 될 것 같다.
* 프로젝트에 써먹어보려고 했는데 오늘 삽질해본 결과 DispatchSemaphore의 value가 1이 아니라 2라면 Race Condition 발생할 수 있는 가능성이 생기는... 문제점을 발견하게 되서... 다른 방법을 찾아봐야할 것 같다.

---

**[델마의 조언]**
* 개발할 때 염두해야할 것
    * 기능을 선택할 때에는 비슷한 기능은 무엇이 있는지 탐색하기.
    * 선택한 기능이 다른 기능보다 나은점은 뭐가 있는지 생각해보기
    * 기능을 찾아 사용할 때 선택한 이유를 생각해보기
* Core Foundation vs Foundation
    * 코어 파운데이션에 있는 기능은 Foundation에서 래핑하여 구현되어져있다.
    * 보통 앱개발을 할 때에는 Foundation의 기능 없이 개발하기에는 어려움이 있기 때문에, Core Foundation에 내장되어있는 기능보다는 Foundation에 내장되어있는 기능을 사용하는 것을 선호하는 편이다.
* 다음 스텝을 지레짐작해서 개발하지 말자
    * 그냥 요구사항에 맞춰 최소한의 기능을 빨리 만들어보자.
    * 시도하고 실패하고 돌아가는 과정을 반복하며 개선해나가는 방향으로 진행하자.

---

- 참고링크
    - [https://stackoverflow.com/questions/3773776/corefoundation-vs-foundation](https://stackoverflow.com/questions/3773776/corefoundation-vs-foundation)
    - [https://stackoverflow.com/questions/20582495/core-foundation-vs-foundation-or-core-foundation-foundation](https://stackoverflow.com/questions/20582495/core-foundation-vs-foundation-or-core-foundation-foundation)
