# 211224 escapingClosure, autoClosure, weak, wildcard, naming
# TIL (Today I Learned)


12월 24일 (금)

## 학습 내용
- 은행창구매니저 STEP 2 진행
- Escaping Closure
- Auto Closure

&nbsp;

## 고민한 점 / 해결 방법

**[Delegate 패턴 구현 시 네이밍]**

- 허황이 공유해주었는데, 구글의 [Swift Style Guide](https://google.github.io/swift/#delegate-methods)를 참고하였다고 한다.

> The term “delegate’s source object” refers to the object that invokes methods on the delegate. For example, a `UITableView` is the source object that invokes methods on the `UITableViewDelegate` that is set as the view’s `delegate` property.

* CoCoa의 프로토콜에서 영감을 받았다고 적혀있다. `UITableViewDelegate나` `UINavigationControllerDelegate` 프로토콜의 메소드들의 네이밍을 확인해보면 모두 `tableView`, `navigationController`가 앞에 꼭 붙어서 네이밍이 되어있다.
* 따라서 대리자의 객체를 `첫번째 argument`로 사용하여 네이밍을 한다고 적혀있다.
* 네이밍은 역시 기본 프레임워크를 참고하면 되는 것인가...? 😂


---

**[와일드카드 패턴으로 생성한 인스턴스의 참조 카운트]**

- `상황` 기존에 와일드카드 패턴으로 인스턴스 생성한 타입이 Delegate를 채택하고 있던 형태였다. 이후 순환참조 문제가 우려되어 각 타입들마다 delegate 프로퍼티에 weak 키워드를 붙여주었다.
    
    ```swift
    final class Bank {
        private let bankClerk: BankClerk
        private var customerQueue = Queue<Customer>()
        weak var delegate: BankDelegate?
    ...
    }
    
    // main ...
    func run() {
        let bankClerk = BankClerk()
        let bank = Bank(bankClerk: bankClerk)
        let bankManager = BankManager(bank: bank)
        let _ = BankClerkViewController(bankClerk: bankClerk)
        let _ = BankViewController(bank: bank) // 
    ...
    }
    ```
    
- `이유` 그런데 weak키워드를 붙여주니 해당 타입에서 출력해주었던 메소드가 실행되지 않았다. init과 deinit을 통해 디버깅을 해보니 와일드카드 패턴으로 생성한 인스턴스가 생성과 동시에 해제되는 것을 확인할 수 있었다. `와일드카드 패턴`은 값을 해체하거나 무시하는 패턴중 하나이므로 `weak 키워드`가 추가됨과 동시에 retain count가 올라가지 않기 때문에 생성과 동시에 해제되는 것이였다.
- `해결` 사용하지 않는 viewController(은행원, 은행)를 상수에 담으면 xcode에서 경고 메세지가 출력된다. 와일드 카드 패턴을 사용해서 순환참조 문제를 해결할 수 있다고 판단되어 weak 키워드를 제거하고 와일드카드 패턴을 사용하기로 결정했다.
    
    ```swift
    final class Bank {
        private let bankClerk: BankClerk
        private var customerQueue = Queue<Customer>()
        var delegate: BankDelegate?
    ...
    }
    
    func run() {
        let bankClerk = BankClerk()
        let bank = Bank(bankClerk: bankClerk)
        let bankManager = BankManager(bank: bank)
        let _ = BankClerkViewController(bankClerk: bankClerk)
        let _ = BankViewController(bank: bank) 
    ...
    }
    ```
    
---
    
**[Escaping Closure]**

```swift
class ViewModel {
    var completionhandler: (() -> Void)? = nil
    
    func fetchData(completion: @escaping () -> Void) {
        completionhandler = completion
    }
}
```
* Escaping 클로저란?
    * 함수 밖(Escaping)에서 실행되는 클로저
    * 즉 함수 안에서 정의된 클로저가 외부 변수들에 대한 접근을 허용할 때 사용한다.
    * 사용되는 흔한 예로는 비동기로 실행되는 HTTP Request CompletionHandler가 있다.
```swift
func makeRequest(_ completion: @escaping (Result<(Data, URLResponse), Error>) -> Void) {
  URLSession.shared.dataTask(with: URL(string: "http://jusung.github.io/")!) { data, response, error in
    if let error = error {
      completion(.failure(error))
    } else if let data = data, let response = response {
      completion(.success((data, response)))
    }
  }
}
```
> `makeRequest()` 함수에서 사용되는 `completion` 클로저는 함수 실행 중에 즉시 실행되지 않고 URL 요청이 끝난 후 비동기로 실행된다.
> 이 경우에도 `completion`의 타입에 `@escaping`을 붙여서 escaping 클로저라는 것을 명시해줘야 한다.
> 보통 클로저가 다른 변수에 저장되어 나중에 실행되거나 비동기로 실행될 때 escaping 클로저가 사용된다.

* 기본적으로 @escaping 키워드를 따로 명시하지 않는다면 매개변수로 사용되는 클로저는 기본으로 비탈출 클로저이다.
* **클로저가 함수를 탈출할 수 있는 경우**
    * 함수 외부에 정의된 변수나 상수에 저장되어 함수가 종료된 후 사용할 경우
        * 예를 들어 비동기로 작업을 하기 위해서 컴플리션 핸들러를 전달인자를 이용해 클로저 형태로 받는 함수
        * 함수가 작업을 종료하고 난 이후 (즉, 함수의 return 후)에 컴플리션 핸들러, 즉 클로저를 호출하기 때문에 클로저는 함수를 탈출해 있어야만 한다.
        * 함수의 전달일자로 전달받은 클로저를 다시 반환할 때도 마찬가지이다.
* **escaping 클로저임을 명시한 경우**
    * 클로저 내부에서 해당 타입의 프로퍼티나, 메소드, 서브스크립트 등에 접근하려면 self 키워드를 명시적으로 사용해야 한다.
        * escaping 클로저를 사용할 때는 접근할 수 있는 경우의 수가 많기 때문에 어디에 접근하는 것인지 명확하게 해줘야 한다는 것이다.
    * 비탈출 클로저는 self 키워드를 꼭 써주지 않아도 된다.
    * class와 같은 참조 타입이 아닌 Struct, enum과 같은 값타입에서는 mutating reference의 캡쳐를 허용하지 않기 때문에 self 사용이 불가능 하다.

---
**[Auto Closure]**

* 함수의 전달인자로 전달하는 표현을 자동으로 변환해주는 클로저
* 자동 클로저는 전달인자를 갖지 않는다.
* 호출되었을 때 자신이 감싸고 있는 코드의 결괏값을 반호나한다.
* Swift에는 `함수 타입` 이라는 것이 있다.
    * 즉 어떤 상수나 변수에 함수를 저장해둘 수 있다는 말이다.
* 자동클로저는 클로저가 호출되기 전까지 클로저 내부의 코드가 동작하지 않는다. 따라서 연산을 지연시킬 수 있다.
* 이 과정은 연산에 자원을 많이 소모한다거나 부작용이 우려될 때 유용하게 사용할 수 있다.
    * 왜냐하면 코드의 실행을 제어하기 좋기 때문이다.
```swift
var customersInLine: [String] = ["ari", "yong", "han", "hami"]

// 클로저를 만들어두면 클로저 내부의 코드를 미리 실행하지 않고 가지고만 있는다.
let customerProvider: () -> String = {
    return customersInLine.removeFirst()
}

func serveCustomer(_ customerProvider: @autoclosure () -> String) {
    print(customerProvider())
}

serveCustomer(customerProvider()) // ari
```
* String 값을 반환하는 함수를 매개변수로 받는다.
* 여기서 auto closure를 사용하게 되면 함수 타입의 반환타입이 매개변수의 타입이 된다.
    * String 타입의 값을 전달받는 이유는 자동 클로저의 반환타입이 String이기 때문이다.
* 자동 클로저는 전달인자를 갖지 않기 때문에 반환타입의 값이 자동클로저의 매개변수로 전달되면 이를 클로저로 바꿔줄 수 있는 것이다.
* 따라서 자동클로저를 사용하면 기존의 사용방법처럼 클로저를 전달인자로 넘겨줄 수 없다.

---

- 참고링크
    - https://icksw.tistory.com/157
    - https://jusung.github.io/Escaping-Closure/
    - 스위프트 프로그래밍(3판) 264p
