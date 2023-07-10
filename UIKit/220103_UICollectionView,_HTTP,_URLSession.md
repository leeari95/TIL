# 220103 UICollectionView, HTTP, URLSession
# TIL (Today I Learned)


1월 3일 (월)

## 학습 내용
- UICollectionView 활동학습
- URLSession 학습
    - 프로젝트 고민

&nbsp;

## 고민한 점 / 해결 방법

**[UICollectionView 활동학습]**

* 학습하면서 했던 메모
    * HTTPS는 HTTP프로토콜에서 TLS(SSL) 프로토콜을 사용하여 세션 데이터를 암호화한다.
    * 컬렉션뷰는 각각의 셀의 크기를 조정한다기 보다는 오토레이아웃과 estimatedItemSize를 사용해서 셀의 크기를 조정한다.
    * UICollectionLayoutListConfiguration
        * 컬렉션뷰에서 리스트 모양을 보여줄 수 있는 클래스
    * UICollectionViewLayout
        * 컬렉션뷰의 레이아웃을 커스텀할 때 사용하는 클래스
    * 셀을 끌어다가 드래그 하는 것을 드래그 앤 드랍이라고 표현하지 않고 셀의 이동이라고 봐야한다.
        * 드래그 앤 드랍은 테이블뷰에서 컬렉션뷰로 옮기는 것을 뜻한다. 

---

* 테이블뷰와 컬렉션뷰의 공통점과 차이점
    * **공통점**
        - 테이블뷰, 컬렉션뷰 둘다 콘텐츠 관리를 데이터소스와 델리게이트로 관리한다.
        - 스크롤이 가능하다.
        - 셀을 재사용할 수 있다.
    * **차이점**
        - 테이블뷰는 가로스크롤이 불가능하다.
        - 테이블뷰는 한가지 모양의 셀만 만들수있는데 컬렉션뷰는 다양한 모양의 셀을 한화면에 같이 보여줄 수 있다. 
       - 예를 들어, 헤더, 메뉴, 본문, 푸터 각각 셀을 만들어서 원하는 모양으로 만들고, 하나의 뷰 컨트롤러에 셀을 조합해서 한 화면에 나타나게 할 수 있습니다. 이 방법을 사용하면 자주 사용하는 셀을 재활용할 수 있습니다. 
        - 테이블뷰는 액세서리뷰와 컨텐츠뷰로 나눠져있지만 컬렉션뷰는 배경뷰와 컨텐츠뷰로 나눠져있다. 
        - 테이블뷰는 디폴트 형식이 정해져있는데 컬렉션뷰는 셀을 직접 커스텀해야한다.
        - 텍스트인 경우에는 테이블뷰를 사용하는 것을 권장한다.
           - Consider using a table instead of a collection for text. It’s generally simpler and more efficient to view and digest textual information when it’s displayed in a scrollable list.
* 각 앱 화면에 적절한 뷰(테이블뷰와 컬렉션뷰 중에서)를 고르고 그 이유를 적어보자.
* **페이스북 - 타임라인**
    > **컬렉션뷰**
    > **이유** : 다양한 크기의 셀이 존재하고 다양한 이미지나, 동영상, 댓글 등등 셀마다 다양한 콘텐츠가 들어있다.
* **인스타그램 - 타임라인**
    > 컬렉션뷰
    > **이유** : 다양한 크기의 셀이 존재하고 다양한 이미지나, 동영상, 댓글 등등 셀마다 다양한 콘텐츠가 들어있다.
* **미리 알림 앱**
    * **메인화면**
        > 컬렉션뷰 + 테이블뷰
        > **이유** : 컬렉션뷰와 테이블뷰가 섞여있는 것 같다. (테이블뷰가 아닌건지.. 컬렉션뷰가 맞는건지 잘모르겠다.) 그리고 텍스트, 액세서리뷰가 포함되어있다.
    * **미리 알림 목록화면**
        > 테이블뷰
        > **이유** : 셀의 구조가 테이블뷰와 흡사하다. 또한 왼쪽으로 스와이프시 편집 컨트롤이 나타난다.
* **iPhone App Store의 투데이 화면**
    > 컬렉션뷰
    > **이유** : 안에 들어가있는 컨텐츠의 구조가 다르다. 그리고 내부에 테이블뷰가 들어가있는 형태도 있다.
* **시계 앱의 알람 목록화면**
    > 테이블뷰
    > **이유** : 동일한 구조가 반복되며, 섹션이 나눠져있고, 스와이프시 편집 컨트롤이 나타난다.

---

**[URLSession]**

* NSURLConnection
    * Asynchronous event-based API
    * 기능
        * Persistent connections (세션 연결 유지)
        * Pipelining (이어받기)
        * Authentication (인증)
        * Caching (URL 캐쉬)
        * Cookies (쿠키)
        * Socks and HTTP proxy (프록시) 
