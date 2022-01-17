# 220117 스위프트의 성능 이해, UIImagePickerController
# TIL (Today I Learned)


1월 17일 (월)

## 학습 내용
- UIImagePickerController 사용
- 스위프트의 성능 이해하기

&nbsp;

## 고민한 점 / 해결 방법

**[UIImagePicketController]**

* 인스턴스를 생성해서 present를 하기만 하면 간단히 앨범이나 카메라에 접근할 수 있는 기능
* imgePicketController.sourceType을 이용하면 앨범이나, 카메라 접근을 설정할 수 있다.
* sourceType을 .camera로 설정했을 때 시뮬레이터에는 에러가 나므로 주의해야한다. 
    * 실제 기기에서만 테스트 가능.
* 앨범, 카메라 접근권한 설정 방법
* 프로젝트 내에 info 파일을 클릭
* <img width="337" alt="LaunchScreen" src="https://user-images.githubusercontent.com/75905803/149802294-fbe86480-5e49-4e6e-b841-02e5f7fa8ae7.png">

* 이후 우클릭 하여 Add Row를 클릭
* <img width="473" alt="unch screen interface file base name" src="https://user-images.githubusercontent.com/75905803/149802388-c7be1625-b031-4cd8-8288-bc8559acbe47.png">
* Privacy를 입력하여 키를 추가해준다. Value에는 알림창에 나오는 메세지를 입력해준다.
* <img width="424" alt="Information Property List" src="https://user-images.githubusercontent.com/75905803/149802446-47fb4f97-d578-415f-8020-32e8eeb8f6fb.png">
* UIImagePickerControllerDelegate의 메소드
* `imagePickerController(_ picker:, didFinishPickingMediaWithInfo:)`
    * 이미지를 Picking을 했을 때 불리는 메소드다.
    * 선택한 이미지를 앨범에 저장, 혹은 이미지 정보를 활용해 뷰를 구성할 때 주로 사용한다.

---

**[상품 등록 뷰 설계]**

* add버튼을 추가해둘 커스텀 Footer를 생성
    * 이미지가 5개가 된다면 (collectionView.numberOfItems(inSection: 0) == 5) 플로우 레이아웃 활용해서 푸터 숨김
* imageView를 담고있는 커스텀 cell 생성
* 콜렉션뷰에 둘다 레지스터
* DataSource와 delegateFlowLayout 설정
* 기타 옵션
    * 스크롤바 숨기기 
        * collectionView.showsHorizontalScrollIndicator = false
    * 버튼이나 이미지 cornerRadius 설정
        * addButton.layer.cornerRadius = 10
