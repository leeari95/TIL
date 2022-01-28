# 220127 UITextField, Animation, MVVM, Observable, UINavigationBarAppearance, Appearance
# TIL (Today I Learned)


1월 27일 (목)

## 학습 내용
- 오픈마켓2 STEP 2 피드백
    - UITextField
- Animation
- MVVM, Observable
- Navigation Bar 설정 바꿔보기
- Appearance를 항상 Dark로 설정되어있게 하기


&nbsp;

## 고민한 점 / 해결 방법

**[UITextField의 입력이벤트를 받아 입력검증하기]**

* 텍스트필드의 텍스트 값이 변함에 따라 메소드를 실행시켜줄 수가 있다.
* addTarget의 controlEvents중에 UITextField의 경우 allEditingEvents 라는 옵션이 있다.
* 이 옵션을 사용하여 실시간으로 사용자의 입력값을 검사하고, 검증되지 않는 값이라면 빨간색 레이블로 사용자에게 입력이 잘못되었음을 알려주도록 할 수 있다.
* 로직은 아래와 같다.
```swift
priceTextField.addTarget(
            self,
            action: #selector(self.verifyPriceTextField(_:)),
            for: .allEditingEvents
        )
```
* 먼저 addTarget을 하여 텍스트필드가 편집중일 때 verifyPriceTextField 메소드가 실행되도록 추가해주었다.
```swift
@objc private func verifyPriceTextField(_ sender: Any?) {
    guard let priceText = textFieldsStackView.priceTextField.text else {
        return
    }
    if priceText.count <= .zero {
        DispatchQueue.main.async {
            self.textFieldsStackView.priceTextField.layer.borderColor = UIColor.red.cgColor
            self.textFieldsStackView.priceTextField.layer.borderWidth = 0.5
            self.textFieldsStackView.priceInvalidLabel.isHidden = false
        }
    } else {
        DispatchQueue.main.async {
            self.textFieldsStackView.priceTextField.layer.borderWidth = 0
            self.textFieldsStackView.priceInvalidLabel.isHidden = true
        }
    }
}
```
* 이 메소드에서는 사용자의 입력값이 없는 경우 기존에 숨겨져있던 "가격을 입력해주세요" 라는 red Color의 label이 나타나며, borderColor에도 색상변경을 주어 입력이 잘못되었음을 알리는 형태이다.
* 만약 사용자가 입력을 제대로 하였다면, 다시 원상태로 복귀하도록 구성되어있다.
* 이렇게 controlEvents를 활용하여 기능을 구현해줄 수 있는 방법을 공부해보았다.

---

**[Animation]**

* 애니메이션은 Closure 기반으로 작성한다.
* 애니메이션이 실행되는 동안 User Information(터치 등)이 일시적으로 disabled되었다가 끝나면 다시 enable 된다.
* 애니메이션이 가능한 속성이 정해져있다.
    * 좌표, 레이아웃 관련 값
        * frame, bounds, center
    * 모양 관련 값
        * transform
    * 색상 관련 값
        * alpha, backgroundColor
* 이렇게 UIView의 몇 가지 속성들을 시작점에서의 현재값과 종료지점을 지정하여 새로운 값으로 변경해주는 것이다.
* UIView를 건드리는 것이기 때문에 background 스레드에서는 작업할 수 없다.
```swift
class func animate(withDuration duration: TimeInterval,
             delay: TimeInterval,
           options: UIView.AnimationOptions = [],
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil)
```
* withDuration
    * 몇 초 동안 애니메이션이 진행될 지 결정한다. 예를 들어 2.0초인 경우 2초동안 애니메이션이 진행된다.
* delay
    * 몇 초 이후에 시작할 지 딜레이를 결정한다
* options
    * 애니메이션의 옵션을 결정한다.
        * .allowUserInteraction
            * 애니메이션 도중 터치 활성화
        * .repeat
            * 애니메이션 무한 반복
        * .autoreverse
            * 반대로도 실행가능 (repeat랑 같이 사용해야한다.)
        * 아래는 애니메이션의 속도를 지정할 수 있는 옵션이다.
            * .curveEaseOut  
                * 끝날 때만 느린 속성
            * .curveEaseIn
                * 시작 시에만 느린 옵션
            *  .curveEaseInOut
                * 시작과 끝이 느린 옵션
