# 220222 UISearchController
# TIL (Today I Learned)

2월 21일 (월)

## 학습 내용

- UISearchController

&nbsp;

## 고민한 점 / 해결 방법

**[UISearchController]**

https://developer.apple.com/documentation/uikit/uisearchcontroller

> 메모장 앱의 검색하는 기능은 어떻게 구현할 수 있을까?

Navigation Item에는 `searchController`라는 프로퍼티가 존재한다.
여기에 `UISearchController`를 생성하여 할당해준다.

```swift
let searchController = UISearchController(searchResultsController: nil) // 검색 컨트롤러 생성
searchController.searchBar.placeholder = "Search" // placeholder 할당
searchController.hidesNavigationBarDuringPresentation = false // 스크롤시 네비게이션 바를 숨길건지 여부
searchController.searchResultsUpdater = self // delegate
searchController.searchBar.delegate = self // delegate
searchController.searchBar.setShowsCancelButton(false, animated: false) // 검색바의 cancel 버튼을 보여줄지 여부

navigationItem.searchController = searchController // 네비게이션 아이템 할당
navigationItem.hidesSearchBarWhenScrolling = true // 스크롤시 검색바를 숨길건지 여부
```

> 추가된 검색바

![](https://i.imgur.com/qCHMrvk.gif)

* 스크롤을 내렸을 때 나타나는 검색바 
---

> ### 검색할 때마다 해당 검색어가 포함되어있는 메모를 불러와서 보여주고 싶다!

* 진행하고 있던 프로젝트는 코어데이터를 활용하여 메모를 저장하고 있는 형태였다.
    * `NSPredicate`를 활용하여 필터링하여 `fetch`를 진행한다.
    * 그리고 tableView를 `reload`해준다.

```swift
final class PersistentManager {
private(set) var notes = [Note]() // 뷰에 보여줄 데이터를 담아두는 배열
...
@discardableResult
    func fetch( // 저장된 코어데이터를 가져오는 메소드
        entityName: String = "Note",
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = [NSSortDescriptor(key: "lastModified", ascending: false)]
    ) -> [Note]? {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = sortDescriptors
        guard let newData = try? context.fetch(request) as? [Note] else {
            return nil
        }
        return newData
    }
...

func setUpNotes() { // fetch를 활용하여 notes를 설정하는 메소드
        guard let newData = fetch() else {
            return
        }
        self.notes = newData
    }
...
```
내 경우에는 코어데이터를 관리하는 타입 내부에서 tableView에 보여질 데이터도 같이 관리하기 때문에, fetch를 받아온 다음 배열에 할당해주는 기능을 추가하여 진행해주었다.

```swift
final class PersistentManager {
private(set) var notes = [Note]()
...
    func searchNote(text: String) {
        guard let searchData = fetch(
            predicate: NSPredicate(format: "body CONTAINS[c] %@", text) // body에 text가 포함되어있는 것들을 필터링
        ) else {
            return
        }
        self.notes = searchData
    }
...
```
* 따라서 위와 같은 `searchNote(text:)` 라는 메소드를 구현해주었다.

```swift
extension NotesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText != "" else { // 검색어가 비어있다면 return
            return
        }
        PersistentManager.shared.searchNote(text: searchText)
        tableView.reloadData()
    }
}
```
* 그리고 `UISearchResultsUpdating`를 채택하여 [updateSearchResults(for:)](https://developer.apple.com/documentation/uikit/uisearchresultsupdating/1618658-updatesearchresults) 메소드를 구현하여 위에서 만들었던 searchNote 메소드를 호출하고 테이블뷰를 `reload` 시켜주었다.

---

> ### 검색어가 없는 경우에는 메모의 전체를 다시 가져올 순 없을까...?


* 검색어를 지워도 아까 검색했던 메모만 남아있다.
* 즉, 다시 메모의 전체 목록을 보려면 앱을 껐다 켜야하는... 현상이 나타난 것이다.

![](https://i.imgur.com/UXYO5a0.gif)

* 따라서 [UISearchBarDelegate](https://developer.apple.com/documentation/uikit/uisearchbardelegate)를 활용해서 아래와 같이 구현해주었다.

```swift
extension NotesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchBar.text == "" else { // 검색어가 비어있지 않다면 return
            return
        }
        PersistentManager.shared.setUpNotes() // 검색어가 비어있다면 다시 notes를 설정하는 메소드를 호출하고
        tableView.reloadData() // tableView를 reload한다.
    }
}
```
* 위 메소드는 텍스트가 변경될 때마다 호출되는 메소드이다.

> 검색어가 존재하지 않다면 전체목록을 보여주는 모습

![](https://i.imgur.com/ieDQeKV.gif)

---

- 참고링크
    - https://ios-development.tistory.com/94
    - https://zeddios.tistory.com/1199
    - https://codershigh.dscloud.biz/techblogs/tb_009_UISearchController/tb009_script.html
