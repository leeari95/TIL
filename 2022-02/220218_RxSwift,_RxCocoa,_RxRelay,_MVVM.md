# 220218 RxSwift, RxCocoa, RxRelay, MVVM
# TIL (Today I Learned)

2월 18일 (금)

## 학습 내용

- RxSwift
    - Sugar API
    - RxCocoa
    - RxRelay
- MVVM 적용시켜보기

&nbsp;

## 고민한 점 / 해결 방법

**[RxSwift - Sugar API]**

* 간단한 생성 : `just`, `from`
* 필터링 : `filter`, `take`
* 데이터 변형 : `map`, `flatMap`
* 그 외 : A Decision Tree of Observable Operators
* Marble Diagram
    * http://rxmarbles.com/
    * http://reactivex.io/documentation/operators.html
    * https://itunes.apple.com/us/app/rxmarbles/id1087272442?mt=8

> Sugar API는 기본사용법의 추가적인 귀찮은 것들을 없애주는 사용법이다.
이러한 것들을 오퍼레이터라고 부른다.


### just
* 데이터를 하나만 전달할 때 간단히 사용할 수 있다.

![](https://i.imgur.com/bDymOxA.png)

### from
* 데이터를 하나씩 여러개 전달하고 싶을 때 사용한다.
* 그럼 next에 Hello 한번, World 두번 총 두개의 데이터가 차례대로 전달된다.

![](https://i.imgur.com/lXZIWVC.png)

![](https://i.imgur.com/Pts6L5X.png)


![](https://i.imgur.com/STrQA41.png)

* subscribe에도 sugar가 존재한다.
    * 이런식으로 단순 파라미터로도 전달받을 수 있다.


### observeOn
* 메인 스레드에서 처리해야하는 UI작업은 DispatchQueue.main으로 감싸줘야하는데, 해당 작업을 생략하고 싶을 때 사용한다.
* 데이터를 중간에 바꾸는 sugar의 형태인데, 이런 것들을 operator라고 한다.

![](https://i.imgur.com/ezu4nj3.png)

![](https://i.imgur.com/xMyfsQH.png)

### map
* 데이터를 중간에서 변형해주고 싶을 때 사용한다.
* 아래는 Int로 변형했다가 다시 String으로 변환하는 예제이다.

![](https://i.imgur.com/fFQsQNo.png)

### filter
* 조건을 걸어 json의 카운트가 0보다 클 경우에 아래 클로저를 마저 실행한다.

![](https://i.imgur.com/BHsYbEV.png)

> 그 외 수많은 오퍼레이터들....
https://reactivex.io/documentation/ko/operators.html
* 마블 다이어그램을 통해 설명되어있다.

### ObserveOn
* Observable 유틸리티 오퍼레이터
* 스레드를 지정해주는 오퍼레이터이다.

![](https://i.imgur.com/u7M2N7r.png)

* ObserveOn을 하는 순간 줄의 색이 변경되는데, 이 줄은 스레드를 의미한다.
    * subscribeOn은 시작시점의 스레드에 영향을 주는 유틸리티
    * 위치랑 상관없이 어디에 있든, 시작시점의 스레드를 전환해준다.
* 위 그림을 참고해보면 다중 스레드 환경에서 스레드 간의 Observable을 전환하는 모습을 볼 수 있다.

![](https://i.imgur.com/N3aZ9Pa.png)

* 코드로 예시를 보자.
* subscribeOn으로 시작시점 스레드를 Concurrent으로 생성해주었다.
* 그러면 map, filter, map의 작업들은 모두 Concurrent에서 이루어진다.
* 이후 observeOn이 호출이 되는데, 그 아래에 있는 subscribe의 클로저는 메인스레드에서 처리된다.


* 알파벳 순으로 정렬된 연산자의 리스트를 보면 어떤건 굵게 표시되어있는 경우가 있다.

![](https://i.imgur.com/iFteEbO.png)

* 굵게 표시된 것은 `대표 기능 연산자`이기 때문이다.

### Merge
* 여러개의 Observable을 묶어서 하나의 Observable로 만들어준다.

![](https://i.imgur.com/5UXT0A0.png)

### Zip
* 위 아래로 데이터가 하나씩 생성되면 그걸 쌍으로 만들어서 합쳐준다.
* 데이터가 생성되는 시점이 서로 달라도 알아서 쌍으로 만들어준다.

![](https://i.imgur.com/sjYe0mD.png)

### CombineLatest
* Zip과 다르게 짝이 안맞아도 된다. 가장 최근에 나온 데이터와 함께 쌍으로 만들어서 합쳐준다.

![](https://i.imgur.com/vL8l4CS.png)

> 코드 예제

![](https://i.imgur.com/brz1tWB.png)

* Observable을 두개 선언해주고 zip을 통해 쌍으로 묶어준다. 이후 클로저에는 두 쌍을 linebreak와 함께 병합해주고 있다.

> disposable을 활용하는 방법

![](https://i.imgur.com/VwlIpHE.png)

* 위 예제처럼 disposable이라는 프로퍼티를 만들어주고, viewWillDisappear가 호출되는 시점에 만약 다운로드를 받고있는 중이라면, 중간에 네트워킹을 취소시켜줄 수가 있다.

![](https://i.imgur.com/QlqeOOb.png)

* 또다른 응용 방법은 disposable을 배열로 선언하고, Observable을 subscribe을 해줄 때마다 생성되는 disposable을 append를 시켜주고, 나중에 반복문을 돌면서 취소시켜주는 방법도 있다.

이 부분도 Sugar가 존재하는데, DisposeBag이라는 오퍼레이터가 있다.

### DisposeBag
* 말 그대로 disposable을 담는 가방이다.
* 그리고 특별히 dispose()를 호출해주지 않아도 자동으로 작업을 취소시켜준다.
* insert를 호출해서 disposable을 추가해줄 수 있다.

![](https://i.imgur.com/IUJfjh1.png)

이렇게 마지막에 disposed(by:) 를 호출해서 가방에 넣어주는 방법도 존재한다.
 
> 클로저와 메모리 해제 실험 중...

* self를 맘껏 사용하지만 메모리 해제가 잘 되는 예제를 만들어보자

![](https://i.imgur.com/JY8cyD4.png)

* 뷰가 메모리에서 해제되는 시점에서 disposeBag도 같이 사라지지만, 참조카운트가 남아있다면 disposeBag이 사라지지 않는 경우도 존재한다.
* 따라서 뷰가 사라질 때 dispose를 강제시키면 메모리 해제를 통제할 수 있게 된다.
* 즉 순환참조도 예방할 수 있게 된다.

---

**[RxSwift - 활용범위 넓히기, UI 컴포넌트와의 연동]**

## RxCocoa
* RxSwift의 기능을 UiKit에 extension으로 추가한게 RxCocoa 라고 한다.
    * 뷰에 보여줄 ViewModel 타입을 만든다.
    * 그리고 뷰에 보여줄 데이터들을 모조리 ViewModel 타입안에 때려박는다.
    * 뷰컨트롤러에는 viewModel이라는 프로퍼티를 선언해준다.

### Subject
> Observable은 값을 넘겨주는 역할을 하지, 값을 외부에서 받아들여서 넘겨주는 역할은 하지 않는다.  그래서 문제가 생겼는데... 'Observable 처럼 값을 받아먹을 수는 있는 애인데, 외부에서 이 값을 컨트롤할 순 없을까?' 그래서 나온 것이 Subject이다.

* Observable과 다르게 값을 받아먹을 수도 있지만, 외부에서 값을 통제할 수도 있다.
* 총 4가지의 종류가 있다.
    * `AsyncSubject`
        * 여러개가 구독을 하고 있더라도 다 안내려보내준다.
        * 그러다가 completes되는 시점에 가장 마지막에 있던 거를 모든 애들한태 다 내려주고 complete을 시킨다.
    * `BehaviorSubject`
        * 기본값을 가지고 시작한다.
        * 아직 데이터가 생성되지 않았을 때 누군가가 subscribe를 하자마자 기본값을 내려준다.
        * 그리고 데이터가 생기면 그때마다 계속 내려준다.
        * 새로운 게 중간에 subscribe를 하고나면 가장 최근에 발생했던 값을 일단 내려주고나서 그 다음부터 발생하는 데이터를 똑같이 모든 구독하는 애들한태 내려보내준다.
    * `PublishSubject`
        * subscribe를 하면 데이터를 그대로 내려보내준다.
        * 다른 subscribe가 또 새롭게 subscribe 할 수 있다. 그럼 또 데이터가 생성된다면 subscribe하고 있는 모든 관찰자한태 데이터를 내려준다.
    * `ReplaySubject`
        * subscribe를 했을 때 그대로 순서대로 데이터를 내려보내준다.
        * 두번째로 subscribe를 한다면 여태까지 발생했던 모든 데이터를 다 내려준다. 한꺼번에 Replay를 하는 것이다.

> 코드예제 

```swift
viewModel.totalPrice
    .scan(0, accumulator: +) // 0부터 시작해서 새로운 값이 들어오면 기존에 있던 값이랑 더한다.
    .map { $0.currencyKR() } // totalPrice를 가져와서 String으로 변환해주고
    .subscribe(onNext: {
        self.totalPrice.text = $0 // UI를 업데이트 한다.
    })
    .disposed(by: disposeBag) // 그리고 dispose 가방에 담는다.
```

* 이전에는 UI를 업데이트하는 메소드를 만들어서, 필요한 시점마다 호출시켜주어야 UI가 바뀌었다.
* 하지만 위와같이 맨처음 한번만 subscribe를 호출시켜도, subscribe를 한거에 의해서 값이 바뀔 때마다 UI를 업데이트 하도록 한다.
```swift
class MenuListViewModel {
//    var dummyMenus: [Menu] = [
//        Menu(name: "튀김1", price: 100, count: 0),
//        Menu(name: "튀김2", price: 100, count: 0),
//        Menu(name: "튀김3", price: 100, count: 0),
//        Menu(name: "튀김4", price: 100, count: 0),
//        Menu(name: "튀김5", price: 100, count: 0),
//        Menu(name: "튀김6", price: 100, count: 0)
//    ]
    
    //    var itemsCount: Int = 5
    //    var totalPrice: Int = 10_000
    //    var totalPrice: PublishSubject<Int> = PublishSubject()
    // MARK: - 개선된 버전
    lazy var menuObservable = PublishSubject<[Menu]>()
    
    lazy var itemsCount = menuObservable.map {
        $0.map { $0.count }.reduce(0, +)
    }
    lazy var totalPrice = menuObservable.map {
        $0.map { $0.price * $0.count }.reduce(0, +)
    }
    
    init() {
        let dummyMenus: [Menu] = [
            Menu(name: "튀김1", price: 100, count: 0),
            Menu(name: "튀김2", price: 100, count: 0),
            Menu(name: "튀김3", price: 100, count: 0),
            Menu(name: "튀김4", price: 100, count: 0),
            Menu(name: "튀김5", price: 100, count: 0),
            Menu(name: "튀김6", price: 100, count: 0)
        ]
        
        menuObservable.onNext(dummyMenus)
    }
}
```
> 위 예제코드 설명
* 배열을 담고 있는 `PublishSubject`를 생성한다.
    * 외부로부터 배열이 주어지면 그때마다 Observable이 동작할 것이다.
* `itemsCount`
    * menuObservable를 바라보면서 뭔가 값이 바뀔 때마다 아이템의 총 합을 카운트로 내려보내주는 Observable이다.
* `totalPrice`
    * menuObservable을 바라보면서 값이 바뀔 때마다 가격의 총합을 바꿔서 내려보내주는 Observable이다.

따라서 ViewController에서는 아래 코드를 딱 한번만 호출해주면 된다는 것이다.
```swift
viewModel.itemsCount
    .map { "\($0)" } // 문자열로 바까서
    .subscribe(onNext: { // 구독할게~~~
        self.itemCountLabel.text = $0 // 값이 바뀔 때마다 UI 업데이트 해라...
    })
    .disposed(by: disposeBag) // 가방에 담아두기
```

---

**[RxSwift를 활용한 아키텍처 - 프로젝트에 MVVM 적용해보기]**

>RxCocoa는 RxSwift 요소들을 UiKit을 extension하여 접목시킨 것이다.

![](https://i.imgur.com/LLsMZXh.png)

* 이런 rx를 제공해준다.
* Binder는 Bind를 시킬 수 있는데, subscribe를 하지 않고, binder를 넣어줄 수 있다.

![](https://i.imgur.com/aBIS3B0.png)

* bind와 subscribe는 같은일을 하는거 같은데...?

![](https://i.imgur.com/BYS4xQI.png)

* 그렇다. bind는 subscribe의 `Sugar`다. 3줄에 걸쳐서 표현된 것이 1줄에 끝난다.
* bind를 사용하면 장점이 있는데, subscribe의 경우 순환참조를 방지하려면 weak self 키워드를 사용해야하는데, 반면에 bind를 사용하면 알아서 순환참조를 예방해준다.

![](https://i.imgur.com/l8yu9Ur.png)

* 이런 extension을 제공해주는 것이 RxCocoa이다.

그리고 UI를 업데이트할 땐 메인스레드에서 안전하게 처리해주도록 `observeOn`을 추가해주어야 한다.

![](https://i.imgur.com/DAe1iiG.png)

* tableView 같은 경우에도 배열에 bind를 아래와 같이 추가해줄 수 있는데,

![](https://i.imgur.com/6K4NidU.png)

```swift
viewModel.menuObservable
    .bind(to: tableView.rx.items(
        cellIdentifier: "MenuItemTableViewCell",
        cellType: MenuItemTableViewCell.self
    )) { index, item, cell in // 이 items라는 메소드가 dequeue를 대신 해준다고 보면 된다.
        cell.title.text = item.name
        cell.price.text = "\(item.price)"
        cell.count.text = "\(item.count)"
    }.disposed(by: disposeBag)
```
>이렇게 선언해주면 TableView의 DataSource는 필요없어지게 된다.


* 이후에 menuObservable을 `BehaviorSubject`로 바꾸어 주어야 한다.

![](https://i.imgur.com/20zu6Rx.png)

* 이유는 PublishSubject 같은 경우 데이터가 바뀐다면 그때 데이터를 내려보내주기 때문에, 값을 먼저 할당해주고, TableView를 세팅해달라고 bind를 추가해도 값이 이미 할당되어있는 상태이기 때문에 UI가 초기에 설정되지 않는다.
* 따라서 가장 최근에 내려준 데이터를 내보내주는 BehaviorSubject로 바꾸어주어야 한다.
    * `lazy var menuObservable = BehaviorSubject<[Menu]>(value: [])`

그리고 `onOrder` 버튼에 아래와 같은 코드를 추가한다.
```swift
viewModel.menuObservable.onNext([
    Menu(name: "changed", price: 100, count: 2)
])
```
menuObservable에 새로운 Menu 배열을 할당해주고 있다.
앞서 viewModel을 활용해서 UI를 업데이트 해달라는 bind를 해주었기 때문에 값만 수정해주어도 UI는 알아서 업데이트 된다.

count에 2가 아니라 random으로 1...5까지 할당해놓고, 버튼을 계속 누르면 뷰가 계속 업데이트 되는 것을 확인해볼 수 있다.

![](https://i.imgur.com/FmBncdh.gif)

---

## MVVM

* View
    * 뷰를 보여주기만 함. 화면을 그리기만 하고 아무 처리 하지않는다.
* ViewModel
    * 어떤 데이터를 보여줘야하는지, 뷰에 대한 처리를 하는 로직이 들어간다.

**[상황]**

* 기획서가 나왔다. 서버는 서버대로, 디자인은 디자인대로, 클라이언트는 클라이언트 대로 각각 순차적으로 진행하는 것이 아니라 동시에 개발을 진행하는 것이다.
* 뷰는 뷰대로 기획서에 나와있는 모든 내용과 기능들을 Mock 데이터를 활용하여 개발을 하는거다.
* 그리고 뷰에 필요한 모델은 뷰모델로 따로 만드는 것이다.
* 나중에 실제로 서버에서 실제로 데이터가 나오면, 그걸 가지고 실제 모델을 만든다.
* 우리 입장에서는 도메인에서 오는 모델이다.
    * 그 모델은 화면에 보여주는 모델하고는 다르다.
* 그래서 도메인에서 오는 모델을 뷰모델로 컨버팅하는 작업이 필요하다.
* 뷰에서는 뷰에 필요한 뷰모델을 가지고 사용한다.

**[아키텍처로 이야기하는 ViewModel]**

* MVC(모델-뷰-컨트롤러) : 보편적으로 많이 사용되는 소프트웨어 디자인 패턴
    * Model : 데이터와 명령을 담당
    * View : 화면과 사용자 인터페이스를 담당
    * Controller : 모델과 뷰 사이의 명령을 라우팅을 담당
* MVC의 동작 : View에서 사용자가 입력 -> Controller가 입력을 받아 처리, Model을 변경하고 View가 나타냄
* Controller는 여러 개의 뷰를 가질 수 있음.

>컨트롤러가 많은 부담을 가지고 있는 패턴, 그리고 View와 Model의 높은 의존성(View가 직접 Model을 보여주므르)

* MVP(모델-뷰-프레젠터) : MVC처럼 모델과 뷰는 동일하나 controller 대신 presenter를 사용하는 패턴
- Presenter: 뷰에서 요청한 정보로 Model을 가공하여 뷰에게 전달
    * UIViewController가 View로 포함 : 입력은 view가 받되 처리는 presenter에게 알려주는 것.
    * View와 Model의 의존성을 줄여주므로 소프트웨어가 커졌을 때 유지보수가 용이해진다.
    * View - Presenter는 1:1 관계이다. 대신 View-Presenter 사이의 의존성이 생긴다는 단점
* MVVM(모델-뷰-뷰 모델) : MVC처럼 모델과 뷰는 동일하나 view model을 사용하는 패턴
    * view model : view를 표현하기 위해 만든 View를 위한 Model. View를 나타내기 위한 Model이자 View를 나타내기 위한 데이터 처리를 하는 부분
    * 화면을 그리는 것은 완전히 view에게 할당하는 것.
    * view로부터 입력 action을 받아 model에게 데이터를 요청 및 받은 데이터를 처리, view는 view model과 binding하여 데이터를 보여준다.
    * view - view model은 1:1 관계, 의존성이 없어 독립성을 띄므로 유지보수 및 관리에 용이한 장점

---

**[RxCocoa 추가 설명]**

* UI 작업의 특징
    * 항상 메인스레드에서 처리해야 한다. 
    * 그래서 `.observeOn(MainScheduler.instance)` 코드는 항상 들어가야한다.
    * 그리고 UI는 데이터를 처리하다가 중간에 에러가 나면 스트림이 끊어져버린다.
    * 끊어진 스트림은 다시 재사용할 수 없다.
    * 스트림이 끊어지면 안되니까 아래 코드를 활용한다.
    * `.catchErrorJustReturn("")`
        * 에러가 나면 빈 문자열을 내보내라는 뜻이다.
    * UI에 대해서 처리하기 위해서는 항상 2줄이 필요하다.

![](https://i.imgur.com/P21BEO2.png)

이게 번거로우니까 아래와 같은 drive가 나왔다.

![](https://i.imgur.com/VSNrbTl.png)


## RxRelay

이렇게 뷰에 대한 스트림은 끊어지면 안되니까 이런것들이 나왔는데, subject도 끊어지지 않는 subject가 나왔다.
* Subject랑 동일하지만 에러가 나도 스트림이 끊어지지 않는다.
* 에러가 나지 않으니 받아들일 수 밖에 없다. 그래서 데이터를 전달할 때 onNext로 전달하는 것이 아니라 accept로 전달한다.

> Observable의 UI 전용으로 `Driver`
> Subject의 UI 전용으로 `Relay`
![](https://i.imgur.com/ccabuVQ.png)

>스레드에 지연을 주는 방법
![](https://i.imgur.com/ovgQ8LK.png)
`.delay`를 주면 된다~

>3초 후에 딱 1번만 얼럿을 보여주게 하기
![](https://i.imgur.com/qH0646Z.png)

---

- 참고링크
    - https://www.youtube.com/watch?v=iHKBNYMWd5I
