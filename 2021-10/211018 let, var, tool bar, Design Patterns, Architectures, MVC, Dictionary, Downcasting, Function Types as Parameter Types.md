# TIL (Today I Learned)

10월 18일 (월)

## 학습 내용
오늘은 활동학습으로 카훗을 시작으로 디자인패턴, 아키텍처, MVC에 대한 내용으로 학습을 진행하였다. 일요일 저녁에 미리 예습을 하고 가서 학습을 이해하는 것에 대해서 큰 도움이 되긴 했다. 그래도 역시 뭔말인지 모르는 포인트가 뜨문뜨문 있어서 복습이 필요해보였다. 이후 새로운 프로젝트 팀원인 제이티와 함께 그라운드 룰과 STEP 1을 구현하기 시작했다.

&nbsp;

## 문제점 / 고민한 점
- 화면 하단에 액션을 모아둔 바의 이름...몰라
- Swift가 var보다 let을 선호하는 이유? 나 아는데... 뭐였지?
- 디자인 패턴이란?
- 디자인 패턴 강의를 듣다가 책을 추천받았다.
- Design Patterns vs Architectures
- 타입을 구현하기 전에 설계를 어떻게 진행할 것인가?
- 과일을 초기화 할 때 모든 과일을 한꺼번에 초기화 하는 법
- 정해진 레시피를 어떻게 정의를 해주면 좋을까?
- 과일 재고를 관리할 때 연산자로 더하고 빼줄 수는 없을까?
- 모든 과일을 초기화하는 것이아니라 개별적으로도 초기화 할 수 있는 방법을 찾아보고 싶다.
- 에러처리시 케이스별로 메세지를 출력하는 법에 대한 고민

&nbsp;

## 해결방법
- 화면 하단에 액션을 모아둔 바의 이름은 `Tool bar`이다.
- Swift가 var 및 let을 사용하는 것을 귀찮게 참견하는 이유?
    * 상수(let)는 변경할 필요가 없는 값으로 코드를 보다 안전하고 명확하게 하기 위해 Swift는 전반적으로 상수가 사용된다. 이는 혹시나 나중에 실수로 값을 변경하지 않도록 하는데 좋다.
    * let은 프로그램이 실행이 시작되기 전에 예약된다. 10개의 상수와 10개의 변수가 있는 프로그램이 있는 경우 10개의 상수에 대한 메모리가 할당되고 초기화 된다. (할당된 값은 할당된 메모리에 저장됨) 상수가 많을수록 메모리 공간이 늘어나는데, 값이 할당되면 변경되지 않으므로 실행시 시간을 절약할 수 있다.
- `객체지향의 사실과 오해` 구매하였다. 시간날 때 마다 정독해야지.
- `Design Patterns` vs `Architectures`
    * **Architecture**
        큰 그림, 소프트웨어의 전반적인 큰 그림, 프로그램의 구조
        ex) 서양 건축물 양식, MVC architecture
    * **Design Patten**
        이 아키텍처 안에서 세세한 부분을 해결하는 해결방식
        ex) 서양 건축물 안의 불편한 설계 부분을 수정해서 현재에 맞게 적용하는 것
- 제이티와 함께 `순서도`를 그려볼까...? 했었는데 모든 스텝이 오픈 되지가 않아서 그리기가 애매했다. 일단 **STEP 1에 대한 요구사항을 충족**하도록 구현하기로 하였고, 노션으로 같이 메모해가면서 `FruitStore`와 `JuiceMaker`의 타입을 만들고 기능을 구현하는 것에 힘썼다.
- 과일의 초기값을 정해서 초기화하는 부분에 대해서 나에게 좋은 생각이 있어서 제이티에게 제안을 했다. 우선 과일과 과일의 갯수를 저장하는 컬렉션으로 `Dictionary`가 적합하다고 의견을 나누었고, Dictionary `이니셜라이저` 중에 튜플을 받아서 딕셔너리로 초기화 해주는 이니셜라이저가 있어서 찾아보았고, 잘 활용해서 구현해보았다.
    - `Dictionary init(uniqueKeysWithValues:)`
- 정해진 레시피를 받아서 과일의 재고를 관리해주어야 하는 부분이 있었는데, 레시피를 어떤식으로 받아올지 좋은 생각이 안났다. 제이티가 Dictionary로 통해서 받는 기발한 아이디어를 떠올라서 활용해보았다.
- 연산자로 더하고 빼는 방법 역시 제이티의 아이디어였는데, 바로 **파라미터로 함수를 받아서 활용하는 방법**이였다.
```swift=
var num = 3
func operate(operNum: Int, fun: (Int, Int) -> Int) {
    num = fun(num, operNum)
}
operate(operNum: 6, fun: +)
print(num) // 9
```
- 과일을 개별적으로 초기화하라는 요구사항은 없지만 궁금해서 구현해보기로 하였다. 이니셜라이저를 다시 복습하고 만들어보기로...
- 원래는 `enum` 내부에서 `static` 메서드를 구현하여 출력해주기로 하였으나, 꼭 `static` 메서드로 구현해주지 않아도 `Error` 프로토콜을 채택하고 있기 때문에 다운캐스팅(`as`)을 통해서 메서드를 호출해줄 수 있었다. 
```swift=
enum RequestError: Error {
    case wrongInput
    case notFound
    case fruitStockOut
    
    func printErrorMessage() {
        switch self {
        case RequestError.wrongInput:
            print("수량을 잘못 입력하였습니다.")
        case RequestError.notFound:
            print("선택한 과일이 존재하지 않습니다.")
        case RequestError.fruitStockOut:
            print("과일의 재고가 부족합니다.")
        }
    }
}
do {
    try maker.fruitsMixer(juice: .strawberryBanana)
} catch let error as RequestError {
    error.printErrorMessage()
}
```



    

