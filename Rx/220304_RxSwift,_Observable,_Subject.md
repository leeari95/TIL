# 220304 RxSwift, Observable, Subject

# TIL (Today I Learned)
3월 4일 (금)

## 학습 내용

- RxSwift를 활용하여 ViewModel 리팩토링 하기

&nbsp;

## 고민한 점 / 해결 방법

* 기존에는 Observable을 직접 구현하여 bind를 해주고 있었으나, Rx로도 할 수 있는 걸 왜.. 직접 구현하고 있지? 라는 의문이 들었다. 모른다고 회피하다가... 찝찝했는지 ViewModel을 꼭!!! Rx로 리팩토링 꼭!!! 해보고싶어서 삽질을 시작하게 되었다.

```swift
final class ProjectListViewModel {
...
    var deleted: Observable<IndexPath>
...

class ViewController: UIViewController {
    
    func viewDidLoad() {
        viewModel.deleted.asObservable()
            .subscribe(onNext: { indexPath in
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }).disposed(by: bag)

    }
...
```
* 일단 ViewController에서는 위와 같은 방식으로 바인딩 해주어서 사용해주고 싶었다.
* 처음에는 직접 구현한 Observable이 아니라 Rx의 Observable을 활용해보려고 했었는데, 실패했다.
* `이유` 그 이유는 Observable의 경우 값을 넘겨주는 역할만 하지 값을 외부에서 받아들여서 넘겨주는 역할은 하지 않기 때문이다.
* `해결` 따라서 값을 받아먹을 수 있으면서 이 값을 외부에서 컨트롤할 수 있는 것이 뭐가 있을까 찾아보다가 `Subject`라는 오퍼레이터를 알게되었다.

---

**[RxSwift로 데이터 바인딩 해보기]**

데이터 바인딩을 통하여 테이블뷰의 delete 이벤트가 발생되면, 그에 따라 데이터도 제거해주고, 해당하는 셀이 알아서 제거될 수 있도록 해볼 것이다.

먼저 ViewModel에 셀을 제거하기 위해 필요한 IndexPath 데이터를 가지고 있는 `PublishSubject<IndexPath>`를 생성한다.

```swift
final class ProjectListViewModel {
    var deleted = PublishSubject<IndexPath>()
// ...
```

> `Subject`란?
> Observable은 값을 넘겨주는 역할을 하지, 값을 외부에서 받아들여서 넘겨주는 역할은 하지않는다. 그래서 Observable처럼 값을 받아먹을 수는 있는 애인데 외부에서 이 값을 컨트롤할 순 없을까? 하고 나온 것이 Subject이다. Observable과 Observer역할을 동시에 수행한다.
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

내가 원했던 것은 새 이벤트가 발생했을 때에만 subscribe가 실행되었으면 했다. 따라서 새로운 이벤트만 전달받고 이전에 발생했던 이벤트는 버리는[?] PublishSubject를 선택했다.

이후 이벤트를 발생시키기 위해 위에서 생성했던 deleted에 데이터를 전달하는 ViewModel에 메소드를 생성하였다.

```swift
func delete(_ indexPath: IndexPath, completion: ((Project?) -> Void)?) {
        useCase.delete(projects[safe: indexPath.row]) { item in
            guard let item = item else {
                self.errorMessage.onNext("삭제를 실패했습니다.")
                completion?(nil)
                return
            }
            self.projects = self.useCase.fetch()
            self.deleted.onNext(indexPath)
            completion?(item)
        }
    }
```

보면 인자로 받은 indexPath를 deleted에 전달하고 있는 형태이다.
이렇게 onNext로 새 데이터를 전달할 때마다 subscribe가 실행된다고 보면된다.

ViewController에 가서 바인딩을 해주자.

```swift
class ViewController: UIViewController {

    var viewModel = ProjectListViewModel()
    
    @IBOutlet weak var tableView: UITableView!

    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        bind()
    }
    
    func bind() {
        viewModel.deleted
            .subscribe(onNext: { indexPath in
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }).disposed(by: bag)
    }
// ...
}
```

전달받은 indexPath로 셀을 지울 수 있도록 deleteRows 메소드를 호출해주었다.
그리고 Delegate 메소드에서 delete 이벤트가 일어났을 때 ViewModel의 delete 메소드를 호출하도록 해주었다.

```swift
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.delete(indexPath, completion: nil)
        }
    }
}
```

흐름을 다시 정리하자면...
* 셀 삭제 이벤트가 발생되면 ViewModel의 delete 메소드를 호출하여 indexPath를 전달한다.
* 메소드 내부에서 ViewModel의 PublushSubject인 deleted에게 `onNext`로 `새 indexPath`를 전달한다.
* 새 데이터를 전달받은 `PublushSubject`는 구독하고 있는 애들에게 이벤트가 발생했으니 subscribe를 실행하라고 알림을 준다.
* 바인딩해두었던 `subscribe`가 호출되면서 셀이 삭제된다.

이렇게 해주면 삭제 이벤트가 발생했을 때, View는 알아서 UI를 업데이트 하게 되고, ViewModel에서도 UseCase에게 데이터를 삭제요청해서 테이블뷰의 보여질 데이터도 업데이트 된다.

> 내가 원하는 방식의 로직이 짜여졌지만, 이게 적절한 방법인지는 사실 모르겠다! 문제라면 그때가서 고쳐봐야지... 일단 PR을 보내서 리뷰를 받아봐야 알 것 같다. 어쨌든 성공해서 기쁘다~!!

---

- 참고링크
    - 새벽에 RxSwift 감을 익히게 도와주신 갓웨더....👍🏻
    - 갓튀김님 강의!!!!!
        - https://www.youtube.com/watch?v=iHKBNYMWd5I&t=8679s
