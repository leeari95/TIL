# 220106 UISegmentedControl, 오픈마켓PR1피드백
# TIL (Today I Learned)


1월 6일 (목)

## 학습 내용
- 오픈 마켓 프로젝트 STEP 1 PR 작성, README 작성
    - 이후 저녁엔 피드백 코멘트 달기
- UISegmentedControl를 알아보기
- UICollectionView로 List 만드는 튜토리얼 따라해보기


&nbsp;

## 고민한 점 / 해결 방법

**[피드백 받으면서 얻은 꿀팁]**

* SwiftLint Rule
    * Supports autocorrection
* 스네이크 케이스에서 단순히 카멜케이스로 바꿔주는 코딩키 전략
    * KeyDecodingStrategy, KeyEncodingStrategy
- Apple에서 만든 SwiftFormat
    - https://github.com/apple/swift-format
- SwiftLint를 사용할 때 Pods도 보통 excluded 처리해주곤 한다.
    - 나중에 외부라이브러리를 사용하게 된다면 활용해보자!
- 코드 작성시 한 라인에 워딩수를 제한할 때 메서드명과 파라미터가 길어진다면?
    - https://google.github.io/swift/#function-declarations
    - 아래처럼 해주는 이유는 개발자들은 가로를 보는것보다 세로를 보는 것이 더 편하기 때문이다. 화면 해상도도 다 다르고... 등등...
```swift
public func performanceTrackingIndex<Elements: Collection, Element>(
  of element: Element,
  in collection: Elements
) -> ( // 내려쓰기를 이렇게하네 허허~
  Element.Index?,
  PerformanceTrackingIndexStatistics.Timings,
  PerformanceTrackingIndexStatistics.SpaceUsed
) {
  // ...
}
```
- 나중에가면 네트워크 테스트시 실제 사용자 입장에서 테스트해야하기 때문에 fake 테스트를 활용한다고 한다.
    - 예를들어 결졔화면을 테스트해야한다면 실제 네트워크를 사용해서 결제하는척 테스트하고 마지막에 결제는 되지않는 fake 코드를 같이 짠다고 한다.
    - https://blog.pragmatists.com/test-doubles-fakes-mocks-and-stubs-1a7491dfa3da?gi=e7d32c619169

---

**[세그먼트 컨트롤을 네비게이션 바 아이템으로 올리기]**
```swift
// UISegmentedControl의 글꼴 색상 변경하기 (selected, normal)
let normal: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
let selected: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemBlue]
control.setTitleTextAttributes(normal, for: .normal)
control.setTitleTextAttributes(selected, for: .selected)


/* 코드로 세그먼트 컨트롤 커스텀 해보기 */
// 커스텀 세그먼트 컨트롤 코드
class CustomeSegmentedControl: UISegmentedControl {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 4 // 테두리를 둥글게 해줌
        layer.borderWidth = 1 // 배경의 너비?
        layer.borderColor = UIColor.white.cgColor // 배경 색깔
        layer.masksToBounds = true
    }
}
// 뷰컨 내부에 프로퍼티로 추가 (코드로 세그먼트 컨트롤 설정하기)
lazy var segmentedControl: CustomeSegmentedControl = {
    let items = ["LIST", "GRID"]
    let control = CustomeSegmentedControl(items: items)
    let normal: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
    let selected: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemBlue]
    control.selectedSegmentIndex = 0
    control.setTitleTextAttributes(normal, for: .normal)
    control.setTitleTextAttributes(selected, for: .selected)
    control.tintColor = .white
    control.backgroundColor = .systemBlue
    return control
}()

// ...
override func viewDidLoad() {
    super.viewDidLoad()

		// 네비게이션 아이템에 세그먼트 컨트롤 추가
    self.navigationItem.titleView = segmentedControl

}
```
* 느낀점
    * 음... 세그먼트 디자인때문에 이렇게까지 해야할까....
    * 이게 좋아진 버전이라던데...
    * 그린한태 이야기해봤는데, 프로젝트와 꼭 동일한 디자인을 가질 필요는 없으니 너무 디테일하게 똑같이 안따라해도 된다고 말씀해주셨다. 좀 편안...

---

**[세그먼트 컨트롤을 활용하여 뷰 전환하기]**

* ![](https://i.imgur.com/n6XhuJC.png)
    * 네비게이션 컨트롤러를 embed in 해준다.
    * 네비게이션 바에 세그먼트 컨트롤러를 올려준다.
    * 그리고 뷰에 컨테이너 뷰를 올리게 되면 위 사진과 같이 뷰컨트롤러가 자동으로 생기면서 세그가 연결되는데, 두개를 연결해준다.
    * 노란색, 파란색 뷰컨에는 UIView가 올라가있는데, 이것을 IBOutlet으로 연결시켜준다.
    * 그리고 세그먼트에 IBAction을 연결하여 선택된 인덱스에 따라 isHidden을 활용해서 한쪽을 숨겨주면 완성.
```swift
class ViewController: UIViewController {
    @IBOutlet var button: UISegmentedControl! {
        didSet {
            let normal: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
            let selected: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemBlue]
            button.setTitleTextAttributes(normal, for: .normal)
            button.setTitleTextAttributes(selected, for: .selected)
        }
    }
    @IBOutlet var listView: UIView!
    @IBOutlet var gridView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gridView.isHidden = true
    }
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            listView.isHidden = false
            gridView.isHidden = true
        } else {
            listView.isHidden = true
            gridView.isHidden = false
        }
    }
}
```
* ![](https://i.imgur.com/rFr9XHX.gif)

---

* 이후 콜렉션뷰 튜토리얼을 공부하다가 피드백을 받고 뻗어잤다.


---

- 참고링크
    - https://youtu.be/A6vxDDAUj2o
    - https://stackoverflow.com/questions/63585391/uisegmentedcontrol-corner-radius-not-changing
    - https://swiftsenpai.com/development/uicollectionview-list-basic/
    - https://www.raywenderlich.com/16906182-ios-14-tutorial-uicollectionview-list
    - https://developer.apple.com/documentation/foundation/jsondecoder/2949119-keydecodingstrategy
    - https://developer.apple.com/documentation/foundation/jsonencoder/2949141-keyencodingstrategy/
    - https://github.com/apple/swift-format
