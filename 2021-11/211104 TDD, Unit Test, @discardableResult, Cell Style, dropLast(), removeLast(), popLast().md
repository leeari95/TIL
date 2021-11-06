# TIL (Today I Learned)

11월 4일 (목)

## 학습 내용
오늘은 TDD와 Unit Test에 대한 활동학습을 진행하였다. Queue와 Stack구조를 간단히 알아가는 시간을 가지고 나서 Stack을 TDD 방식으로 구현해나가는 활동학습을 진행했다. 제리랑 같은 팀이 되서 구현하다가 여러가지 방법들로 구현해나가는 방법을 이야기하다가 문법 복습도 하게되었고, 다른 팀원들이 구현한 것도 나누면서 유익한 시간을 보냈다. 이후에는 제이티와 함께 피드백 온것을 고쳐보고 고민해보는 시간을 가지고 해산했다.

&nbsp;

## 문제점 / 고민한 점
- @discardableResult이 뭐야?
- TDD 방식은 왜 필요할까? 테스트로 어떤 이점을 가져올 수 있을까?
- dropLast(), removeLast(), popLast() 다 같은일을 하는 것 같은데 차이점이 뭐였지?
- Cell의 style 종류에 대해서
- TableView에서 터치시 셀이 커지고 작아지는 기능을 구현하는데 예상치 못한 nil이 발생하였다며 제대로 동작하지가 않는다.
    ![](https://i.imgur.com/d9lzJpt.png) 


&nbsp;
## 해결방법
- `@discardableResult` 버릴 수 있는 결과라는 뜻이다. 결과를 return 하는데 이 결과가 필요 없는 경우도 있을 때, 그럴 때 warning을 보고싶지 않을 때 주로 사용한다.
- 테스트를 항상 통과하면서 코드를 작성해나가면 당연히 더 안전한 코드 작성할 수 있고, 테스트를 통과하는 코드를 작성하기 위해 재사용성과 의존성에 대해서 고민하여 의존성이 낮은 코드를 작성할 수 있다. 다만 개발 속도가 느리다는 단점이 있다. 모든 돌 다리를 두드려보고 건너려먼 당연히 안전함은 보장되겠지만 매번 그 과정이 있다면 당연히 진행속도는 저하될 것이다.
- `dropLast()` 원본값에는 영향을 미치지 않고 SubString 또는 Slice 타입으로 반환해준다.
    `removeLast()` 컬렉션 끝에 위치한 요소를 제거하고 반환한다.
    `popLast()` 컬렉션 마지막 요소를 제거하고 반환하는데, 제거하지 못한다면 nil을 반환한다.
    ```swift
    func dropLast(_ k: Int) -> ArraySlice<Element>
    @discardableResult mutating func removeLast() -> Element
    mutating func popLast() -> Element?

    ```
- `Custom` 기본 스타일이며 개발자가 직접 UI 요소를 넣어서 사용할 수 있다
- ![](https://i.imgur.com/YRXv2M8.png)

    `Basic` TextView와 ImageView가 있는 심플한 스타일
- ![](https://i.imgur.com/Qz9CViB.png)
  
  `Right Detail` Basic에서 Defail Text Label이 추가된 형태이며 Defail Text Label 부분이 오른쪽 정렬 되어있다.
- ![](https://i.imgur.com/20PqndH.png)
  
  `Left Detail` Image View를 포함하지 않은 형태이며 어느 한 기준선에서 Title Label은 오른쪽 정렬이, Detail Label은 왼쪽 정렬이 되어있다.
- ![](https://i.imgur.com/wJqPFtv.png)
  
  `subtitle` Image View를 포함하고 있으며 비교적 큰 사이즈의 Title Label과 바로 아래 작은 Detail Label을 가능 형태이다.
- 제이티와 피드백 관련 의논을 마치고 혹시나해서 물어봤는데 바로 해결할 수 있는 방법을 찾아줬다... 고마워요...
- ![](https://i.imgur.com/w8E3Nue.png)
  
  해당 부분에서 tableView가 스토리보드와 연결이 안되어있어서 생기는 문제였다.. 다음부턴 같은 에러가 뜬다면 스토리보드와 잘 연결되어있는지 확인해보자!

&nbsp;

## 공부내용 정리
<details>
<summary>TDD</summary>
<div markdown="1">

[TDD]
> 테스트 주도 개발(Test-Driven Development TDD)은 매우 짧은 개발 사이클을 반복하는 소프트웨어 개발 프로세스 중 하나이다. 개발자는 먼저 요구사항을 검증하는 자동화 된 테스트 케이스를 작성한다. 그런 후에 그 테스트 케이스를 통과하기 위한 최소한의 코드를 생성한다. 마지막으로 작성한 코드를 표준에 맞도록 리팩토링한다. -위키백과

테스트 주도 개발을 말 그대로 개발을 하는데에 있어서 테스트가 주가 된다는 하나의 개발 방법론이다. 먼저 테스트를 하면서 코드를 작성하고 그 후에 본 코드를 구현하는 방식이다. 테스트를 거친 후에 코드를 작성한다면 추후에 신경 써줘야할 많은 부분들에 대해서 해결을 하면서 코드를 작성할 수 있겠다.

![](https://i.imgur.com/b5milZI.jpg)


하지만 TDD를 언제나 고집하기에는 번거롭고 생산성이 떨어지는 측면도 있다. 또한 이미 프로그램이 만들어져있는 상황에서 TDD를 진행하는 것은 단연 무리가 있다. 이유는 테스트 코드를 염두해 두지 않고 무턱대고 코드부터 작성하게 되면 테스트가 불가능한 코드를 작성하게 될 가능성이 높아진다. 

# TDD Cycle

![](https://i.imgur.com/Cwp6VI8.jpg)


TDD는 실패 - 성공 - 리팩토링의 짧은 주기를 반복하여 좋은 코드를 도출해내는 방식이다.
* Red 실패하는 테스트를 작성하는 구간
* Green 실패한 테스트를 통과하기 위해 최소한의 변경을 하여 테스트에 성공하는 구간
* Refactor 테스트의 성공을 유지하면서 코드를 더 나은 방향으로 개선해나가는 구간

# TDD의 장단점
TDD는 높은 퀄리티의 소프트웨어를 보장한다
* 에러나 버그가 발생하지 않는 코드를 작성할 수 있다
* 추가적인 요구사항이 있을 때 손쉽게 그 요구사항을 반영할 수 있다
* 유지보수에 용이하다

테스트를 항상 통과하면서 코드를 작성해나가면 당연히 더 안전한 코드 작성을 할 수 있다.
테스트를 통과하는 코드를 작성하기 위해 재사용성과 의존성에 대해서 고민하여 의존성이 낮은 코드를 작성할 수 있다.
그러나 치명적인 단점이 있는거 그건 개발 속도이다. 모든 돌 다리를 두드려보고 건너면 당연히 안전함은 보장되겠지만 매번 그 과정이 있다면 당연히 진행속도는 저하될 것이다.




</div>
</details>
<details>
<summary>Unit Test</summary>
<div markdown="1">

유닛테스트는 다른 말로 단위 테스트라고 하는데, 하나의 함수, 메서드를 기준으로 독립적으로 진행되는 가장 작은 단위의 테스트이다. 즉, 메서드를 하나하나 테스트 하는 것과 같은 맥락이라고 볼 수 있다.

왜 필요한가?
프로그램을 개발할 때 분명히 빌드를 하며 제대로 동작하는 것을 확인 하고 커밋을 할텐데? 오히려 테스트 코드를 작성하는 시간이 더 오래걸릴 것 같아 비효율적이라고 생각했다.
하지만 이미 많은 기업에서 유닛테스트를 적용하고 있다.

1. 각각의 모듈을 부분적으로 확인할 수 있어 어떤 묘듈에서 문제가 발생하는지 빠른 확인이 가능
2. 전체 프로그램을 빌드하는 대신 유닛 단위로 빌드해 확인하므로 시간 절약

F.I,R.S.T 단위 테스트 원칙
* Fast 유닛 테스트는 빨라야 한다.
* Isolated 다른 테스트에 종속적인 테스트는 절대로 작성하지 않는다
* Repeatable 테스트는 실행할 때마다 같은 결과를 만들어야 한다
* Self-validation 테스트는 스스로 결과물이 옳은지 그른지 판단할 수 있어야한다. 특정 상태를 수동으로 미리 만들어야 동작하는 테스트 등은 작성하지 않는다.
* Timely 유닛 테스트는 프로덕션 코드가 테스트를 성공하기 직전에 구성되어야 한다. 테스트 주도 개발(TDD) 방법론에 적합한 원칙이지만 실제로 적용되지 않는 경우도 있다.

테스트가 이루어 지는 방식

func testArraySorting() {
    let input = [1, 7, 6, 3, 10]
    let expectation = [1, 3, 6, 7, 10]

    let result = input.sorted()

    XCTAssertEqual(result, expectation)
}

예상값과 결괏값을 비교하는 식으로 진행된다.

테스트가 가능한 코드란?


## XCTest
유닛 테스트, 퍼포먼스 테스트, UI 테스트를 만들고 실행하는 프레임워크다. 

## XCTestCase
추상 클래스인 XCTest의 하위 클래스로, 테스트를 작성하기 위해 상속해야 하는 가장 기본적인 클래스이다. XCTest는 테스트를 위한 프레임워크의 이름이기도 하고, 테스트에서 가장 기본이 되는 추상 클래스의 이름이기도 하다.
해당 클래스를 상속받은 클래스에서는 test에서 사용되는 다양한 프로퍼티와 메서드를 사용할 수 있다.

## setUpWithError()
각각의 test case가 실행되기 전마다 호출되어 각 테스트가 모두 같은 상태와 조건에서 실행될 수 있도록 만들어줄 수 있는 메서드다.

## tearDownWithError()
각각의 test 실행이 끝난 후마다 호출되는 메서드. 보통 setUpWithError()에서 설정한 값들을 해제할 때 사용된다.

## 호출 순서

![](https://i.imgur.com/NfLv9ZU.png)


## testExample()
test로 시작하는 메서드들은 작성해야 할 test case가 되는 메서드다. 테스트할 내용을 메서드로 작성해 볼 수 있다. 메서드 네이밍은 무조건 test로 시작되어야 한다.

## testPerformanceExample()
성능을 테스트해보기 위한 메서드다. XCTestCase의 measure(block:)라는 메서드를 통해 성능을 측정하게 된다.


# 테스트 포맷
테스트 포맷은 given - when - then 구조로 작성하는 것이 좋다.
* Given : 필요한 vlaue들을 셋팅
* When 테스트 코드 실행
* Then 결과 확인

# Code Coverage 확인하기
![](https://i.imgur.com/esc6RBo.png)
![](https://i.imgur.com/46gsLiZ.png)
![](https://i.imgur.com/uViiobs.png)
![](https://i.imgur.com/XFdjM4B.gif)

    
    
# Test Double
테스트를 진행하기 어려운 경우 이를 대신하여 테스트를 진행할 수 있도록 만들어주는 객체를 말한다.
* 테스트 대상 코드를 격리한다
* 테스트 속도를 개선한다
* 예측 불가능한 실행 요소를 제거한다
* 특수한 상황을 시뮬레이션한다
* 감춰진 정보를 얻어낸다

## 종류
테스트 더블에는 Dummy, Stub, Fake, Spy, Mock 등이 있다. 테스트 더블마다 역할이 다르지만 명확한 기준으로 구분해서 사용하는 것은 아니다.


### Dummy (모조의 ,가짜의)
가장 기본적인 테스트 더블이다. 어떤 기능이 구현되어 있지 않은 단지 인스천화된 객체로 사용되기 때문에 Dummy의 메서드는 정상적으로 동작하지 않는다. 객체를 전달하기 위한 목적으로 주로 사용된다.

### Stub (쓰다 남은 물건의 토막, 남은 부분)
Dummy가 실제로 동작하는 것처럼 만들어 실제 코드를 대신해서 동작해주는 객체다. 테스트가 곤란한 부분의 객체를 도려내어 그 역할을 최소한으로 대신해 줄 만큼만 간단하게 구현되어 있다.

### Fake
Stub보다 구체적으로 동작해서 실제 로직처럼 보이지만 실제 앱의 동작에서는 적합하지 않은 객체를 말한다. 로직 자체는 실제 앱의 코드와 비슷하지만 그 동작을 단순화하여 구현한 객체를 Fake 객체라고 한다.

### Spy
Stub의 역할을 가지면서 호출된 내용에 대한 방법 혹은 과정 등 약간의 정보를 기록하는 객체다. 예를 들어 호출되었는지 몇 번 호출되었는지 등에 대한 정보를 기록할 수 있다.

### Mock
실제 객체와 가장 비슷하게 구현된 수준의 객체라고 할 수 있다. Stub이 상태 기반 테스트(State Base Test)라면 Mock은 행위 기반 테스트(Behavior Base Test)라고 이야기하기도 한다. 여기서 상태 기반 테스트는 메서드를 호출하고 그 결괏값과 예상 값을 비교하는 식으로 동작하는 테스트를 말하고, 행위 기반 테스트는 예상되는 행위들에 대한 시나리오를 만들어 놓고 시나리오대로 동작했는지에 대한 여부를 확인하는 것이다.


# 의존성 주입 (Dependency Injection)
하나의 객체가 다른 객체의 의존성을 제공하는 기술로 줄여서 DI(Dependency Injection)라고 부르기도 한다. 

## 의존성이란?
어떤 객체가 내부에서 생성하여 가지고 있는 객체를 의존성이라고 한다.

## 의존성 주입이란?
말 그대로 의존성을 주입시킨다는 뜻이다. 내부에서 초기화가 이루어지는 것이 아니라 외부에서 객체를 생성하여 내부에 주입해주는 것을 뜻한다. 

## 왜 의존성 주입을 사용할까?
의존성 주입을 사용하는 이유는 객체간의 결합도를 낮추기 위해서다. 객체 간의 결합도가 낮으면 리팩토링이 쉽고 테스트 코드 작성이 쉬워진다는 장점이 있다.




</div>
</details>

&nbsp;

---

- 참고링크
    - [Attributes](https://docs.swift.org/swift-book/ReferenceManual/Attributes.html)
    - [cellstyle](https://developer.apple.com/documentation/uikit/uitableviewcell/cellstyle)
    - [Configuring the Cells for Your Table](https://developer.apple.com/documentation/uikit/views_and_controls/table_views/configuring_the_cells_for_your_table)