* animations
    * 실제로 애니메이션이 될 부분을 정의한다.
        * frame / bounds / center
            * 뷰의 위치와 크기
        * transform
            * 좌표 행렬 값
        * alpha
            * 투명도
        * backgroundColor
            * 배경색
        * contentStretch
            * 확대 / 축소 영역
    * hidden과 같이 중간값 계산이 불가능한 속성을 애니메이션이 안된다.
* completion
    * 애니메이션이 다 종료된 이후 실행되는 부분이다.
    * 클로저 형태로 작성이 가능하며, 없다면 nil 값이다.

**[CGAffineTransform]**

* 뷰의 프레임을 계산하지 않고 2D 그래픽을 그릴 수 있는 타입이다.
* 간단하게 사용 가능하기 때문에 자주 사용하곤 한다.
* CGAffineTransform에서 사용되는 아핀 변환 행렬은 2D 그래픽을 그리는데 사용되는 행렬이다.
* 또한 아핀 변환 행렬은 객체를 회전, 크기 조절, 변환 또는 기울기를 위해 사용된다.
* 아핀 변환을 직접 생성할 필요는 없고 구조체에 있는 함수를 호출해 뷰를 이동(translate), 조절(scale), 회전(rotate)을 한다.
    * rotationAngle
        * 뷰를 회전 시킨다.
    * scaleX
        * 뷰의 넓이와 높이를 조정한다.
    * translationX
        * 뷰의 위치를 이동시킨다.
* 뷰를 원 상태로 복구하려면 CGAffineTransform.identifiy를 호출하면 된다.

**[animateKeyframes]**

* 애니메이션이 끝난 후 다른 애니메이션을 연결하고 싶을때 사용하는 메소드다.
    * 보통 animate의 파라미터 animations 핸들러안에 또 animate를 호출하여 연결하곤 하는데… 이렇게 짜면 가독성이 좋지 못하다.
    * 이럴 때 필요한게 animateKeyframes 메소드다.
* animate 메소드와 같이 UIView의 타입 메소드이다.
* 현재 View에서 key-frame 기반 애니메이션을 설정하는데 사용할 수 있는 애니메이션 블록 객체를 만드는 역할을 한다.

class func animateKeyframes(withDuration duration: TimeInterval,
                      delay: TimeInterval,
                    options: UIView.KeyframeAnimationOptions = [],
                 animations: @escaping () -> Void,
                 completion: ((Bool) -> Void)? = nil)

* withDuration
    * 전체 애니메이션의 지속시간이다. 음수 또는 0을 지정하면 애니메이션 없이 즉시 변경된다.
* delay
    * 애니메이션을 시작하기 전에 대기할 시간을 지정한다.
* options
    * 애니메이션을 어떻게 수행할지 나타내는 옵션.
* animations
    * view에 커밋할 변경내용이 포함된 블록 객체.
    * 일반적으로 이 블록 내무에서 addKeyframe 메소드를 호출한다.
    * 이러한 변경사항을 duration 시간 동안 애니메이션으로 적용하려면, view 값을 직접 변경할 수도 있다.
* completion
    * 애니메이션이 끝나면 실행되는 블록.
    * 핸들러가 호출되기 전에 애니메이션이 끝났는지 여부를 나타내는 single boolean argument를 사용한다.

class func addKeyframe(withRelativeStartTime frameStartTime: Double,
      relativeDuration frameDuration: Double,
            animations: @escaping () -> Void)

* withRelativeStartTime
    * 지정된 애니메이션을 시작하는 시간
    * 이 값을 0에서 1까지의 범위여야 하며, 여기서 0은 전체 애니메이션의 시작을 나타내고 1은 전체 애니메이션의 끝을 나타낸다.
    * 예를 들어 애니메이션의 길이가 2초인 경우 시작시간을 0.5로 시작하면 전체애니메이션이 시작된 후 1초 후에 애니메이션이 시작된다.
* relativeDuration
    * 지정된 값으로 애니메이션을 적용하는데 걸리는 시간이다.
    * 이 값은 0~1 범위에 있어야 하며 전체 애니메이션 길이를 기준으로 한 시간의 양(amount of time)의 양을 나타낸다.
    * 값을 0으로 지정하면 애니메이션 블록에서 설정한 모든 속성이 지정된 시작시간에 즉시 업데이트 된다.
    * 0이 아닌 값을 지정하면 해당 시간 동안 속성이 애니메이션으로 나타난다.
    * 예를 들어 전체 duration이 2초인 애니메이션의 경우 duration을 0.5로 지정하면 애니메이션 지속 시간이 1초가 된다.
