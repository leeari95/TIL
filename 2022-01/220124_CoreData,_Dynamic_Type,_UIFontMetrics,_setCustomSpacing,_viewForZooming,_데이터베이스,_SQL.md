# 220124 CoreData, Dynamic Type, UIFontMetrics, setCustomSpacing, viewForZooming, 데이터베이스, SQL
# TIL (Today I Learned)


1월 24일 (월)

## 학습 내용
- 오픈마켓2 STEP 2
- Dynamic Type을 지원하면서 텍스트에 bold 효과를 주는 법
- CoreData 활동학습


&nbsp;

## 고민한 점 / 해결 방법

**[Dynamic Type을 지원하면서 텍스트에 bold 효과를 주는 법]**

* Apple의 UIFont가 제공하는 preferredFont를 사용하면 따로 굵기를 지정할 수 없고, 지정된 font만 사용해야 한다.
* 반대로 systemFont를 사용한다면 Dynamic Type이 동작하지 않는다.
* extension을 사용하면 굵기를 지정해도 Dynamic Type을 지원하는 메소드를 구현할 수가 있다.

```swift
extension UIFont {
    static func preferredFont(for style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
}

```
* preferredFont의 Style과 폰트 굵기를 파라미터로 받고, UIFont를 return 하는 함수를 구현
* Dynamic Type을 지원하기 위해 UIFontMetrics를 활용하여 Custom Font를 만들 것이다.
    * 지정한 폰트가 다이나믹 타입을 지원하도록 해주는 유틸리티 객체이다.
    * 파라미터 `style`에 맞게 scale이 되는 구조.
* systemFont를 사용해 사이즈와 굵기를 전달하여, font 변수를 만든 후...
* 앞서 만든 metrics에 `scaledFont` 메소드를 호출하여 UIFont를 반환한다.
    * UIFontDescriptor로 style의 pontSize를 얻어내서 그걸 활용해서 custom font를 만들고, UIFontMetrics로 다이나믹 타입을 지원하는 Custom Font를 생성해내는 과정인 것 같다. (맞나?)

---

**[StackView 내부에 view 간의 spacing 설정]**

