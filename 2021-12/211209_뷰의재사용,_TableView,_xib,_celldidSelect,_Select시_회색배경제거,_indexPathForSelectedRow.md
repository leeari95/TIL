# 211209 뷰의재사용, TableView, xib, celldidSelect, Select시 회색배경제거, indexPathForSelectedRow
# TIL (Today I Learned)


12월 9일 (목)

## 학습 내용
- TableView의 재사용
- Auto Layout 강의
- 만국박람회 STEP 2 진행
- 취뽀 성공하신 2기분들의 QnA

&nbsp;

## 고민한 점 / 해결 방법
**[뷰의 재사용, 활동학습 중...]**
* cell을 dequeue하는 메소드에 복잡한 로직을 추가하는 것은 성능면에서 비효율적이기 때문에 지양한다.
* 대신 셀이 Reuse Queue에 들어가 있을 때 로직을 추가하도록 한다.
```swift
// 여러가지 실험해본 예제코드
// 메소드 실행순서를 브레이크 포인트를 찍어가며 확인.
import UIKit

class ViewController: UIViewController {
    var count = 0
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//    }
}
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        print(#function) // [1] 셀을 가져오기전에 호출된다
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function, count)
        count += 1
        return 3 // [3] 섹션당 로우는 몇개인지
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function, indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = "\(indexPath.section), \(indexPath.row)"
        cell.contentConfiguration = content
        
        if indexPath.row == 1 { // 재사용 셀을 확인해보는 코드
            cell.backgroundColor = .yellow
        }
        
        return cell // [4] 셀을 다 가져왔으면 화면에 보여줄 셀을 표시하기 시작한다.
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print(#function)
        return "Section \(section)" // [2] 셀을 가져올때 타이틀을 만들어준다, [5] 화면에 보여줄 섹션을 마지막에 불러온다.
    }
    
}
class MyCell: UITableViewCell {
    override func prepareForReuse() { // 큐에 들어가 있다면 색상을 바꾸삼
        // 이녀석도 스크롤 할때마다 호출되기는 하지만 우선순위는 낮다.
        super.prepareForReuse()
        print(#function)
        self.backgroundColor = .white
    }
}
```

---