* ![](https://i.imgur.com/i41dM51.png)
* ![](https://i.imgur.com/DyzyAOB.png)
* Footer에 존재하는 버튼을 눌렀을 때 ViewController가 아닌 `FooterView`에서 이벤트를 받게 된다.
* NotificationCenter을 활용하여 `버튼 이벤트를 ViewController에게 전달`해줄 수 있도록 구성.
    * `delegate` 패턴이랑 둘중에 뭐가 적절한지 비교해봐야지

**[이벤트를 전달받은 뷰컨이 해야할일 정해보기]**

* `UIImagePickerController` 인스턴스 생성
* `delegate` 채택
* 편집유무 설정
* `UIImagePickerController` 인스턴스 `present`
* `imagePickerController(_ picker:, didFinishPickingMediaWithInfo:)` 메소드 구현
    * 원본이미지, 수정한 이미지 선언
    * 수정한 이미지가 없다면 원본이미지를 옵셔널 바인딩하도록 설정
    * 뷰컨에 있는 images 배열에 append하도록 로직 구성
    * 콜렉션뷰를 reloadData
    * picket를 dismiss
* 콜렉션뷰 `delegate` `didSelectItemAt` 메소드를 활용
    * 터치시 이미지를 삭제하도록 구현
        * images `remove` 메소드 호출
        * collectionView `reloadData` 호출
* 완성~
* ![](https://i.imgur.com/SIRf4tB.gif)
* ![](https://i.imgur.com/3Lx25s6.gif)

**[남은 고민거리]**

* 버튼 이벤트 전달할 때 `delegate` vs `NotificationCenter` 비교
* 사진이 추가될 때 마다 콜렉션뷰 자동 스크롤이 필요할듯
* 사진을 터치할 때 삭제하겠냐고 물어보는 얼럿 추가 구현 필요할듯
* 사진을 추가할 때 카메라, 앨범 선택하는 얼럿시트 띄우고 싶은데... 소스타입을 카메라로 바꾸면 에러가 나서 해결못함 (소스타입을 사용할 수 없담서...)
    * 아 이건.. 시뮬레이터에서 카메라를 열라그래서 뜨는 에러란다. 실제 기기에서는 잘 작동하나보다.
    * 카메라는 사실 요구사항에 없는 부분이라 제리랑 의논해봐야징

---

**[스위프트 성능 이해하기]**

* Value Semantics
    * Value Type Semantic / Copy by Value Semantic
    * identity가 아닌 Value(값)에만 의미를 둔다.
        * Int, Double 등의 기본 타입
    * 포인터만 복사되는 참조(Reference) 시맨틱스와 비교된다.
        * Objective-C, Java 등
    * 스위프트엔 Objc에 없던 새로운 Value 타입을 도입
        * struct, enum, tuple
    * 특징
        * 변수 할당 시 Stack에 값 전체가 저장된다.
        * 다른 변수에 할당될 때 전체 값이 복사된다. (copy by value)
            * 변수들이 분리된다. 하나를 변경해도 다른 것에 영향이 없다.
        * Heap을 안쓰며 Reference Counting도 필요없다.
    * class vs struct
        * <img width="590" alt="class Point" src="https://user-images.githubusercontent.com/75905803/149802754-b6797452-7c11-4eeb-84d6-ca3cf54550d2.png">
        * 클래스는 하나의 identity 변수가 복사되어도 값이 하나를 향해 같은 값을 가진다.
        * <img width="506" alt="struct Point" src="https://user-images.githubusercontent.com/75905803/149802819-887ba3eb-a8e9-4891-be1e-22c17e4b1d08.png">
        * 값타입의 각자 변수는 복사되어도 분리되어있다.
    * Value Semantics: 값에 의해 구분된다.
        * Value semantic에서는 identity가 아니라 value가 중요하다.
        * 각 변수는 값(value)에 의해 구분이 되어야 한다.
        * 따라서 동치 관계여야 한다.
            * <img width="427" alt="protocol Equatable {" src="https://user-images.githubusercontent.com/75905803/149802834-0f7ba7c7-7834-4b16-bde0-3d6c49e07ad0.png">
            * 간단하다. Equatable을 구현하자. (단순히 데이터를 전달할 목적인 struct 변수를 말하는 것이 아님)
    * Value Type과 Thread
        * <img width="497" alt="var numbers = (1, 2, 3, 4, 5, 6, 7, 8" src="https://user-images.githubusercontent.com/75905803/149802874-c1b2c40d-3982-4242-a125-de3286493e35.png">
        * 스레드 간 의도하지 않은 공유로부터 안전하다.
    * 값 모두를 Copy하는데 성능은 괜찮을까?
        * Copy는 빠르다
            * 기본 타입들 enum tuple struct
                * 정해진 시간(constant time)안에 끝난다.
            * 내부 데이터가 Heap과 혼용하는 struct의 경우
                * 정해진 시간 + 래퍼런스 copy등의 시간
                * String, Array Set, Dictionary 등
                * 쓰기 시 Copy-on-write로 속도 저하 보완
    * 스레드로 문제 생기는 것을 Immutable로 해도 되는것이 아닌가?
        * 사실 immutable로 해도되지만 모두 다 잘되는 것은 아니다.
        * 참조형이어도 값이 불변하면 Thread간에 문제생길 일이 없다.
        * 함수형 패러다임과 같이 널리 전파되기도 하였다.
        * Immutable은 cocoa에서도 꽤 써왔다.
    * 정말 Immutable이 언제나 답일까?
        * 답은 아니다.
        * Objc에서 많이 쓰던 Immutable 방식
        * <img width="558" alt="var array NSArray = (NSHomeDirectory()" src="https://user-images.githubusercontent.com/75905803/149802879-4609c5cb-7c9b-443c-8128-b306b0ac2000.png">
        * 비효율적이다.
        * <img width="491" alt="var array NSMutableArray (NSHomeDirectory())" src="https://user-images.githubusercontent.com/75905803/149802945-6cfa1650-6d96-4331-bd57-8b091caf022f.png">
        * <img width="401" alt="func makeURL (subDirectories  String )" src="https://user-images.githubusercontent.com/75905803/149802938-190113c8-4b7d-46b6-b70f-0b27c76753d5.png">
        * <img width="553" alt="Mutable + Value Type" src="https://user-images.githubusercontent.com/75905803/149802978-55150c61-3735-47ad-ad6e-0ef330b60f4e.png">
        * Dashboard를 새로 갈아끼는 것인가?
    * 그래도 class도 중요한 경우
        * value보다 identity가 중요한 경우
            * UIView 같이 모든 변수에서 단 하나의 state를 갖는 개체
        * OOP 모델
            * 여전히 상속은 아주 훌륭한 도구
        * Objective-C 연동
        * Indirect storage (특수한 경우 struct내의 간접 저장소 역할)
* 성능을 위해 고려할 것들
    * 성능에 영향을 미치는 3가지
        * Memory Allocation
            * Stack or Heap
        * Reference Counting
            * No or Yes
        * Method Dispatch
            * Static or Dynamic
    * Heap 할당의 문제
        * 할당 시에 빈 곳을 찾고 관리하는 것이 복잡한 과정이다.
        * <img width="480" alt="Pasted Graphic 13" src="https://user-images.githubusercontent.com/75905803/149802988-fa7508d6-a715-4574-90a4-f8c906441704.png">
        * 무엇보다 그 과정이 thread safe해야 한다는 점이 가장 큰 문제이다.
            * lock 등의 synchronization 동작은 큰 성능 저하 요소
        * 반면 Stack 할당은?
            * 단순히 스택포인터 변수값만 바꿔주는 정도
    * Heap 할당 줄이기
        * heap 할당 줄이기 최적화 예제
        * <img width="568" alt="enun color" src="https://user-images.githubusercontent.com/75905803/149803042-4d46e680-280a-40c6-a870-4b9f7c2b7e24.png">
        * 매우 번번히 호출된다면 성능에 영향을 미칠 수 있다.
            * 예를 들면 매우 큰 Loop 안에서 일어나는 경우
                * Key를 Value type으로 바꿔보자.
                * <img width="613" alt="struct Attribute Hashable (" src="https://user-images.githubusercontent.com/75905803/149803063-4eb3c773-03c9-48b8-a285-2deed5580e8d.png">
                * <img width="569" alt="struct Attribute Hashable•" src="https://user-images.githubusercontent.com/75905803/149803074-6ad98142-3522-41f7-ad38-efa1331b0dc4.png">
    * Reference Counting의 문제
        * 정말 자주 실행된다.
            * 변수 Copy할 때 마다
        * 그러나 이것도 역시 가장 큰 문제는 Thread Safety 때문
            * 카운트를 Atomic하게 늘리고 줄여야한다.
    * Method Dispatch
        * Static
            * 컴파일 시점에 메소드의 실제 코드 위치를 안다면 실행중 찾는 과정 없이 바로 해당 코드 주소로 점프할 수 있음
            * 컴파일러의 최적화, 메소드 인라이닝(Inlining) 가능
                * 메소드 인라이닝?
                    * 컴파일 시점에 메소드 호출 부분에 메소드 내용을 붙여넣는다.
                        * 효과가 있다고 판단하는 경우에만
                    * Call Stack 오버헤드 줄임
                        * CPU icache나 레지스터를 효율적으로 쓸 가능성
                    * 컴파일러의 추가 최적화 가능
                        * 최근 메소드들이 작으므로 더더욱 기회가 많다.
                        * 루프 안에서 불리는 경우 큰 효과
        * Dynamic
            * Reference 시맨틱스에서의 다형성(Polymorphism)
            * 실제 타입을 컴파일 시점에 알 수가 없다. 때문에 코드 주소를 rutime에 찾아야 한다.
            * Dynamic Method Dispatch의 문제
                * Static에 비해 단지 이것이 문제. Thread Safety문제도 없다.
                * 하지만 이로 인해 컴파일러가 최적화를 못하는 것이 큰 문제이다.
            * Static Dispatch로 강제하기
                * final, private 등을 쓰는 버릇
                    * 해당 메소드, 프로퍼티등은 상속되지 않으므로 static하게 처리
                * dynamic을 쓰지 않는다.
                * Objc 연동 최소화
                    * Objective-C Runtime을 통하게 된다.
                * WMO(whole module optimization)
                    * 빌드시에 모든 파일을 한번에 분석하여 static dispatch로 변환 가능한지 등을 판단하여 최적화해준다.
                        * 하지만 굉장히 느려진다…
                        * 디버그 빌드에 적용하는 것은 정신건강에 좋지 않다.
                        * 아직 안정화가 안되어있다.
    * 정리
    * <img width="343" alt="Memory Allocation Stack or Heap" src="https://user-images.githubusercontent.com/75905803/149803081-6312b85c-397f-4346-b684-6efd29eaf320.png">
* 스위프트의 추상화 기법들의 성능
    * 추상화 기법들
        * class
            * 클래스는 Heap과 Referencs Counting을 이용한다.
            * <img width="339" alt="Memory Allocation Heap" src="https://user-images.githubusercontent.com/75905803/149803091-9a57c0ed-be9f-48aa-b5c6-c9d5cfec379f.png">
            * 성능 상관 없이 래퍼런스 시맨틱스가 필요하다면 써야함
            * Identity, 상속 등등…
                * 단 래퍼런스의 의도하지않은 공유로 인한 문제는 조심해야 한다.
            * 단 클래스에 final 키워드를 쓴다면?
            * <img width="251" alt="Memory Allocation Heap" src="https://user-images.githubusercontent.com/75905803/149803098-d06c32cf-56a4-41e3-b205-97303ee07219.png">
            * method Dispatch가 Static이 되서 이 부분에 대한 성능이 개선될 수 있다.
        * struct
            * 구조체안에 어떤 타입이 들어가 있는지에 따라 성능이 크게 달라진다.
            * 참조 타입이 없다면?
            * <img width="245" alt="Memory Allocation Stack" src="https://user-images.githubusercontent.com/75905803/149803106-2f6415ca-3afa-43ce-b932-e20e5466f301.png">
            * 참조 타입을 가진 구조체라면?
            * <img width="569" alt="struct Label" src="https://user-images.githubusercontent.com/75905803/149803112-ec5b2520-8d71-4e6a-9247-9c519621a0e5.png">
            * <img width="577" alt="struct Label" src="https://user-images.githubusercontent.com/75905803/149803116-3575e9b9-1597-46ae-a49b-1e7e05705bb5.png">
            * <img width="566" alt="struct Label" src="https://user-images.githubusercontent.com/75905803/149803127-ab0d9fa6-6c3f-487e-a931-852a95b08ce2.png">
            * Reference Counting이 한번 Copy할 때마다 2번씩 일어난다.
                * struct안에 참조 타입의 property 수 만큼 많아진다.
                * <img width="255" alt="Memory Allocation Stack" src="https://user-images.githubusercontent.com/75905803/149803133-af0cb4a2-4064-428c-b935-9765074accbe.png">
            * 참조 타입을 많이 가지고있는 구조체는?
            * <img width="532" alt="Memory Allocation Stack" src="https://user-images.githubusercontent.com/75905803/149803146-da88c030-12e1-46c8-8e98-2c65a32cdb3e.png">
            * 구조체 내 참조타입을 줄여보기
            * <img width="597" alt="struct HTTPRequest" src="https://user-images.githubusercontent.com/75905803/149803152-48dc1dfc-6633-40da-8120-eed03c50c1df.png">
        * protocol
            * 코드 없이 API만 정의한다.
            * 상속 없는 다형성(Polymorphism) 구현이 가능하다.
            * Objective C의 protocol, Java의 Interface 매우 유사함
            * Value 타입인 struct에도 적용이 가능하다.
                * value semantics에서의 다형성
            * protocol을 이용한 값타입의 다형성
            * <img width="511" alt="protocol Drawable func draw()" src="https://user-images.githubusercontent.com/75905803/149803159-03185d85-701e-4372-820f-6a427c4f6d3f.png">
            * 의문점
                * 변수 할당
                    * 클래스라면 주소값이니 모두 같은 사이즈지만 구조체인 Point와 Line은 사이즈가 다르다.
                    * 어떻게 Drawable에 메모리를 미리 할당해 놓고 값을 저장할까?
                * Method Dispatch
                    * 클래스의 다형성 구조에선 V-Table을 통해서 찾았다.
                    * 상속이 아닌 protocol의 다형성 구조에선 V-Table이 없다.
                    * 어떻게 Point-draw와 Line.draw를 구분해서 호출할까?
                * 프로토콜의 변수할당
                * <img width="580" alt="struct Point  Drawable {" src="https://user-images.githubusercontent.com/75905803/149803167-d0b4fcd1-21e2-4da7-b0ea-63b87a26627a.png">
                *  이것을 해결하기 위해서 Existential Container을 활용한다.
                * 실제 값을 넣고 관리하는 구조
                * <img width="362" alt="Value Buffer" src="https://user-images.githubusercontent.com/75905803/149803173-f2dc42c9-0eb2-447a-88ac-32e8cc62924a.png">
                * struct가 3 words 이하인 경우
                * <img width="312" alt="Existential Container" src="https://user-images.githubusercontent.com/75905803/149803415-4d30fe07-1279-4f52-98c0-c15419145d27.png">
                    * Existential container 안에 값 모두 저장된다.
                * struct가 3 words보다 큰 경우
                * <img width="453" alt="Existential Container" src="https://user-images.githubusercontent.com/75905803/149803424-9ff11602-0a39-4912-88fb-b09d2938f3aa.png">
                    * Heap에 할당하여 값을 저장한다.
                    * Existential container에 해당 래퍼런스를 저장한다.
                * 어떻게 3 word를 구분해 할당하고 복사하지?
                    * Value Witness Table(VWT)를 사용한다.
                    * <img width="132" alt="allocate" src="https://user-images.githubusercontent.com/75905803/149803433-84615d30-703f-4f94-a5bb-ce285c6adcec.png">
                * VWT
                    * Existential container의 생성/해제를 담당하는 인터페이스이다.
                    * <img width="129" alt="Point VWT" src="https://user-images.githubusercontent.com/75905803/149803437-200e31fc-50e5-4eb6-bfec-e6382e6f94c4.png">
                    * protocol을 구현하는 타입마다 있다.
                * protocol Witness Table
                * <img width="842" alt="Existential Container" src="https://user-images.githubusercontent.com/75905803/149803447-c7dce6a7-7871-4a9c-9e47-aaaeeb604678.png">
            * Copy 동작 정리
                * value 타입이므로 값 전체가 복사된다.
                * 3words 이하인 경우
                    * 단순히 새로운 Existential container에 전체가 복사됨
                * 3 words를 넘는 경우
                    * 새로운 Existential container 생성
                    * 힙에 할당되어 저장된 값 전체가 새로운 힙 할당후 복사된다.
            * 큰 사이즈 protocol 타입의 copy
            * <img width="566" alt="protocol Drawable { func draw() }" src="https://user-images.githubusercontent.com/75905803/149803454-7b6ef352-bf58-4578-a483-5ab410155732.png">
                * Heap의 데이터도 복사가 된다.
                * 왜냐하면 value 타입이니까!
                * Heap은 쓰지만 Reference Counting이 없다.
                * copy 마다 새로운 heap을 할당하는데 이것이 큰 성능 저하 요소이다.
            * 개선해본다면?
                * 스토리지 클래스를 만든다.
                * 그렇게 된다면 Drawable을 할당할 때 스토리지의 Reference를 가져오게 되는 것이다.
                * <img width="582" alt="protocol Drawable { func draw()" src="https://user-images.githubusercontent.com/75905803/149803457-7d823737-15a6-426b-add9-ced1317ac08e.png">
                * 따라서 힙 할당이 더 싼 Reference Counting으로 바뀌었다.
                * 하지만 값을 바꾼다면?
                * <img width="1049" alt="protocol Drawable { func draw() !" src="https://user-images.githubusercontent.com/75905803/149803465-ef6f17b3-d5d6-4d62-9219-a18e39adeba6.png">
                * <img width="473" alt="Drawable" src="https://user-images.githubusercontent.com/75905803/149803478-1f847a4c-691b-493e-b7a3-4a5489814d24.png">
                * value타입인데 이러면 안된다.
                * 따라서 이런 경우에는 값을 할당할 때 새로운 스토리지를 복사하여 대입하도록 코드를 추가해주어야 한다.
                * <img width="599" alt="class LineStorage" src="https://user-images.githubusercontent.com/75905803/149803491-7b878787-e4a3-4fcb-8427-08678e6f8611.png">
                * 이거에 대한 큰 장점은 일반적으로 사용할 때는 전혀 메모리 할당이 추가적으로 일어나지 않지만, 쓸때에만 복사를 한다. 따라서 성능을 개선할 수가 있다.
                * Existential Container
                    * 변수가 protocol 타입으로 정의된 경우 쓰인다.
                    * 프로토콜을 통한 더형성을 구현하기 위한 목적으로 쓰인다.
                    * 내부 동작이 복잡하긴 해도 성능이 class 쓰는 것과 비슷하다.
                        * 둘다 초기화 시 Heap 할당하여 사용
                        * 둘다 Dynamic dispatch (class 도 V-Type, protocol은 PWT)
                * 하지만 복사를 할때에는 다른데..
                * 큰 사이즈 Protocol 타입의 copy
                    * Indirect Storage
                        * 복사 시 힙 할당 대신 Reference Counting으로 대체
                        * class타입의 다형성 쓸때와 비슷한 수준
                    * Copy-on-Write
                        * Indirect storage를 값이 변경될 시점에 Heap 할당하여 복사
                        * 성능 저하를 최소화한다. (변경 동작에서만)
                        * String, Array, Dictionary 등도 이런 개념으로 Value semantics를 구현한다.
                    * 작은 사이즈의 protocol 타입
                    * ![image](https://user-images.githubusercontent.com/75905803/149803520-5e5366cd-948f-481b-b0d3-455e0a0e5e10.png)
                    * 큰 사이즈의 protocol 타입
                    * <img width="481" alt="Memory Allocation Heap" src="https://user-images.githubusercontent.com/75905803/149803527-972fd939-45ca-416f-a539-3738c5909bcc.png">
                        * with Indirect Storage
                        * <img width="506" alt="Drawable" src="https://user-images.githubusercontent.com/75905803/149803536-9e617964-efb3-43b8-8f02-415f35e231c1.png">
        * Generics
            *  제네릭 타입도 프로토콜과 마찬가지로 VWT를 사용한다.
            *  <img width="589" alt="protocol Drawable { func draw()" src="https://user-images.githubusercontent.com/75905803/149803548-405c545e-a725-4d7c-88ad-c4ecaa1a9418.png">
            *  <img width="577" alt="protocol Drawable { func drawl)" src="https://user-images.githubusercontent.com/75905803/149803558-0419a750-42fc-424d-9d9f-57d90c9b14e5.png">
            
            * 성능을 개선할 수 없을까?
                * Method 내에서는 Drawble의 실제 타입이 바뀌지 않는다.
                    * Static Polymorphism
                * 실제 타입별로 메소드를 만들어 준다면?
                * <img width="597" alt="protocol Drawable" src="https://user-images.githubusercontent.com/75905803/149803560-5efe50e6-b6b0-4b22-a3be-a4d5dc493de9.png">
                    * 복잡한 Existential Container를 안써도 된다.
                    * 함수 호출 시 Heap 할당을 많이 없앨 수 있다.
                * 하지만 이걸 손으로 하면 Generics 쓰지 말란 말인가?
                    * ㄴㄴ 컴파일러가 해준다.
                * Generic 특수화(Specialization)
                    * 더 효과를 보려면 WMO(whole module Optimization)을 켜라
                    * <img width="456" alt="Pasted Graphic 50" src="https://user-images.githubusercontent.com/75905803/149803578-fb2c8da7-7f9e-442e-9045-f890170bba08.png">
                    * 아직 너무 믿진 말자…
                * 제네릭 타입 정리
                    * 정적 다형성(Static Polymorphism)
                        * 컴파일 시점에 부르는 곳마다 타입이 정해져있다.
                        * 런타임에 바뀌지 않는다.
                        * 특수화(Specialization)가 가능하다.
                    *  특수화가 되지 않은 제네릭(작은 사이즈)
                    *  <img width="477" alt="Memory Allocation Stack" src="https://user-images.githubusercontent.com/75905803/149803590-09866d01-ea13-48c1-b136-1cd2688f3cde.png">
                    * 특수화된 제네릭(작은 사이즈)
                    * <img width="249" alt="Memory Allocation Stack" src="https://user-images.githubusercontent.com/75905803/149803598-55af9c85-31ee-4f69-90c9-a7e19aed877c.png">
                    * 특수화가 되지 않은 제네릭(큰 사이즈)
                    * <img width="483" alt="Method Dispatch Dynamic (Protocol Witness Table)" src="https://user-images.githubusercontent.com/75905803/149803606-bfef5f54-c4c5-4511-b590-e3d65516df12.png">
                    * 특수화된 제네릭(큰 사이즈)
                    * <img width="343" alt="Memory Allocation Heap" src="https://user-images.githubusercontent.com/75905803/149803614-012cee89-bc20-4547-a2b8-e6db39d93860.png">
    * 스위프트 성능 이해 정리
        * Objective-C에 비해 큰 향상이 있었으나 값타입과 프로토콜 타입 등의 성격을 고려해야 한다.
        * 성능 최적화를 고려해야하는 경우의 예
            * 렌더링 관련 로직 등 반복적으로 매우 빈번히 불리는 경우
            * 서버 환경에서의 대용량 데이터 처리
        * 추상화 기법의 선택
            * struct
                * 엔티티 등 value 시맨틱이 맞는 부분
            * class
                * identity가 필요한 부분, 상속등의 OOP, Objective-C
            * generics
                * 정적 다형성으로 가능한 경우
            * protocol
                * 동적 다형성이 필요한 경우
        * 고려할 수 있는 성능 최적화 기법
            * struct에 클래스 타입의 프로퍼티가 많으면
                * enum, struct 등 값타입으로 대체
                * Reference Counting을 줄인다.
            * Protocol 타입을 쓸 때 대상이 큰 struct이면
                * Indirect storage로 struct 구조 변경
                * mutable해야하면 copy-on-write 구현
            * Dynamic method dispatch를 static하게
                * final, private의 생활화
                * dynamic 사용 최소화
                * Objc 연동 최소화 하기

---

- 참고링크
    - https://jinshine.github.io/2018/07/06/iOS/UIImagePickerController%20%EC%98%88%EC%A0%9C/
    - https://zeddios.tistory.com/949
    - https://hururuek-chapchap.tistory.com/64
    - https://developer.apple.com/videos/play/wwdc2016/416/
    - https://developer.apple.com/swift/blog/?id=27
