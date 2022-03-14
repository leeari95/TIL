# 220314 MVVM, Rx, changed, coordinator, observable

# TIL (Today I Learned)

3월 14일 (월)

## 학습 내용

- MVVM 활동학습
- RxCocoa - changed
- escaping closure를 RxSwift로 리팩토링해보기
- Coordinator 패턴이란?

&nbsp;

## 고민한 점 / 해결 방법

**[웨더와 함께하는 MVVM 실습!]**

* ViewModel의 경우 UIKit을 import 하지 않는 것이 중요하다.

```swift
import Foundation

class YagomViewModel {
    enum Color {
        case red
        case blue
    }
    private(set) var currentBackgroundColor: Color? {
        didSet {
            listener?()
        }
    }
    private(set) var data: [String] = [] {
        didSet {
            reloadData?()
        }
    }
    
    private var listener: (() -> Void)?
    private var reloadData: (() -> Void)?

    
    func bind(_ closure: @escaping () -> Void) {
        listener = closure
    }
    
    func reloadDataBind(_ closure: @escaping () -> Void) {
        reloadData = closure
    }
    
    func didTapRedButton() {
        changedColor(color: .red)
    }
    
    func didTapblueButton() {
        changedColor(color: .blue)
    }
    
    func didTapApiButton() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.data.append(contentsOf: ["야", "곰", "아", "카", "데", "미"])
        }
    }
    
    private func changedColor(color: Color) {
        currentBackgroundColor = color
    }
}
```
* View는 ViewModel에게 이벤트만을 전달한다.
```swift
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var apiButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel = YagomViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
        tableView.dataSource = self
    }
    
    // 뷰모델과 뷰를 바인딩
    private func setUpBindings() {
        viewModel.bind { [weak self] in
            self?.view.backgroundColor = self?.viewModel.currentBackgroundColor == .red ? .systemRed : .systemBlue
        }
        viewModel.reloadDataBind { [weak self] in
            self?.tableView.reloadData()
        }
    }

    // 뷰모델에게 이벤트만 전달~
    @IBAction func didTapRedButton(_ sender: UIButton) {
        viewModel.didTapRedButton()
    }

    @IBAction func didTapblueButton(_ sender: UIButton) {
        viewModel.didTapblueButton()
    }
    
    @IBAction func didTapApiButton(_ sender: UIButton) {
        viewModel.didTapApiButton()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = viewModel.data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
}
```
* 내 입맛대로 설계해본 MVVM 코드...
* 웨더는 Delegate 패턴으로 구현해주셨지만 나는 Observable이 편해서 Observable 형태로 구현해보았다.
* 데이터를 관찰하면서, 변화할 때마다 특정 클로저를 실행해줄 프로퍼티 옵저버(`currentBackgroundColor`, `data`)를 생성하고, 해당 클로저에 값을 할당해줄 메소드(`bind`, `reloadDataBind`)를 만들어주었다.
* ViewController에서 ViewModel을 생성하고, 바인딩 작업을 해주었다.
    * 컬러가 바뀔 경우 배경색을 바꾸도록 하고, 배열이 변화할 때마다 reloadData() 메소드를 실행하도록 바인딩 해주었다.
* 이후 각 버튼마다 ViewModel에게 이벤트를 전달하도록 ViewModel의 메소드를 호출해주었다.
* TableView는 ViewModel의 data라는 배열로 구성해주었다.
* 이후 실행하면 각 버튼을 누를때, ViewModel에게 이벤트가 전달되고, ViewModel에서는 값을 변경한다. 변경되면 didSet에 등록되어있는 클로저가 실행된다. 해당 클로저는 ViewController에서 바인딩 처리해준 작업들이다.

> 웨더 QnA

* MVVM을 잘~쓰면 좋다.
* 신입들 대부분 MVVM을 제대로 쓰지 못한다. MVVM을 왜쓰는지 알아보고 이유를 갖고 활용하자.
* 그리고 ViewModel이 ViewModel스럽게 올바른 역할을 하고있는지 중요하다.
* 테스트가 가능하도록 역할을 잘 분리하는 것도 중요
    * 클린 아키텍처...내용

