
# TIL (Today I Learned)


12월 14일 (화)

## 학습 내용
- enum의 static
- Factory Pattern
- topViewController와 visibleViewController
&nbsp;

## 고민한 점 / 해결 방법
**[Enum의 static 메소드, 혹은 static 변수]**
* static 같은 경우에는 메모리에 data 영역에 존재한다.
* data영역은 프로그램이 실행하고 끝날 때 까지 데이터가 죽지않고 살아남아있다.
* 따라서 사용여부와 상관 없이 항상 메모리가 살아있다.
* 만국박람회 프로젝트 중에 enum을 활용하여 static 메소드와 static 변수를 묶어둔 타입들이 존재하는데, 이를 어떻게 해결하면 좋을지 고민해보자

**[Factory Pattern]**
* Factory Pattern이란?
    * 객체를 만들기 위한 프로토콜을 정의하지만, 어떤 클래스의 인스턴스를 생성할지에 대한 결정은 하위 클래스가 정하도록 하는 방법
    * 객체 생성을 서브 클래스가 하도록 처리하는 패턴
    * 즉, 객체 생성을 캡슐화할 수 있으며, 이로 인해 부모 클래스는 자식 클래스가 어떤 객체를 생성하는지 몰라도 된다.
* 구조
    * Product
        * Creator와 하위 클래스가 생성할 수 있는 모든 객체에 동일한 프로토콜를 선언한다
    * Concreate Product
        * Product가 선언한 프로토콜로 만든 실제 객체다.
    * Creator
        * 새로운 객체를 반환하는 팩토리 메서드를 선언한다.
        * 여기서 반환하는 객체는 Product 프로토콜을 준수하고 있어야 한다.
    * Concreate Creator
        * 기본 팩토리 메소드를 override 하여 서로 다른 Product 객체를 만든다.
* 언제 사용할까??
    * 만들 객체의 클래스 종류를 예측할 수 없을 때
    * 만들어야 할 객체의 하위 클래스를 명시하고 싶을 때
* 종류
    * Factory Method Pattern
    * Abstract Factory Pattern

**[topViewController와 visibleViewController는 같은 VC을 가르키는 걸까?]**

* ![](https://i.imgur.com/ghcxKC0.jpg)
* 위 그림을 보면 topViewController와 visibleViewController가 맨 앞에 같은 VC을 가르키고 있다.
* 하지만 topViewController와 visibleViewController는 반드시 같은 것은 아니다.
* 예를 들어, 하나의 VC를 모달창으로 나타낸다면 visibleViewController는 모달 VC을 가르킬 것이고, topViewController는 변하지 않는다.

---

- 참고링크
    - https://theswiftdev.com/comparing-factory-design-patterns/
    - https://daheenallwhite.github.io/design%20pattern/2019/05/07/Factory-Pattern/
    - https://velog.io/@ryan-son/%EB%94%94%EC%9E%90%EC%9D%B8-%ED%8C%A8%ED%84%B4-Factory-pattern-in-Swift
    - https://kingso.netlify.app/posts/boostcourse-view-controller/
    - https://stackoverflow.com/questions/33395463/in-uinavigationcontroller-what-is-the-difference-between-topviewcontroller-visi
