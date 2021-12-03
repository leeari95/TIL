# 210805 API Design Guidelines
# TIL (Today I Learned)

날짜: 2021년 8월 5일
작성자: 이아리
태그: API, UpperCamelCase, lowerCamelCase, 동사, 명사, 변수명, 함수명

## 학습내용

오늘은 캠프 1주차에서 다뤘었던 API Design Guidelines에 대해서 다시 한번 복습해보는 시간을 가졌다. 한번만 읽고 지나가는 것 보다는 정리해놓고 자주 훑어보는 것이 좋을 것 같다는 생각이 들었다. 평소 해당 개념에 대해서 꼼꼼하고 상세하게 다뤄보지 못한 것 같아 이번 기회에 상세히 알아보며 기본개념과 Naming에 대해서 정리해보기로 하였다.

---

## Fundamentals (기본개념)

1. 가장 중요한 목표는 사용 시점에서의 명확성(Clarity)이다. 메소드, 속성같은 개체들을 이해하기 쉽고 간결하게 만드는데 중점을 두고 작성해야 한다.
2. 명확성(Clarity)은 간결성(brevity)보다 중요하다. 문자들 몇 개만 사용해서 적은 양의 코드를 작성하는 것이 목표가 아니다.
3. 모든 선언문에 문서화용 주석(documentation comments)을 작성해야한다. 문서를 작성하면서 얻는 인사이트가 자신의 설계에 깊은 영향을 줄 수 있으니 미루지 말자.
4. Xcode 자동완성에서 볼 수 있도록 마크 다운을 적극 활용하라.
5. 선언한 요소에 대해 설명하는 요약으로 시작하라. API설계에 대한 평가는 선언 부분과 요약만으로도 완벽하게 이해할 수 있다.

---

## Naming (이름 짓기)

명확한 사용 활성화하기 (Promote Clear Usage)

- 그 이름을 사용하는 부분의 코드를 읽는 사람에게 혼란을 줄 수 있는 단어는 피하라.

```swift
// [좋은 예]
extension List {
  public mutating func remove(at position: Index) -> Element
}
employees.remove(at: x)
```

메소드 시그니처에서 at을 생략한다면 해당 메소드가 x과 같은 요소를 제거하는 건지, x위체에 있는 요소를 찾아서 제거한다는 건지 헷갈릴 수 있다.

```swift
// [나쁜 예]
employees.remove(x) // unclear: are we removing x?
```

---

- 불필요한 단어를 제거하라. 이름의 모든 단어는 사용자 관점에서 주요한 정보를 제공해야만 한다.

```swift
// [나쁜 예]
public mutating func removeElement(member: Element) -> Element?

allViews.removeElement(cancelButton)
```

더 많은 단어를 사용하면 의도가 명확해지고 헷갈리지 않을 수 있지만 코드를 읽는 사람에게 중복된 정보를 제공하는 경우는 제거해야 한다. 위에 코드에서 element는 호출하는 지점에서는 의미가 없으니 다음과 같은 코드가 더 좋다.

```swift
// [좋은 예]
public mutating func remove(member: Element) -> Element?

allViews.remove(cancelButton) // clearer
```

---

- 변수, 매개변수 연관타입은 선언한 타입이나 제약사항 보다는 역할에 맞는 이름을 갖도록 한다.

```swift
// [나쁜 예]
var string = "Hello"
protocol ViewController {
  associatedtype ViewType : View
}
class ProductionLine {
  func restock(from widgetFactory: WidgetFactory)
}
```

이처럼 타입이름을 반복해서 사용하는 것도 표현성이나 명료성은 헤치는 요소다. 대신 역할을 표현하는 이름이 더 좋다.

```swift
//[좋은 예]
var greeting = "Hello"
protocol ViewController {
  associatedtype ContentView : View
}
class ProductionLine {
  func restock(from supplier: WidgetFactory)
}
```

연관 타입도 제네릭 타입 이름 뒤에 Type을 붙이는 것을 피하라.

```swift
protocol Sequence {
  associatedtype IteratorType : Iterator
}
```

---

- 매개변수 역할을 명확하게 넣어서 부족한 타입 정보를 보완하라. 매개변수 타입이 NSObject, Any, AnyObject 이거나 Int나 String 같은 기본 타입이면, 사용하는 지점에서 맥락상 타입 정보가 불명확할 수 있다.

```swift
// [나쁜 예]
func add(observer: NSObject, for keyPath: String)

grid.add(self, for: graphics) // 불분명함
```

명확성을 갖도록 부족한 타입 정보 마다 역할을 설명하는 명사를 붙여준다.

```swift
// [좋은 예]
func addObserver(_ observer: NSObject, forKeyPath path: String)
grid.addObserver(self, forKeyPath: graphics) // 명확함
```

---

### 말하는 것처럼 술술 써지도록 작성하기(Strive for Fluent Usage)

- 메서드와 함수 이름을 사용할 때 영어 문장을 작성하는 것처럼 느끼도록 형태로 제공해라.

```swift
// [좋은 예]
x.insert(y, at: z)          “x에서 z에다 y를 삽입”
x.subViews(havingColor: y)  “색상 y을 갖는 x의 subviews”
x.capitalizingNouns()       “x에 명사를 대문자화”
```

```swift
// [나쁜 예]
x.insert(y, position: z)
x.subViews(color: y)
x.nounCapitalize()
```

```swift
AudioUnit.instantiate(
  with: description, 
  options: [.inProcess], completionHandler: stopProgressBar)
```

첫 번째나 두 번째 인자값 다음에 전달하는 값이 중요하지 않는 경우는 예외적으로 생략해도 된다.