* animations
    * 수행하려는 애니메이션이 포함된 블록 객체

**[Basic UIView Animation Tutorial]**

* 튜토리얼을 따라해보며 이해안되는 부분은 다시 복기해가며 공부해보았다.

```swift 
import UIKit
import AVFoundation

class ViewController: UIViewController {
  
  @IBOutlet weak var basketTop: UIImageView!
  @IBOutlet weak var basketBottom: UIImageView!
  
  @IBOutlet weak var fabricTop: UIImageView!
  @IBOutlet weak var fabricBottom: UIImageView!
  
  @IBOutlet weak var basketTopConstraint : NSLayoutConstraint!
  @IBOutlet weak var basketBottomConstraint : NSLayoutConstraint!
  
  @IBOutlet weak var bug: UIImageView!
  
  var isBugDead = false
  var tap: UITapGestureRecognizer!
  
  let squishPlayer: AVAudioPlayer // 사운드 추가를 위한 프로퍼티

  
  required init?(coder aDecoder: NSCoder) {
    let squishURL = Bundle.main.url(forResource: "squish", withExtension: "caf")! // 번들에서 음악파일의 경로를 가져온다.
    squishPlayer = try! AVAudioPlayer(contentsOf: squishURL) // 플레이어를 생성.
    squishPlayer.prepareToPlay() // 재생을 위해 플레이어를 준비한다.
    
    super.init(coder: aDecoder)

    tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:)))
  }
  
  override func viewDidAppear(_ animated: Bool) {
    openBasket()
    openNapkins()
    moveBugLeft()
    view.addGestureRecognizer(tap)
  }
  
  func openBasket () {
    print(basketTopConstraint.constant, basketBottomConstraint.constant)
    basketTopConstraint.constant -= basketTop.frame.size.height
    basketBottomConstraint.constant -= basketBottom.frame.size.height
    print(basketTopConstraint.constant, basketBottomConstraint.constant)
    
    UIView.animate(withDuration: 0.7, delay: 1.0, options: .curveEaseOut) {
      self.view.layoutIfNeeded()
    } completion: { finished in
      print("Basket doors opened!")
    }
  }
  
  func openNapkins () {
    // 1.2초 딜레이 후 1초동안 애니메이션을 실행한다. 1초안에 각 프레임을 curveEaseOut(애니메이션이 끝날 때 느려지는 옵션) 옵션으로 animations가 실행된다.
    UIView.animate(withDuration: 1.0, delay: 1.2, options: .curveEaseOut) {
      print(self.fabricTop.frame, self.fabricBottom.frame)
      var fabricTopFrame = self.fabricTop.frame
      fabricTopFrame.origin.y -= fabricTopFrame.size.height
      
      var fabricBottomFrame = self.fabricBottom.frame
      fabricBottomFrame.origin.y += fabricBottomFrame.size.height
      
      self.fabricTop.frame = fabricTopFrame
      self.fabricBottom.frame = fabricBottomFrame
      print(fabricTopFrame, fabricBottomFrame)
    } completion: { finished in
      print("Napkins opened!") // 애니메이션이 다 종료된 이후 실행되는 부분이다.
    }
    
  }
  
  func moveBugLeft() {
    if isBugDead { return }
    UIView.animate(withDuration: 1.0,
                   delay: 2.0,
                   options: [.curveEaseInOut , .allowUserInteraction]) {
      self.bug.center = CGPoint(x: 75, y: 200) // 뷰의 좌표를 변경한다.
    } completion: { finished in
      print("Bug moved left!")
      self.​faceBugRight()
    }
  }
  
  func ​faceBugRight() {
    if isBugDead { return }
    UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut , .allowUserInteraction]) {
      self.bug.transform = CGAffineTransform(rotationAngle: .pi) // 뷰를 180도로 회전 시킨다.
    } completion: { finished in
      print("Bug faced right!")
      self.​moveBugRight()
    }
  }
  
  func ​moveBugRight() {
    if isBugDead { return }
    UIView.animate(withDuration: 1.0, delay: 2.0, options: [.curveEaseOut, .allowUserInteraction]) {
      self.bug.center = CGPoint(x: self.view.frame.width - 75, y: 250) // 뷰의 좌표를 변경한다.
    } completion: { Boolfinished in
      print("Bug moved right!")
      self.​faceBugLeft()
    }
  }
  
  func ​faceBugLeft() {
    if isBugDead { return }
    UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut , .allowUserInteraction]) {
      self.bug.transform = CGAffineTransform(rotationAngle: 0.0) // 뷰를 다시 원래 방향으로 회전 시킨다.
    } completion: { finished in
      print("Bug faced left!")
    }
  }
  
  @objc func handleTap(_ gesture: UITapGestureRecognizer) {
    let tapLocation = gesture.location(in: bug.superview) // 사용자가 탭한 위치를 구한다.
    if (bug.layer.presentation()?.frame.contains(tapLocation))! { // 그 위치가 bug의 위치와 동일하다면...
      print("Bug tapped!")
      if isBugDead { return } // 버그를 터치하면 애니메이션 체인이 중지되도록 한다.
      view.removeGestureRecognizer(tap) // 더이상 상호작용이 발생하지 않도록 GestureRecognizer에서 제거한다.
      isBugDead = true // 버그가 죽었다...
      squishPlayer.play() // 버그 죽는 소리..ㅠ
      UIView.animate(withDuration: 0.5, delay: 0.0, // 새 애니메이션을 시작한다.
                     options: [.curveEaseOut , .beginFromCurrentState]) {
        self.bug.transform = CGAffineTransform(scaleX: 1.25, y: 0.75) // 뷰의 넓이와 높이를 조정하여 버그를 찌그러뜨린다.
      } completion: { finished in
        UIView.animate(withDuration: 2.0, delay: 0.5, options: []) { // 버그가 죽어서 사라지는 애니메이션
          self.bug.alpha = 0.0 // 알파를 0으로 설정해주고... (버그안뇽....)
        } completion: { finished in
          self.bug.removeFromSuperview() // 버그를 view에서도 지워줌으로써 버그를 죽였다...ㅠ
        }
      }
    } else {
      print("Bug not tapped!")
    }
  }

}
```
* 느낀점
    * 버그의 움직임을 animate의 completion으로 연결해주고 있는데... animateKeyframes를 활용하여 연결해볼 수도 있을 것 같다.