**[Auto Layout]**
* 최대한 View가 계산을 덜 하는 방향으로 제약을 잡아주는 것이 바람직하다.
* 뷰 스스로 또는 뷰 사이의 관계를 속성을 통하여 정의한다. 제약은 방정식으로 나타낼 수 있다.
* ![](https://i.imgur.com/iXTxstM.png)
* 제약조건을 주는 것이 어렵다면 글로 방정식을 적어보며 정리해보는 것도 방법이다.
* STEP 2를 진행하면서 지성과 함께 오토 레이아웃 삽질좀 해보았다. (원래는 STEP 3에서 하는거지만 못참겠어서...)
* 삽질하고 나니 왜 이 간단한걸 몇시간동안이나 삽질했는지 현타가 좀왔다...
* ![](https://i.imgur.com/Q1RhOD7.png)
    * Horizontal 스택뷰를 만들고 안에 이미지뷰와 vertical 스택뷰를 추가한다.
    * alignment를 center로, distribution은 fill spacing은 8
    * 내부 이미지뷰의 너비를 vertical 스택뷰와 equal로 맞추고 Mutiplier를 0.2만큼 준다.
    * 이후 이미지뷰에 aspect를 1:1로 잡아준다.
    * Horizontal 스택뷰의 top, bottom, leading, trailing을 Superview 기준으로 잡는다.
    * top, bottom은 12 만큼 띄어주고 leading, trailing은 15 만큼 띄어준다.
    * alignment, distribution은 fill, spacing은 2
* 스크롤뷰도 메인도 상세화면도 삽질의 연속이였다. 나의 부족함이 제일 큰 문제겠지..
* ![](https://i.imgur.com/VGagsPN.png)
    * 스크롤뷰의 제약은 슈퍼뷰와 top, bottom, leading, trailing을 Superview 기준으로 잡아주었다.
    * 이후 콘텐츠뷰인 스택뷰의 top, bottom, leading, trailing와 너비와 높이를 모두 제약을 걸어주니 해결되었다.
* STEP 3때 또 삽질할 생각하니 정말 신난다.

---

### 12/9일자 프로젝트를 하면서 얻었던 지식

**[셀이 didSelect 되었을 때 화면 이동하기]**

* ![](https://i.imgur.com/HkWjrjZ.png)
* 셀의 악세사리 `Disclosure Indicator`를 추가
* ![](https://i.imgur.com/hiouNGu.png)
* 테이블 뷰의 Selection을 `Single Selection`으로 지정해준다.
* ![](https://i.imgur.com/I0lrhAg.gif)
* 스토리보드에서 `Segue`를 생성해주고,
* ![](https://i.imgur.com/AVg2X23.png)
* `Identifier`를 지정해준다.
* 이후 코드로 돌아가서 Delegate 프로토콜을 활용한다
    * 셀이 눌렸을 때 호출되는 메소드를 호출하고, performSegue를 활용하여 화면전환을 한다.

```swift
extension ItemListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ItemDetailView", sender: nil)
    }
}
```

---

**[셀이 Select되었을 때 남는 회색배경 없애기]**

* ![](https://i.imgur.com/8aTrGCb.gif)
* 셀을 클릭해서 화면전환후 다시 돌아와도 셀의 배경색이 안없어지는 현상이 일어났다.
* 테이블뷰의 셀이 선택되면 회색으로 변하게 되는데, 문제는 이렇게 변한 색이 그대로 유지된다.
* 테이블 뷰의 셀을 선택하면 회색으로 변했다가 다시 원래 색으로 바로 돌아오게 하려면 아래 메소드를 사용해주면 된다.
```swift
extension ItemListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
```
* 적용후
* ![](https://i.imgur.com/BNkoL1h.gif)

---

**[xib로 만든 TableViewCell을 TableView에 등록하는 방법]**
* Cocoa touch class를 생성시 xib도 동시에 생성할 수 있다.
* ![](https://i.imgur.com/nwz8zTx.png)
* 이런 xib로 만들어진 cell을 TableView에 등록해주려면 어떻게 해야할까?
* ![](https://i.imgur.com/6D8WV11.png)
* 먼저 Custom Cell의 Identifier를 설정해준다.
* ![](https://i.imgur.com/IOU3yAx.png)
* 그리고 TableView를 IBOutlet으로 추가한 ViewController를 열어서 아래 코드를 viewDidLoad에 추가해주면 된다.
```swift
private func registerXib() {
    let nibName = UINib(nibName: "CustomTableViewCell", bundle: nil)
    tableView.register(nibName, forCellReuseIdentifier: "customCell")
}
```
* 이후 tableView의 DataSource와 Delegate를 사용하여 셀의 데이터를 추가해주면 된다.

---

**[선택한 셀의 indexPath를 알아내는 방법]**
* prepare에서 선택한 셀의 indexpath를 알아야했다.
    * 다음화면에 선택한 셀의 정보를 바로 넘겨주기 위함.
* TableView 속성을 찾아보니 선택된 셀의 indexpath를 반환하는 프로퍼티가 있었다.
```swift
var indexPathForSelectedRow: IndexPath? { get }
```

---

**[2기분들의 취뽀 후기]**
* 취뽀하신 2기분들의 후기를 들어보니 캠프를 열심히 하면 되겠다는 생각이 들었다. (활동학습, 기록 등등..)
* 최신 기술도 좋지만 기본기부터 탄탄하게 다지는 것이 중요하다고 느껴졌다.
* README는 결국에 바쁜 면접관들이 보는 것이니 길게 적을 필요없다.
* 핵심적인 내용 위주로 현업에서 자주 쓰이는 것을 집중해서 작성하고, 차별화를 두는 것에 집중하자.
* 캠프를 수료 후 기존에 했던 프로젝트를 변형해보는 것도 방법이다.
* 돈이 최고다.
---

- 참고링크
    - https://baked-corn.tistory.com/124
    - https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=jdub7138&logNo=220963701224
    - https://developer.apple.com/documentation/uikit/uitableview/1614989-deselectrow
    - https://developer.apple.com/documentation/uikit/uitableview/1615000-indexpathforselectedrow
    - https://leeari95.tistory.com/54
    - https://leeari95.tistory.com/59
