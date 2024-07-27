# 220215 Dropbox, weak self, escaping, Delayed Deallocation, performBatchUpdate, setEditing
# TIL (Today I Learned)

2월 15일 (화)

## 학습 내용

- Dropbox는 뭘까...
- weak self는 언제 사용할까?
- UITableView - performBatchUpdate
- UITableView - 셀을 스와이프 했을 때 select 유지하기

&nbsp;

## 고민한 점 / 해결 방법

**[Dropbox]**

아이클라우드, 구글 드라이브 같은 놈이다.
* https://www.dropbox.com/developers/apps
* 먼저 위 링크로 들어가서 가입하고 APP_KEY를 생성해야 한다.
* 그리고 info.plist에 다음과 같은 key를 추가해야 한다.
* ![](https://github.com/dropbox/SwiftyDropbox/blob/master/Images/InfoPlistExample.png?raw=true)
* DropboxClientsManager를 활용해서 인증, 로그인, 다운로드, 업로드 등등을 할 수 있는 것 같은데, 더 자세히 보려면 일단 프로젝트에 라이브러리 설정부터 해야할 것 같다. 
* 튜토리얼만 쭉 훑어보았다...

---

**[weak self는 언제 사용해야할까?]**

> 코드리뷰 받던 중 escaping 관련 질문이 들어왔는데.. 훑어본 기억만 있지 자세히 알아보진 않았던 것 같아서 찾아보았다.

* escaping은 주로 네트워킹을 할 때 사용하게 되는데, 그 이유는 네트워킹의 경우 실행이 언제 종료되는지 예측하기 어렵기 때문이다.
* non-escaping은 코드를 즉시 실행하고 나중에 저장하거나 실행할 수 없다. scope 내에서 실행되기 때문이다.
* escaping은 저장될 수 있고 다른 클로저로 전달될 수 있으며 미래의 어느 시점에 실행될 수 있다.
* escaping 과 non-escaping의 가장 큰 차이는 메모리적인 차이가 존재한다.
    * escaping을 붙이게 되면 클로저 내부를 실행하기 위해 캡쳐를 한다.
    * 즉 메모리를 확보한다는 말이다.
    * 만약 클로저 내부에 엄청 느린 로직이 있어서 객체가 죽는 시점보다 클로저 종료 시점이 더 느린 상황이 온다면, 객체가 죽어야하는데... 클로저 실행이 끝나기 전까지는 self가 죽지 않고 살아서, 메모리가 해제되지 않는다. 
    * 즉 메모리 누수가 발생한다.
    * 따라서 weak를 사용하게 되는데, weak를 붙이게 되면 참조하고 있는 객체가 죽어버리면, 아예 클로저 자체를 실행하지 않고 날려버린다.

> 그렇다면 weak self는 언제 사용하게 될까?

* 한 프로퍼티에 저장되거나 다른 클로저로 전달될 때
* 클로저에 있는 객체(self)가 해당 클로저나 넘겨진 클로저에 strong reference를 지닐 때
* 간단한 코드예시
```swift
class PresentedController: UIViewController {
  var closure: (() -> Void)?
}

class MainViewController: UIViewController {
  
  var presented = PresentedController() // PresentedController 소유

  func setupClosure() {
    presented.closure = printer 
      // 탈출 클로저에 함수를 할당하므로써, 
      // PresentedController가 self(MainViewController)를 소유하게 된다.
  }

  func printer() {
    print(self.view.description)
  }
}

// 따라서 이럴때 아래처럼 weak를 할당해주어야 한다.
func setupClosure() {
  self.presented.closure = { [weak self] in 
    self?.printer() 
  }
}
```

> ### Delayed Deallocation

* Delayed Deallocation은 Escaping 및 Non-escaping 클로저에서 나타나는 부작용이다.
* 정확히 메모리 누수는 아니지만 원하지 않는 동작으로 이어질 수 있다.
    * 예시) Controller를 해제했지만, 보류중인 모든 클로저 작업이 완료될 때 까지 메모리가 해제되지 않음
* 기본적으로 클로저는 본문에서 참조하는 모든 객체를 강력하게 캡쳐하기 때문에 클로저 본문이나 범위가 살아있는 한 객체가 메모리에서 할당 해제되는 것을 방해한다.
* 이 경우 Escaping 및 Non-escaping 클로저 모두 [weak self]를 사용하면 Delayed Deallocation을 방지할 수 있다.

> ### guard let self = self else { return } 

* Delayed Deallocation가 나타날 수 있는 클로저에서 위 구문을 사용한다면 Delayed Deallocation을 방지할 수 없다.
* `guard let` 구문이 하는 일은 self가 nil과 같은지 여부를 확인하고, 그렇지 않은 경우 범위 기간 동안 self에 대한 `일시적인 강력한 참조를 생성`하는 것이다.
* 즉, `guard let` 구문은 클로저의 수명 동안 self가 할당 해제되는 것을 방지해 self가 유지되도록 보장한다.

---

**[UITableView - performBatchUpdate]**

https://developer.apple.com/documentation/uikit/uitableview/2887515-performbatchupdates

* Row와 Section을 일괄적으로 업데이트 하는 방법에는 애플의 공식문서에 경우 3가지 메소드를 통해 소개하고 있다.
    * `beginUpdates()`
    * `endUpdate()`
    * `performBatchUpdates(_:completion)`