---

**[MVVM Data binding - Observable]** 

* 이번 오픈마켓 프로젝트를 하면서 정말 MVC의 단점을 참을 수가 없었다... 첫 설계부터 MVC 구조였기 때문에, 이후 뷰컨이 커져도 어쩌지 못하는 상황이 정말 아쉬웠다.
* 이 기회에 MVVM이 어떤거고, 어떻게 사용하는지 한번 배워봐야겠다~~~
* MVVM 간단요약
    * View는 ViewModel을 가지고 ViewModel은 Model을 가진다.
    * ViewModel은 입출력을 처리하고 UI가 요구하는 로직을 처리하는 역할만 가진다.
    * VIewModel은 UI를 수정할 수 없다.
* MVVM 패턴 정리
    * 사용자가 화면에서 액션을 취하면 Command Pattern으로 View에서 ViewModel로 전달된다.
    * ViewModel이 Model에게 데이터를 요청하고
    * Model은 요청받은 데이터를 통해 업데이트 된 데이터를 ViewModel에게 전달한다.
    * ViewModel은 응답받은 데이터를 가공해서 저장한다.
    * View는 ViewModel과의 Data Binding을 통해서 자동으로 갱신된다.
* Command Pattern이란?
    * Command = 명령어
    * 실행될 기능을 추상화, 캡슐화하여 한 클래스에서 여러기능을 실행할 수 있도록 하는 패턴이다.
* Data Binding이란?
    * View와 로직이 분리되어 있어도 한쪽이 바뀌면 다른 쪽도 업데이트가 이루어지는 것을 말한다.
* iOS에서 Data Binding을 하는 방법에는 이런 것들이 있다.
    * KVO
    * Delegation
    * Functional Reactive Programming
    * Property Observer
    * ...
* 그 중에서도 Observable이라는 패턴이 눈에 띄어서 알아볼 것이다.