* WebKit?
    * 오픈소스 웹브라우저 엔진
* App Transport Security Settings 
* ![](https://i.imgur.com/OE5wyTD.png)
* 접속하는 사이트만 권장
* URL Session Classes
* ![](https://i.imgur.com/HIaduZp.png)
* NSURLSession
    * Singleton shared session
        * 델리게이트 없이 간단한 비동기 요청
        * 특정한 세션의 처리를 하기 위한 델리게이트 없이 그냥 간단한 비동기 요청을 보내고 그 요청에 대한 응답을 비동기로 처리하게끔 클로저를 넘기는 구조
    * Default session
        * 기본 설정 세션 커스텀 설정 가능
        * configuration 객체에 값을 바꾼 다음에 세션을 만들 때 넘겨주면 커스텀 설정으로 생성이 가능하다.
    * Ephemeral session
        * 델리게이트 없이 비공개(private) 세션
        * Delegate없이 비공개 세션을 만들 때 사용한다.
        * 사파리나 크롬에서 시크릿 모드를 만들 때 사용한다.
        * 쿠키나 세션정보가 남아있지 않게 된다.
    * Background session
        * 백그라운드 동작을 위한 세션
        * 앱이 멈추거나 앱을 나가더라도 앱을 사용하지 않더라고 운영체제 딴에서 백그라운드로 동작을 해주게끔 세션을 유지해주는 세션이다.
        * 지하철 앱이나 지도앱이나 이런 업데이트된 데이터를 받고싶어 하면 백그라운드 세션을 만들어 놓으면 그 세션이 유지되면서 네트워크로 업로드도 되고 다운로드도 된다.
* ![](https://i.imgur.com/fGyUKWc.png)
* URLSession은 Task를 만들어서 넘겨야 한다.
    * 보통 요청하고 받는건 DataTask
    * 파일이나 데이터를 업로드 할 때는 UploadTask
    * 한꺼번에 여러개를 다운로드 할 때는 DownloadTask
* 대부분은 dataTask를 많이 쓴다.
* URLSession은 7단계를 거쳐서 코드를 작업하면 된다.
    * 세션의 configuration을 만든다.
    * 위 설정값을 가지고 세션을 만드는데, 세션을 만들 때 델리게이트를 줄 수도 있고, 안줄 수도 있다.
    * 그 다음에 Task을 만들면서 URL을 넘겨준다.
    * 요청을 보낼 때 델리게이트를 지정해서 쓰면 클로저가 필요 없을 수도 있다. 델리게이트가 없다면 클로저를 전달해서 요청한다.
    * 비동기 메서드라서 resume을 보내는 순간 리턴이 되면서 끝난다.
    * 이후 응답을 받으면 에러나 혹은 응답받은 결과물을 전달해준다.
    * 리줌은 비동기방식, 콜백이 넘어올 때는 동기방식
* DataTask 예제
* ![](https://i.imgur.com/EwApThz.png)
* URLSession이 동작하는 구조
    * 데이터 Task를 만들면 Suspended 상태로 시작을 한다.
    * 리줌을 해주고 나면 Running 상태가 된다.
    * 그다음에 받는 이벤트는 Response가 온다. didReceiveResponse 메소드 호출
    * 바디가 들어왔으면 didReceiveData 메소드 호출
    * 캐시 관련된 리스폰스도 델리게이트 메소드를 호출
    * 다 받고나면 didCompleteWithError 메소드가 호출이 되면서 Finished 상태로 바뀐다.
    * 이렇게 시점을 알고싶다면 델리게이트 메소드를 정의해야하고 그렇지 않으면 클로저만 성공했을 때 실패했을 때 클로저만 가지고도 기본적인 동작을 다 구현할 수 있다.
* Background Transfer
    * 앱이 멈춘 후에도 백그라운드 전송 지원
    * 이벤트 처리를 위한 델리게이트 메소드가 필수
    * HTTP / HTTPS 프로토콜만
    * 리다이렉트 지원
    * 업로드는 파일만 가능

---

**[오픈마켓 프로젝트 고민]**

* GET에는 바디를 붙일 수가 없다.
* Header는 여러개일 수도 있다.
    * 상품 삭제의 경우 identifier라는 헤더와 바디에 들어가는 Content-Type 이라는 헤더, 총 2개의 헤더가 들어가야 한다.
* **Health Checker가 뭐지?**
    - 이거는 API가 살아있는지 확인하는 것
- 등록, 수정, 삭제 등.. 모두 들어가는 바디가 약간씩 다르다.
    - 각 상황에 맞는 타입을 따로 구현해줘야하려나?
- http method가 String으로 들어가는데.. 별도 타입으로 만들어주면 좋겠다.

---

- 참고링크
    - https://developer.apple.com/documentation/foundation/urlsession
    - https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory
    - https://youtu.be/toU4o5Z0cVM