```swift 
func setCustomSpacing(_ spacing: CGFloat, 
                after arrangedSubview: UIView)
```
* 위 메소드를 사용하면 전체적인 spacing이 아니라 딱 주고싶은 구간에만 spacing을 설정해줄 수가 있었다. (아래 사진처럼...)
* ![](https://i.imgur.com/FTcY4Hd.png)

---

**[이미지를 확대/축소 하는 방법]**

```swift
extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
```
* ScrollView의 Delegate를 활용하면 쉽게 구현할 수 있었다.
* 위 코드처럼 zooming 할 뷰를 return 해주면, 해당 뷰를 zoom을 할 수 있었다.
* 또한 ScrollView의 ZoomScale을 설정할 수도 있었다.
```swift
private func setUpScrollView() {
    scrollView.delegate = self
    scrollView.zoomScale = 1.0
    scrollView.maximumZoomScale = 4.0
    scrollView.minimumZoomScale = 1.0
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.decelerationRate = .fast
}
```
* 위 처럼 ScrollView 프로퍼티 설정이 필요했었다.
* 이후 추가 구현을 위해 몇가지 공부해보았지만, 완벽하게 이해되지 않아서.. 좀더 공부가 필요할 것 같다.
    * 탭 2번 했을 때 이미지 확대/축소 되는 기능
    * ScrollView 내부에 imageView를 추가하여 페이징 구현

---

**[CoreData]** 

* 데이터를 영구적으로 저장할 때 사용하는 기술
* 영구적이라는 것은 앱을 종료해도 데이터가 사라지지 않는다는 것
* 하지만 MS SQL이나 My SQL과 같은 관계형 데이터 베이스는 아니다.
* 데이터베이스를 쉽게 사용할 수 있도록 도와주는 기술
* Core Data 문서에서만 Object Graph Management Tool이라고 설명하고 있다.
* 다양한 기능을 제공하는데,  데이터 베이스에 대한 이해가 없어도 데이터를 저장하는 기능을  쉽게 만들 수 있다. 
* 모바일에 최적화된 프레임워크를 통해서 메모리를 적게 사용하면서 높은 성능을 제공한다.
* 특히 Core Data 프레임워크는 iOS, macOS 플랫폼과 밀접하게 통합되어 있다.
* 그래서 데이터를 저장하고 출력하는 기능을 적은 노력으로 쉽고 빠르게 개발할 수 있다.
* Core Data는 4가지 주요한 객체로 구성되어 있다.
    * Persistent Store (NSPersistentStore)
        * 이름 그대로 데이터를 영구적으로 저장한다.
        * 메모리에 저장되는 데이터와 달리 앱을 종료하거나 전원을 차단해도  계속 유지된다. 
        * 기본적으로 4가지 영구 저장소를 제공하며 필요에 따라 직접 구현하는 것도 가능하다.
        * 영구 저장소는 데이터를 메모리에 로딩하는 방식에 따라서 Atomic Store, Non-atomic Store로 구분한다.
            * Atomic Store
                * 데이터를 처리할 때 모든 데이터를 메모리에 로드해야 한다.
            * Non-atomic Store
                * 필요한 부분만 메모리에 로드한다.
            * Core Data는 Non-atomic Store인 SQList를 기본 저장소로 사용한다.
            * 적은 메모리 사용량과 빠른 성능을 제공하기 때문에 iOS 앱의 가장 적합한 저장소이다.
            * 나머지 세 저장소 모두 Atomic Store다.
                * XML Store
                * Binary Store
                * In-Memory Store
            * 모든 데이터를 메모리에 로드해야하기 때문에 데이터 크기가 클수록 성능이 저하되는 단점이 있다.
            * 그래서 iOS 앱개발에서는 거의 사용되지 않는다.
            * 다만 인메모리 저장소는 캐싱을 구현할 때 활용하기도 한다.
        * Object Model(NSManagerObjectModel)
            * 어떤 데이터가 저장되고 데이터들이 어떤 관계를 가지고 있는지 설명하는 객체이다.
            * 영구 저장소에 데이터를 저장하려면 어떤 구조로 저장해야하는지 파악해야하는데  여기에 필요한 모든 정보가 오브젝트 모델에 저장된다.
            * 오브젝트 모델은 NSManagerObjectModel 클래스로 구현되어 있다.
            * 코드를 통해 직접 모델을 구성할 수 있지만 대부분 Xcode가 제공하는 모델 편집기를 사용해서 데이터모델을 구성한다.
        * Persistent Store Coordinator(NSPersistentStoreCoordinator)
            * 영구저장소 코디네이터는 영구저장소에 저장되어 있는 데이터를 가져오거나 저장하는 객체
            * Core Data가 다양한 영구 저장소를 사용할 수 있는 것은 영구 저장소 코디네이터가 데이터를 중계하기 때문이다.
            * 컨텍스트 객체를 통해 데이터를 저장하면 오브젝트 모델을 통해 구조를 파악한 다음 영구 저장소에 알아서 저장한다.
            * 영구저장소 코디네이터는 NSPersistentStoreCoordinator 클래스로 구현되어있다.
        * Managed Object Context(NSManagedObjectContext)
            * Core Data를 통해 실행한 작업은 대부분 컨텍스트가 담당한다.
            * 컨텍스트는 보통 스크래치 패드와 비교해서 설명한다.
            * Core Data에서 데이터를 생성하면 바로 영구 저장소에 저장되지는 않는다. 컨텍스트 내부의 임시데이터로 유지된다.
            * 컨텍스트에게 저장을 요청해야 영구저장소에 저장된다.
            * 반대로 컨텍스트를 저장하지 않고 종료하면 저장되지 않은 모든 데이터가 사라진다.
            * 영구저장소에서 읽어온 데이터도 컨텍스트에서 처리된다. 이 데이터는 영구 저장소에 저장되어있는 원본 데이터에 대한 복사본이다.
            * 그래서 컨텍스트에 있는 데이터를 수정해도 원본 데이터는 수정되지 않는다.
            * 수정된 내용을 저장하려면 컨텍스트를 저장해야 한다.
            * 컨텍스트는 NSManagedObjectContext 클래스로 구현되어있다.
            * 보통 하나의 컨텍스트를 사용하지만 필요에 따라서 여러 컨텍스트를 사용하기도 한다.
    * 이 4가지 객체를 하나로 묶어서 Core Data Stack이라고 한다.
    * 대부분의 작업은 컨텍스트가 제공하는 API를 통해서 구현한다.
    * 나머지 세 객체는 초기화 시점을 제외하고는 자주 사용되지 않는다.
    * iOS 10에서 Persistent Container라는 새로운 개념이 도입되었다. 
    * 컨테이너는 Core Data Stack을 캡슐화한 객체이다.
    * NSPersistentContainer 클래스를 통해서 이전보다 쉽고 빠르게 Stack을 생성할 수 있다.

---

[데이터베이스란?] 

* 도입배경
    * 독립된 파일 단위로 데이터를 저장하게 되면 데이터 종속성 및 중복성이 높아 무결성 위배 가능성이 높을 수 있음. 이러한 단점을 보안하고자 여러 시스템이 공용으로 데이터를 모아 관리하는데 데이터베이스를 구축하게 된다.
* 정의
    * 시스템이 공용으로 사용하고 관리하는 데이터 집합
* 장점
    * 종속성 및 중복성 최소화
    * 일관성 및 무결성 유지
    * 공유 및 보안성 강화
    * 실시간 처리 가능
* 단점
    * 전문가 부족
    * 전산화 비용 증가
    * 시스템이 복잡하고 느림
    * 파일 회복이 어려움
* 데이터베이스 관리 시스템(DBMS)
    * 사용자와 데이터베이스 사이에서 사용자의 요구에 따라 데이터베이스 생성, 관리해주는 소프트웨어
    * 사용자 <-> DBMS <-> DB
    * 사용자
        * DBA(DB관리자), 일반 사용자, 응용프로그램
    * DBMS 종류
        * 계층형, 네트워크형, 객체지향형, 관계형
    * DBMS 프로그램
        * Oracle, MySQL, MS SQL, Access 등등
* DBMS 기능 및 언어
    * 정의어(Data Definition Language)
        * DBA 사용
        * 데이터베이스를 생성하거나 자료 형태(type)와 구조 등을 수정하며 데이터를 이용하는 방식을 정의하는 기능
        * CREATE, ALTER, DROP
    * 조작어(Data Manipulation Language)
        * 사용자 사용
        * 데이터의 검색, 삽입, 삭제 ,변경 등을 처리하는 기능
        * SELECT, INSERT, DELETE, UPDATe
    * 제어어(Date Contorl Language)
        * DBA 사용
        * 데이터의 무결성을 유지하기 위한 보안 및 권한 검사, 병행 제어 등의 기능을 정의하는 기능
        * COMMIT, ROLLBACK, GRANT, REVOKE
* 관계형 데이터베이스 (Relational-DBMS = RDBMS)
    * 테이블(Table)을 이용한 구조
        * ![](https://i.imgur.com/QIPX0do.png)
        * 테이블: 표, 개체 또는 릴레이션
        * ![](https://i.imgur.com/Xinny93.png)
        * 필드: 속성(Attribute), 열
        * ![](https://i.imgur.com/SWov102.png)
        * 레코드: 튜플(Tuple), 행
        * 도메인: 하나의 속성에서 취할 수 있는 원자값의 범위
        * 필드의 개수 : 차수(Degree)
        * 레코드의 개수: 기수(Cardinality)
* 테이블의 특징
    * 속성(필드)와 튜플(레코드)들은 유일하게 순서가 무관함
    * 속성(필드)의 값은 분해할 수 없다.
    * 속성(필드)의 값은 동일할 수 있다.
    * 튜플(레코드)은 삽입, 삭제 등에 의해 계속 변한다.
    * 튜플(레코드)를 식별하기 위해 속성(필드)의 일부를 Key로 설정한다.
    * 속성(필드)는 Null 값을 가질 수 있으나, 기본키에 해당하는 속성(필드)는 Null값을 가질 수 없다.
* 데이터베이스 설계
    * 기본키 - 중복 불가능, null 값 불가능
* 데이터베이스 설계 단계
    * 개념적 설계 -> 논리적 설계 -> 물리적 설계
* 정규화
    * 이상 현상이 일어나지 않도록 분해하는 과정
    * 중복성, 종속성을 최소화하기 위한 작업
* 데이터베이스 구조(스키마)
    * 외부스키마
        * 일반 사용자나 응용프로그래머 관점
    * 개념스키마
        * 논리적 구조 및 규칙
    * 내부스키마
        * 물리적 구조 설계자 관점 스키마

---

**[SQL이란?]**

* Structured Query Language 약자
* 데이터베이스와 대화하기 위해 디자인된 언어
* 거의 모든 것들에겐 데이터베이스가 필요하다
* 데이터베이스는 데이터를 저장하는 곳
* 데이터베이스에는 2가지 종류가 있다
    * Relational
    * Non-Relational
    * 혹은
    * SQL
        * mysql, postgreaql, sqlite
    * Non-SQL
        * mongoDB, dynamoDB, couchDB
* 대다수의 회사, 정부기관, 은행 등등 다수 기관들이 SQL을 사용한다.
* SQL 데이터베이스는 어떻게 생겼고 어떻게 작동하는걸까?
* 사실 SQL은 엑셀문서와 똑같이 생겼다.
    * 데이터 베이스에 테이블이 있고, 엑셀문서에는 시트가 있겠다
    * 테이블에는 row와 column이 있고 문서에도 row와 column이 있다.
* SQL에 4개의 column이 있다고 상상해보자
    * ID, 이름, 이메일, 나이
* row에는 5명의 유저가 있다고 상상하자
* 만약 학생 테이블 유저의 모든 이메일을 갖고오고 싶다면 이를 위한 커맨드는
    * SELECT email FROM students;
* 보다시피 그냥 보통 영어랑 똑같다. 프로그래밍 언어가 아니라 쿼리용 언어라서 그러하다.
* 이번엔 21살보다 많은 유저의 이메일을 갖고오고 싶다면?
    * SELECT email FROM students WHERE age > 21;
* 이번엔 유저의 이메일이 naver인 경우의 나이를 찾아보자
    * SELECT age FROM students WHERE email LIKE “%naver.com”;
* 이번엔 % 싸인을 사용했는데, naver.com으로 끝나는 경우 특정 값을 찾으려고 할 때 사용한다.
* 이번엔 ID가 2인 경우의 유저를 지우고 싶다면?
    * DELETE From students WHERE id=2;
* 15~18세 사이의 학생들만 찾고싶다면?
    * SELECT email FROM students WHERE age BETWEEN 15 AND 18
* 이렇게 쉬운데 왜 수많은 개발자들은 SQL을 모르는걸까?
    * 그 이유는 ORM 때문이다.
* ORM이 뭐냐면 예를들면 파이썬을 가져와서 SQL코드로 바꿔주는 일을 한다.
* 그러니까 파이썬으로 코딩하면 ORM 덕분에 SQL코드를 얻는 것이다.
* 그래서인지 ORM은 정말 자주 쓰인다.
    * 파이썬의 경우 장고 ORM이 있고, 라라벨의 경우 eloquent ORM, nodeJS의 경우 Sequelize 혹은 type ORM이 있다.
* 문제라면 개발자들로 하여금 ORM에 너무 의존하게 만든다.
* 왜냐하면 개발자들은 파이썬 SQL을 바꿔가면서 코딩하기 보단 하나만 가지고 계속 작업하는 것을 좋아하다 보니까 뭔가 안될 때, 더 빠르게 작업해야할 때, 그런 상황이 왔을 때 어떻게 대처할지 모른다는게 문제다.
* 그렇기 때문에 모든 풀스택 개발자들은 SQL을 배워야 한다.
* 왜냐하면 어느순간에는 ORM으로 부족할 시점이 오기 마련이다. 물론 ORM을 쓰지 말란 소리는 아니다.

---

**[예습으로 만들었던 CoreData 예제]**

```swift
class ViewController: UIViewController {
    var context: NSManagedObjectContext { // 모든 작업을 처리할 수 있는 기본 컨텍스트
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        return app.persistentContainer.viewContext
    }
    // 다만 메인쓰레드에서 작업하기 때문에 블로킹이 발생하지 않도록 주의해야한다.
...
```

```swift
@IBAction func createEntity(_ sender: Any) {
    guard let name = nameField.text,
          let val = ageField.text, let age = Int(val) else {
        return
    }

    let newEntity = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
    newEntity.setValue(name, forKey: "name")
    newEntity.setValue(age, forKey: "age") // setValue의 value는 Any타입을 받기 때문에 컴파일 시점에서 오류나지 않으니 타입을 잘 확인해야 한다
    // 저장할 내용이 없는데 세이브를 호출하게 되면 불필요한 리소스를 낭비하게 된다.
    // 그래서 지금처럼 변경사항이 있는지 확인하는 것이 좋다.
    if context.hasChanges {
        do {
            try context.save()
            print("Saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    // 저장후 텍스트필드 초기화
    nameField.text = nil
    ageField.text = nil
}
```
```swift
var editTarger: NSManagedObject?

@IBAction func readEntity(_ sender: Any) {
    let request = NSFetchRequest<NSManagedObject>(entityName: "Person")

    do {
        let list = try context.fetch(request)
        if let first = list.first {
            nameField.text = first.value(forKey: "name") as? String
            if let age = first.value(forKey: "age") as? Int {
                ageField.text = "\(age)"
            }

            editTarger = first // 데이터를 프로퍼티 담아 저장
        } else {
            print("Not Found")
        }
    } catch {

    }
}
```
* readEntity로 저장해둔 editTarget을 수정, 삭제하는 부분
```swift
@IBAction func updateEntity(_ sender: Any) {
    guard let name = nameField.text,
          let val = ageField.text, let age = Int(val) else {
        return
    }

    if let target = editTarger {
        target.setValue(name, forKey: "name")
        target.setValue(age, forKey: "age")
    }

    if context.hasChanges {
        do {
            try context.save()
            print("Saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    // 저장후 텍스트필드 초기화
    nameField.text = nil
    ageField.text = nil
}
```
```swift
@IBAction func deleteEntity(_ sender: Any) {
    if let target = editTarger {
        context.delete(target)

        if context.hasChanges {
            do {
                try context.save()
                print("Saved")
            } catch {
                print(error.localizedDescription)
            }
        }
        // 저장후 텍스트필드 초기화
        nameField.text = nil
        ageField.text = nil
    }
}
```

---

- 참고링크
    - https://mackarous.com/dev/2018/12/4/dynamic-type-at-any-font-weight
    - https://ios-development.tistory.com/344
        - https://developer.apple.com/documentation/uikit/uistackview/2866023-setcustomspacing
    - https://www.youtube.com/watch?v=YpVZgQW1TvQ
    - https://www.youtube.com/watch?v=55MRdTM8RPE&t=3s