- **팩토리 메서드 이름은 “make”로 시작하라.** 예시) x.makeIterator()
- **초기화 메서드나 팩토리 메서드에서 첫번째 인자에 추가적인 설명을 포함하지 않도록 한다.** 예시) x.makeWidget(cogCount: 47)

```swift
// [좋은 예]
let foreground = Color(red: 32, green: 64, blue: 128)
let newPart = factory.makeWidget(gears: 42, spindles: 14)
let ref = Link(target: destination)
```

```swift
// [나쁜 예]
let foreground = Color(havingRGBValuesRed: 32, green: 64, andBlue: 128)
let newPart = factory.makeWidget(havingGearCount: 42, andSpindleCount: 14)
let ref = Link(to: destination)
```

---

**함수나 메소드 이름은 부작용(side-effects) 여부에 따라 다르게 정한다**

- 부작용이 없는 경우는 명사형으로 작성한다. 예시) x.distance(to: y), i.successor().
- 부작용이 있는 경우에는 명령형으로 동사로 작성한다. 예시) print(x), x.sort(), x.append(y).
- **가변/불변 메소드 이름을 함께 고려하라.**
- **동사로 표현하면 자연스럽게** "ed"나 "ing"를 붙여서 불변 메소드 이름을 만들 수 있다.

> 가변(Mutating) x.sort(), x.append(y)

> 불변(Nonmutating) z = x.sorted(), z = x.appending(y)

- ("ed"를 붙여서) 동사 과거형으로 불변성을 작성하기 적합한 경우

```swift
/// Reverses `self` in-place.
mutating func reverse()
/// Returns a reversed copy of `self`.
func reversed() -> Self
...
x.reverse()
let y = x.reversed()
```

- 목적어가 있어서 문법적으로 "ed"를 붙이기 어렵고, "ing"가 적합한 경우

```swift
// Strips all the newlines from `self`
mutating func stripNewlines()
/// Returns a copy of `self` with all the newlines stripped.
func strippingNewlines() -> String
...
s.stripNewlines()
let oneLine = t.strippingNewlines()
```

- 동작을 명사로 표현하기 적합한 경우에는 가변 메소드 이름에 "form-"을 머릿말로 붙인다.

> 불변 x = y.union(z), j = c.successor(i)

> 가변 y.formUnion(z), c.formSuccessor(&i)

- 불변으로 사용할 때 **부울린 메소드나 프로퍼티를 사용할 때는 리턴값을 받아서 단언 구문(Assertion)처럼 읽도록 한다.** 예시) x.isEmpty, line1.intersects(line2).
- **어떤 것을 표현하는 프로토콜은 명사처럼 읽도록 명시한다.** 예시) Collection
- **기능이나 가능성을 표현하는 프로토콜은 -able, -ible, -ing 등을 붙여서 표현한다.** 예시) Equatable, ProgressReporting.
- 그 외에 **상수, 변수, 속성, 타입들은 명사로 읽도록 명시한다.**

## **용어를 잘 표현하라 (Use Terminology Well)**

- **애매한 용어를 피하라.** '피부(skin)'를 '표피(epidermis)'라고 하지말고, 더 쉽게 의미를 전달할 수 있는 표현이 있으면 그걸 선택하라. 전문 용어(Term of Art)는 필수적인 소통 도구지만, 사용하지 않을 경우 놓칠 수 있는 중요한 의미를 꼭 표현해야 하는 경우만 사용하세요.
- 전문 용어를 사용한다면 **기존 의미에 맞춰 사용하라.** 일반적인 용어가 애매하거나 불명확한 것을 정확하게 표현하기 위해서만 기술적인 용어를 사용하는 것이 좋다.
    - 전문가를 놀라게 하지마라: 기존에 친숙하게 사용하던 용어에 전혀 새로운 의미를 부여한다면 선배들이 놀라거나 화를 낼지도 모른다.
    - 초보자를 헷갈리게 하지마라: 웹에서 용어를 찾아 공부하는 사람들에게도 용어의 전형적인 의미가 중요하다.
- **축약어를 피하라.** 전문 용어면서 표준 형태가 아닌 약자는 잘못 풀어쓰거나 오해를 할 수 있다.
- **선례를 받아드려라.** 기존 문화에 맞춰진 표현은 왕초보를 위해서 줄이지마라.
    - 연속된 데이터 구조 이름은 단순히 초보자가 이해하기에 List가 더 쉬울더라도 Array를 사용하는 게 좋다. 배열(Array)은 프로그래밍을 공부하는 모든 사람들이 공부하는 일반적인 용어라서, 검색하거나 질문을 할 때도 더 적합한 이름이라고 할 수 있다.
    - 수학처럼 전문 영역에 대한 용어도 verticalPositionOnUnitCircleAtOriginOfEndOfRadiusWithAngle(x)보다 sin(x)처럼 폭넓게 사용하는 기존 선계를 지켜야한다. 비록 sine이 완전한 단어 표현이지만, 개발자나 수학자들은 sin(x)가 더 친숙하기 때문이다.

---

## 정리

**코드를 읽을 때, 코드를 읽는 것처럼 느끼도록 하면 안된다. 문서를 읽는 것 처럼 읽혀야 한다.**

변수는 명사, 함수는 동사

변수는 값을 담는 공간, 함수는 그 값들로 일을 한다.

변수와 함수는 lowerCamelCase 클래스명은 UpperCamelCase

---

lowerCamelCase : fuction, method, variable, constant

ex.) someVariableName

UpperCamelCase : type(class, struct, enum, extension…)

ex.) Person, Point, Week

## 공식문서 참고

[https://minsone.github.io/swift-internals/api-design-guidelines/](https://minsone.github.io/swift-internals/api-design-guidelines/)