```swift
// MARK: - Observable
class Observable<T> {
    private var listener: ((T) -> Void)?
    var value: T { // 값이 set될 때마다 listener를 호출
        didSet {
            listener?(value) // bind를 통해 클로저를 전달받은 상태이면, value값이 변동이 있을 때마다 해당 클로저를 실행할 것이다.
        }
    }
    
    init(_ value: T) { // [1] value를 저장한다~
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) { // 이 메소드를 호출하게되면 value에 저장했던 값을 전달해준다.
        closure(value)
        listener = closure // listener에게 closure를 전달한다.
    }
    
}
// MARK: - Model
struct User: Codable {
    let name: String
}

// MARK: - ViewModel

struct UserViewModel {
    var users: Observable<[User]> = Observable([]) // 모델을 가지고있는 옵저버블.
}
// MARK: - Controller

class ViewController: UIViewController {
    
    private var viewModel = UserViewModel()
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        
        viewModel.users.bind { [weak self] _ in // bind 메소드를 통해 listener에 클로저를 전달한다.
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        fetchData() // fetchData를 통해 value를 대입해준다.
        // 그러면 이전에 bind 메소드를 통해 reloadData를 전달받은 listener가
        // value의 값이 변경되는 지점에 호출되어 tableView에 값이 업데이트 될 것이다.
    }

    func fetchData() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                return
            }
            guard let userModels = try? JSONDecoder().decode([User].self, from: data) else {
                return
            }
            self.viewModel.users.value = userModels.compactMap({ newUser in
                User(name: newUser.name) // 여기에서 value의 값을 새롭게 대입해주고 있다~
            })
        }
        task.resume()
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.users.value[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.value.count
    }
}
```
* 위 예제를 살펴보자면 viewDidLoad에서 viewModel.users.bind를 호출하고, 그 다음에 fetchData를 호출한다.
* bind를 통해 먼저 Observable의 listener에 클로저를 대입해준다.
    * 내부에 reloadData가 listener에 대입된다고 보면 된다.
* 그 후 fetchData를 살펴보면 네트워크를 통해 data를 가져와서 viewModel.users.value에 대입을 해주고 있는 것을 볼수가 있다.
    * Observable의 value는 프로퍼티 옵저버다.
    * didSet시 listener를 호출하도록 되어있다.
    * 따라서 value의 값이 set 될 때 마다, reloadData가 호출된다고 보면 될 것 같다.
* 이런식으로 구현하게 되면 뷰와 뷰모델이 양방향으로 바인딩이 되어있기 때문에 한쪽에 변화가 생기면 다른 한 쪽도 자동으로 업데이트 되게 된다.
* 장점
    * 유지보수에 좋다
    * 자동화된 테스팅에 적합한 모델이다. (뷰모델과 뷰간의 의존성이 없기 때문)
    * 새로운 개발자라도 빠르게 적응이 가능하고 개발이 가능한 수준의 난이도와 복잡성
* 단점
    * 단순한 프로젝트를 개발하기에는 MVC에 비해서는 시간이 오래걸린다.

---

**[Navigation Bar 커스텀하기]**

* https://developer.apple.com/documentation/uikit/uibarappearance
```swift
private func setUpNavigationItem() {
    self.navigationItem.title = "asdf"
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
    appearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterialDark)
    self.navigationController?.navigationBar.standardAppearance = appearance
    self.navigationController?.navigationBar.compactAppearance = appearance        
}
```
* `configureWithTransparentBackground()`
    * 네비게이션바를 불투명하게 해주는 메소드
* `backgroundEffect`
    * https://developer.apple.com/documentation/uikit/uiblureffect/style
    * 여러가지 스타일이 존재한다. 다크모드, 라이트모드로 나누어져 있다.
    * `UIBlurEffect(style: .systemChromeMaterialDark)``
* standardAppearance
    * 표준 높이의 설정

---

**[앱이 항상 다크했음 좋겠따...]**

* 사용자의 모드가 라이트든 다크든 다 무시하고 항상 다크이고 싶다면...?
* ![](https://i.imgur.com/XxhS8QN.png)
* info.plist에서 Appearance 키를 추가하여 value에 Dark를 주면 된다.


---

- 참고링크
    - https://developer.apple.com/documentation/uikit/uiview/1622451-animate
    - https://developer.apple.com/documentation/uikit/uiview/animationoptions
    - https://developer.apple.com/documentation/coregraphics/cgaffinetransform
    - https://hyerios.tistory.com/14
https://seungchan.tistory.com/entry/7%EC%A3%BC%EC%B0%A8-%EC%84%B8%EB%AF%B8%EB%82%98-Animation
https://www.youtube.com/watch?v=iI0LabCYZJo