&nbsp;

## 공부내용 정리
<details>
<summary>Design Pattern</summary>
<div markdown="1">

# Design Pattern
* 설계할 때 자주 쓰이는 템플릿
* 선배들의 삽질 기록
* 코드의 모양새
디자인 패턴은 소프트웨어 공학의 소프트웨어 설계에서 공통으로 발생하는 문제에 대해 자주 쓰이는 설계 방법을 정리한 패턴이다.

## 사용 이유
디자인 패턴을 참고하여 개발할 경우 효율성과 유지보수성, 운용성이 높아지며 프로그램의 최적화에 도움이 된다.
* OOP의 다양한 문제 상황에 대한 예방
* 프로그래머 사이의 협업 효율 향상
* 프로그래머 사이의 의사소통 증진
* 코드의 안정화 및 최적화
* 코드의 재사용성 증가


주어진 패턴을 상황에 맞게 변경을 해서 사용해야 하는데 디자인 패턴에 집착하게 되면 유연하게 패턴을 적용 및 변경을 못하게 된다. 따라서 100퍼센트 지킬 필요는 없지만 명확하게 알아두면 쓸 일이 많다.

</div>
</details>
<details>
<summary>Architectures</summary>
<div markdown="1">

# Architectures
간단하게 프로그램의 구조라고 생각한다. 위키에서는 소프트웨어 내에서의 공통적인 발생 문제들을 해결하기 위한 일반적인 해결 방법이라고 설명하고 있다.

## 사용 이유
프로그램은 제대로 작성만 된다면 실행이 가능하다. 하지만 이런 프로그램들은 유지보수에 굉장히 많은 비용이 들어가며 실력있는 개발자가 보기에는 가독성이 떨어진다고 볼 수 있다.

## 좋은 아키텍처란?
* 균형잡힌 분배(Balanced Distribution)
    * 객체 지향 원칙 중 Single Responsibility에 기반 > 하나의 객체는 하나의 역할만 갖는다
    * 모듈(클래스)들의 독립성이 떨어지면 테스트가 어렵다
* 테스트 가능 (Testablity)
    * 테스트 중 발생하는 이슈를 사전에 발견하기 위한 단계다.
* 사용하기 쉬운지 (Easy of Use)
    * 개발 속도와 관련이 있다.
* 단방향성 데이터 흐름(Unidirectional Data Flow)
    * 코드를 쉽게 이해할 수 있게 하며 쉬운 디버깅을 제공한다.
    * 에러가 발생하면 원인을 찾기 힘들어 지는 공유 자원의 사용도 피해야 한다.

4가지 조건을 충족 시키는 완벽한 아키텍처는 존재하지 않는다. 그러니깐 자신의 프로젝트 성격에 맞춰서 적절한 아키텍처 도입이 필요하다.

iOS에서는 4가지 조건 중 균형잡힌 분배를 위해서 크게 3가지로 나누어 코딩이 진행된다.
* Model 데이터 조작이 일어나고 이를 담당하는 부분
* View 사용자에게 보여주는 시각적인 부분으로 UI에 해당.
* Controller / Presenter / ViewModel 이 부분은 Model과 View 사이의 중재자로 View를 통해 발생한 사용자의 액션에 따라 동작하며 Model에 값의 조정을 요청하며 Model 값의 변화에 맞게 View를 갱신하는 역할
그래서 iOS에서 가장 많이 사용되는 아키텍처 패턴인 MVC, MVP, MVVM가 있다.


</div>
</details>
<details>
<summary>Design Patterns vs Architectures</summary>
<div markdown="1">

* Architecture
큰 그림, 소프트웨어의 전반적인 큰 그림, 프로그램의 구조
ex) 서양 건축물 양식, MVC architecture
* Design Patten
이 아키텍처 안에서 세세한 부분을 해결하는 해결방식
ex) 서양 건축물 안의 불편한 설계 부분을 수정해서 현재에 맞게 적용하는 것


</div>
</details>
<details>
<summary>MVC (Model-View-Controller)
</summary>
<div markdown="1">