> 느낀점

* 너무 어렵지만... 계속 반복하다보면 언젠가 깨달음이 오겠지...?
* 클린 아키텍처는 아직도 어려워...

---

**[Coordinator 패턴]**

### Coordinator란?

* 하나 이상의 뷰 컨트롤러들에게 지시를 내리는 객체이며, 여기서 말하는 지시는 View의 트랜지션을 의미한다.
* 즉, Coordinator는 앱 전반에 있어 화면 전환 및 계층에 대한 흐름을 제어하는 역할을 한다.

### 수행기능

* 화면 전환에 필요한 인스턴스 생성(ViewController, ViewModel ...)
* 생성한 인스턴스의 종속성 주입(DI)
* 생성된 ViewController의 화면 전환

### 왜 사용할까?

* ViewController가 담당하던 화면 전환 책임을 Coordinator가 담당하게되면서, 화면전환 시 ViewController에서 사용할 ViewModel을 함께 주입해줄 수 있다.
* 또한 화면 전환에 대한 코드를 따로 관리하게 되면서 재사용과 유지보수를 편하게 만들어주기 때문에 주로 사용한다.
* 정리하자면 Coordinator는 화면 전환 제어 담당과 의존성 주입을 가능하게 해주는 허브라고 생각하면 될 것 같다.

> 느낀점

* 아 일단 만들어보긴 했는데... 제대로 만든건지 모르겠다... 왤케 어렵지
* 그래도 만들고나니까 화면전환을 viewModel 단에서 해결할 수 있어 개쉬워짐.

---

**[UIAlertController를 Rx스럽게 리팩토링 해보기]**
```swift
func showActionSheet(
    sourceView: UIView,
    titles: (String, String),
    topHandler: @escaping (UIAlertAction) -> Void,
    bottomHandler: @escaping (UIAlertAction) -> Void
) {
    let topAction = UIAlertAction(title: "Move to \(titles.0)", style: .default, handler: topHandler)
    let bottomAction = UIAlertAction(title: "Move to \(titles.1)", style: .default, handler: bottomHandler)
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    alert.addAction(topAction)
    alert.addAction(bottomAction)
    if let popoverController = alert.popoverPresentationController {
        popoverController.sourceView = sourceView
        let rect = CGRect(x: .zero, y: .zero, width: sourceView.bounds.width, height: sourceView.bounds.height / 2)
        popoverController.sourceRect = rect
        popoverController.permittedArrowDirections = [.up, .down]
    }
    navigationController.topViewController?.present(alert, animated: true)
}
```
* 라이언한태 코드리뷰 받고난 후 escaping 클로저만 보면... '아 옵저버블 쓸 수 있을 거 같은데?' 라는 생각에 빠진다.
* 오늘도 어김없이 옵저버블을 쓸 수 있을 것 같아서 찾아보니까... 예제코드들이 많길래 도전해보았다.
* 따라서 위 코드를 아래와 같이 수정해보았다.