* 공식문서에는 가능한 한 `beginUpdates()` `endUpdate()` 대신에 `performBatchUpdates(_:completion)` 메소드를 사용하라고 가이드하고 있다.
* ![](https://i.imgur.com/thfOYGf.png)
* 여러개의 삽입, 삭제, reload 그리고 이동하는 동작을 그룹으로 애니메이션을 통해 보여준다.
```swift
func performBatchUpdates(_ updates: (() -> Void)?, 
              completion: ((Bool) -> Void)? = nil)
```
* `updates`
    * 삽입, 삭제, reload, 이동하는 동작을 수행하는 블럭
    * 테이블의 행의 수정하는 것에 추가로, 이런 수정 사항을 반영하기 위해 테이블의 data source를 업데이트 한다
    * 이 블럭은 return 값이 없고 인자를 가지지 않는다.
* `completion`
    * 모든 동작이 끝나면 실행할 블럭
    * `finshed`
        * 애니메이션이 성공적으로 끝났는지를 나타내는 Bool 값
        * 애니메이션이 어떤 이유로든 방해받아서 끝나지 못했다면 false가 된다.
* 이 메서드는 테이블 뷰에 가해지는 여러 변화들이 각각 별도의 애니메이션을 통해 보여지는게 아니라 하나의 애니메이션으로 보여주고 싶을 때 사용한다.
* 하나의 애니메이션으로 보여주고 싶은 동작들을 `update` 블럭안에 넣으면 된다.
* 참고로 삭제하는 동작은 `updates` 내에 코드 순서가 어떻든 간에 항상 삽입하는 동작보다 먼저 처리된다.
* batch operation 전에 삭제를 위한 인덱스들이 테이블 뷰의 상태에 대한 인덱스를 제공하는 것과 비슷하게 처리되고 삽입에 대한 인덱스들이 모든 삭제하는 동작 이후에 처리된다는 것을 의미하기 때문이다.

---

**[UITableView - 셀을 스와이프 했을 때 select 유지하기]**

> 메모장 앱 프로젝트 하는 도중 UITableView의 셀을 스와이프하면 deselect 되는 것을 발견했다. deselect가 자동으로 되는 것 같은데, select를 유지할 수는 없을까?

구글링을 해보니 [stackoverflow](https://stackoverflow.com/questions/55220042/swiping-on-a-tableview-is-deselecting-all-selected-rows-trailingswipeactionsconf)에서는 `setEditing` 메소드를 활용해서 해결할 수 있다는 답변이 있었다.

[setEditing(_:animated:)](https://developer.apple.com/documentation/uikit/uitableview/1614876-setediting)이라는 메소드가 뭐하는 메소드인지 한번 알아보았다.
디버깅을 해보니 스와이프를 할 때 editing이 true, 스와이프를 취소하거나 종료되었을 때 editing이 false로 전달되고 있었다.
이를 활용해서 select를 유지하는 방법을 구현해보았다.

* seletedIndex라는 프로퍼티를 선언한다.
```swift
var selectedIndex: IndexPath?
```

* 그리고 셀이 didSelect 될 때마다 위 프로퍼티에 값을 할당해주도록 한다.
```swift
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    ...
    selectedIndex = indexPath
}
``` 

* 이후 setEditing(_:animated:) 메소드를 재정의 해주어 아래와 같은 로직을 추가해주었다.
```swift
override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        guard let splitVC = self.splitViewController as? SplitViewController else {
            return
        }
        // 저장했던 인덱스를 선언
        let selectedIndex = self.selectedIndex ?? IndexPath(row: .zero, section: .zero)
        if editing { // 편집모드에 들어간다면
            // 셀을 다시 선택하도록...
            tableView.selectRow(at: selectedIndex, animated: false, scrollPosition: .none)
        } else { // 편집모드가 종료되었다면
            splitVC.clearNoteTextView() // 메모영역을 지우고
            guard self.tableView.numberOfRows(inSection: .zero) != .zero else { // 안전하게 select하기 위한 guard문
                return
            }
            splitVC.present(at: selectedIndex.row) // 새로운 인덱스의 메모장을 present
            // 이후 새로운 인덱스로 select되도록 한다.
            tableView.selectRow(at: selectedIndex, animated: false, scrollPosition: .none)
        }
    }
```

> 문제

```
Thread 1: "request for rect at invalid index path
```
* 선택한 셀보다 위에 위치해있는 셀을 스와이프해서 삭제하였더니 Crash가 발생했다.
* `이유`는 셀 삭제를 처리할 때 위에서 선언해주었던 selectedIndex 변수에 별다른 처리를 해주지 않아서였다.
* 즉, 셀을 삭제할 때마다 IndexPath의 row의 총 개수가 1씩 줄어드는데, 이를 deleteRows를 할 때 동시에 처리해주지 않았었다.

> 해결 방법

셀을 deleteRows 메소드를 호출하여 삭제할 때, selectedIndex 프로퍼티의 row도 줄어들 수 있도록 1씩 차감해주도록 하였다.

```swift
if let selectedIndex = selectedIndex, selectedIndex >= indexPath {
            /*
             만약 저장한 select 인덱스가 삭제하는 인덱스보다 크다면 차감해주어야 크래쉬가 발생안한다.
             이유는 셀이 삭제됨과 동시에 selectedIndex로 selectRow 메소드를 호출해주는데,
             셀의 총 갯수가 셀이 삭제되면서 차감되므로 deleteRows 이후 다시 정확히 select 하려면
             1개 차감된, 즉 변동된 row를 select 해야되기 때문이다.
             */
            self.selectedIndex?.row = selectedIndex.row - 1 > 0 ? selectedIndex.row - 1 : 0
            // row 값을 차감할 때 -1이 되지 않도록 삼항 연산자 구현
        }
```

* 이를 처리해주지 않는다면, 잘못된 인덱스 경로로 셀을 select 하게 되므로 Crash가 발생할 수 있다.


---

- 참고링크
    - https://velog.io/@haanwave/Article-You-dont-always-need-weak-self
    - https://kkimin.tistory.com/35
    - https://github.com/dropbox/SwiftyDropbox#swift-package-manager