![](https://i.imgur.com/nncCDHO.gif)

Xcode 프로젝트 디렉토리에서 Model, View, Controller 폴더를 따로 만들어서 관리한다.

## Model
앱이 정확히 무엇을 할지 코딩하는 것이다. 비즈니스 로직을 담당하는 함수들이 정의되고, 처리되는 데이터(클래스, 구조체 등)와 내부 알고리즘이 정의된다.

## View
사용자에게 말 그대로 보여지는 영역으로 볼 수 있다. Storyboard 파일을 비롯해서 인터페이스를 구축하는 영역으로 생각하면 될 것 같다.

## Controller
Model 과 View 사이의 다리라고 보면 된다. Controller는 Model이 가지고 있는 데이터를 어떻게 할 것인지 명령을 내린다. 그리고 이 명령을 토대로 사용자에게 보여지는 인터페이스 부분도 수정을 한다. 보통 여기서 @IBAction 함수들이 정의된다. 즉 사용자가 View를 통해 Interaction을 하면 Controller가 이를 control한다는 것이다.

Model 에서는 비즈니스 로직을, View에서는 사용자에게 보여지는 것들을, 그리고 Controller 에서는 어떻게 Model 을 활용해서 View 에게 보여질 것인지만 정의하면 되니, 코드가 간결해지고, 관리가 용이해진다.


## MVC 패턴에서 각 영역이 대화하는 방법
Controller는 Model과 View에 직접 지시를 할 수 있지만 Model과 View는 Controller에 직접적으로 알릴 수 없다.
그렇다면 만약 Model의 데이터가 변경된 것을 알리거나, View에서 사용자의 action이 발생했을 때 Controller에게 어떻게 알릴까?

## View to Controller

![](https://i.imgur.com/ypG6NxM.jpg)

컨트롤러는 View에 대해서 outlet을 이용해서 View에게 직접 접근할 수 있다. View는 target - Action 구조로 사용자의 행위에 따라 필요한 함수를 호출 할 수 있다. 또한 구조적으로 미리 정해진 방식으로 행위에 대한 요청 (delegate), 데이터에 대한 요청(data-source)을 할 수 있다.

## Model to Controller

![](https://i.imgur.com/w3KNBvI.jpg)

컨트롤러는 모델에 접근할 수 있다. 하지만 모델은 Notification & KVO 방식을 통해 모델의 변화를 컨트롤러에게 알릴 수 있다.


## 장점
- 다른 패턴에 비해 코드량이 적다
- 애플에서 기본적으로 지원하고 있는 패턴이기 때문에 쉽게 접근할 수 있다
- 많은 개발자들에게 친숙한 패턴이기 때문에 개발자들이 쉽게 유지보수 할 수 있다.
- 개발 속도가 빠르기 때문에 아키텍처가 중요하지 않을 때 사용하거나 규모가 작은 프로젝트에서 사용하기 좋다.

## 단점

![](https://i.imgur.com/pQFMobW.png)

- 위의 사진과 같이 뷰와 컨트롤러가 너무 밀접하게 연결되어 있다.
- View와 Controller가 붙어있으며 Controller가 View의 Lift Cycle까지 관리하기 때문에 View와 Controller를 분리하기 어렵다. 이렇게 되면 재사용성이 떨어지고 유닛 테스트를 진행하기 힘들어진다.
- 대부분의 코드가 Controller에 밀집될 수 있다. Life Cycle 관리 뿐만 아니라 delegate나 datasource관리, 네트워크 요청, DB에 데이터 요청 등 많은 코드가 Controller에 작성되면 Controller의 크기는 비대해지고 내부 구조는 복잡해지게 된다.
- 이런 상황을 비유해 많은 사람들이 Massive View Contorller라고 부르기도 한다
- 이렇게 복잡해진 코드는 프로젝트 규모가 커질수록 유지보수하기 힘들게 만든다.

## MVC 아키텍처는 아키텍처의 기준에 얼마나 부합할까?
* Distribution View와 Model은 분리되었지만 View와 Controller는 강하게 연결되어 있다.
* Testability View와 Controller가 강하게 연결되어 있어서 Model만 테스트를 진행 할 수 있다.
* Easy of Use 가장 적은 양의 코드를 필요하며 경험이 적은 개발자들도 쉽게 유지보수 할 수 있다.

아키텍처를 잘 모를 때 사용하기 쉬운 패턴이지만 작은 프로젝트여도 많은 유지보수 비용이 들어간다.

</div>
</details>

---

- 참고링크
    - [Design Pattern](https://ko.wikipedia.org/wiki/%EC%86%8C%ED%94%84%ED%8A%B8%EC%9B%A8%EC%96%B4_%EB%94%94%EC%9E%90%EC%9D%B8_%ED%8C%A8%ED%84%B4)
    - [Architectural](https://en.wikipedia.org/wiki/Architectural_pattern)
    - [Model만을 다루는 Model Controller를 따로 만들어 사용하는 방법](https://www.swiftbysundell.com/articles/model-controllers-in-swift/)
    - [iOS Architecture Patterns](https://medium.com/ios-os-x-development/ios-architecture-patterns-ecba4c38de52)