```swift
enum ActionType: CaseIterable {
    case top
    case bottom
}

func showActionSheet(sourceView: UIView, titles: [String]) -> Observable<ProjectState> {
    return Observable.create { observer in
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ActionType.allCases.enumerated().forEach { index, _ in
            let action = UIAlertAction(title: "Move to \(titles[index])", style: .default) { _ in
                observer.onNext(ProjectState(rawValue: titles[index]) ?? ProjectState.todo)
                observer.onCompleted()
            }
            alert.addAction(action)
        }
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sourceView
            let rect = CGRect(
                x: .zero,
                y: .zero,
                width: sourceView.bounds.width,
                height: sourceView.bounds.height / 2
            )
            popoverController.sourceRect = rect
            popoverController.permittedArrowDirections = [.up, .down]
        }
        self.navigationController.topViewController?.present(alert, animated: true)

        return Disposables.create {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
```
* 뭐가 많이 바뀐 것 같지만... 별거없다.
* ActionType이라는 enum을 만들고 해당 케이스를 반복하면서 핸들러 내부에 onNext로 ProjectState라는 데이터와 함께 이벤트를 전달해준다.
* 나머지는 iPad를 위한 popover 설정...
```swift
showActionSheet(sourceView: cell, titles: project.status.excluded)
    .subscribe(onNext: { state in
        self.useCase.changedState(project, state: state)
    }).disposed(by: disposeBag)
```
* 사용할 때(구독)는 onNext로 전달받은 state값으로 project의 상태값을 바꿔주는 작업을 해주었다.
* 이때 파라미터로 sourceView를 넘겨주는 이유는 popover를 띄울 위치를 잡기 위함인데... ViewModel에 UIKit을 import해야해서 몹시 불편하다..
* 이부분은 고민해보았지만 좋은 방법이 떠오르지가 않아서 개선하지 못했다.

---

**[UI의 value가 변경되었을 때만 이벤트 받기]**

```swift
let input = DetailViewModel.Input(
    didTapRightBarButton: rightBarButton.rx.tap.asObservable(),
    didTapLeftBarButton: leftBarButton.rx.tap.asObservable(),
    didChangeTitleText: titleTextField.rx.text.asObservable(),
    didChangeDatePicker: datePicker.rx.date.asObservable(),
    didChangeDescription: descriptionTextView.rx.text.asObservable())
    didChangeTitleText: titleTextField.rx.text.changed.asObservable(),
    didChangeDatePicker: datePicker.rx.date.changed.asObservable(),
    didChangeDescription: descriptionTextView.rx.text.changed.asObservable()
)
```
* 처음엔 위와 같이 단순하게 input을 만들어주었는데...
* 이렇게 만들다보니 TextField의 경우 값을 수정하지 않고 tap해서 활성화만 해도 이벤트를 전달받는 것을 확인했다.
    * 이러면 값을 변경하지 않고 modal을 닫아도, 이벤트를 받고 값이 수정된 것 마냥 빈문자열이 들어와서 기존 데이터가 사라지는... 버그가 발생했다.
    * 아무것도 안해도.. Modal만 띄우고 닫아도.. 빈문자열 이벤트를 받아서 데이터가 지워지는....🥲
* 구글링을 해보니 changed라는 ControlProperty를 찾게 되었고, 아래와 같이 값이 변경될때 마다 이벤트를 전달하는 옵저버블로 변경해주었다

```swift
let input = DetailViewModel.Input(
    didTapRightBarButton: rightBarButton.rx.tap.asObservable(),
    didTapLeftBarButton: leftBarButton.rx.tap.asObservable(),
    didChangeTitleText: titleTextField.rx.text.changed.asObservable(), // changed
    didChangeDatePicker: datePicker.rx.date.changed.asObservable(), // changed
    didChangeDescription: descriptionTextView.rx.text.changed.asObservable() // changed
)
```

* 그리고 output을 설정해줄때 논옵셔널 타입으로 설정해주었는데, 옵셔널 타입으로 바꿔주고, nil일 경우 기존 데이터를 전달해서, 값이 임의로 변경되지 않도록 처리해주었다.
* 이렇게 하니까 값을 수정하지 않으면 정상적으로 수정되지 않았고, 해당 문제를 해결할 수 있었다.

---

- 참고링크
    - https://velog.io/@aurora_97/RxSwift-UIAlertController
    - https://velog.io/@dvhuni/UITextField%EC%97%90%EC%84%9C-rx.text%EB%A1%9C-%EB%B3%80%EA%B2%BD%EB%90%9C-%ED%85%8D%EC%8A%A4%ED%8A%B8%EB%A5%BC-%EA%B0%90%EC%A7%80%ED%95%98%EA%B8%B0
    - https://duwjdtn11.tistory.com/644
    - https://jintaewoo.tistory.com/58

