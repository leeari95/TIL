# 211206 TableView 활동학습, JSON
# TIL (Today I Learned)


12월 6일 (월)

## 학습 내용
- 만국박람회 프로젝트 STEP1 진행
- JSON 파일을 참고하여 타입 설계
- TableView 활동학습
- TableViewCell, DataSource, Delegate, 뷰의 재사용 다시 [복습](https://github.com/leeari95/TIL/blob/main/2021-12/211203_TableView,_%EB%B7%B0%EC%9D%98%EC%9E%AC%EC%82%AC%EC%9A%A9.md)하기

&nbsp;

## 고민한 점 / 해결 방법
- **[TableView Cell Sytle]**
    - [HIG](https://developer.apple.com/design/human-interface-guidelines/ios/views/tables/)에 들어가니 셀의 스타일들이 나온다.
    - ![](https://i.imgur.com/yfhHvNu.png)
- **[활동학습 다시 스스로 풀어보기]**
- 스크롤 다운 → (5,2) 터치 → 스크롤 업 → (3,1) 터치 → 스크롤 업 → (1,0)터치 → 스크롤 업 → (0,1) 터치 → (0,0) 터치
    - ## `User` : 앱을 켜야지~
    - `Table View`이 `Table View Data Source`에게 : 보여줘야 하는 Section 0의 수는 몇개입니까?
    - `Table View`이 `Table View Data Source`에게 : Section 0은(는) 몇 개의 Row를 보여줘야 합니까?
    - `Table View Data Source`이 `Cell Reuse Queue`에게 : (0, 0) ~ (0, 2) IndexPath에 보여줄 셀인데, Cell Reuse Identifier에 해당하는 Cell을 주십시오 

    ---

    - ## `User` : 아래로 스크롤 해야지 스크롤
    - - `Table View`이 `Table View Data Source`에게 : 보여줘야 하는 Section 1~8의 수는 몇개입니까?
    - `Table View Data Source`이 `Cell Reuse Queue`에게 : (1, 0) ~ (8, 2) IndexPath에 보여줄 셀인데, Cell Reuse Identifier에 해당하는 Cell을 주십시오 
    - `Table View Data Source`이 `Cell Reuse Queue`에게 : Cell Reuse Identifier에 해당하는 Cell 중에 대기중인 Cell이 있어요. 드릴게요.
    - `Table View Data Source`이 `Cell Reuse Queue`에게 : Cell Reuse Identifier에 해당하는 Cell 중 대기중인 Cell이 없어 새로 만들어 드릴게요.

    ---

    - ## `User` : 위로 스크롤 해야지 스크롤
    - `Table View`이 `Table View Data Source`에게 : 보여줘야 하는 Section 5~8의 수는 몇개입니까?
    - `Table View Data Source`이 `Cell Reuse Queue`에게 : (5, 1) ~ (8, 2) IndexPath에 보여줄 셀인데, Cell Reuse Identifier에 해당하는 Cell을 주십시오 
    - `Table View Data Source`이 `Cell Reuse Queue`에게 : Cell Reuse Identifier에 해당하는 Cell 중에 대기중인 Cell이 있어요. 드릴게요.

    ---

    ![](https://i.imgur.com/jibM1lI.png)

    - ## `Table View Delegate` : 5, 2 셀 터치!!
    - `Table View Delegate`이 `Table View`에게 : 사용자가 S, R의 row를 선택했다구!
    - `Cell` : 얼럿을 띄워야지

    ---

    - ## `User` : 위로 스크롤 해야지 스크롤
    - `Table View`이 `Table View Data Source`에게 : 보여줘야 하는 Section 3~6의 수는 몇개입니까?
    - `Table View Data Source`이 `Cell Reuse Queue`에게 : (3, 0) ~ (6, 0) IndexPath에 보여줄 셀인데, Cell Reuse Identifier에 해당하는 Cell을 주십시오 
    - `Table View Data Source`이 `Cell Reuse Queue`에게 : Cell Reuse Identifier에 해당하는 Cell 중에 대기중인 Cell이 있어요. 드릴게요.

    ---

    ![](https://i.imgur.com/hpqz3bV.png)

    - ## `Table View Delegate` : 3, 1 셀 터치!!
    - `Table View Delegate`이 `Table View`에게 : 사용자가 S, R의 row를 선택했다구!
    - `Cell` : 얼럿을 띄워야지

    ---

    - ## `User` : 위로 스크롤 해야지 스크롤
    - `Table View Data Source`이 `Cell Reuse Queue`에게 : (0, 2) ~ (3, 0) IndexPath에 보여줄 셀인데, Cell Reuse Identifier에 해당하는 Cell을 주십시오 
    - `Table View Data Source`이 `Cell Reuse Queue`에게 : Cell Reuse Identifier에 해당하는 Cell 중에 대기중인 Cell이 있어요. 드릴게요.

    ---

    ![](https://i.imgur.com/hzFhHJV.png)

    - ## `Table View Delegate` : 1, 0 셀 터치!!
    - `Table View Delegate`이 `Table View`에게 : 사용자가 S, R의 row를 선택했다구!
    - `Cell` : 얼럿을 띄워야지

    ---

    ![](https://i.imgur.com/utW2unz.png)

    - ## `Table View Delegate` : 0, 0 셀 터치!!
    - `Table View Delegate`이 `Table View`에게 : 사용자가 S, R의 row를 선택했다구!
    - `Cell` : 얼럿을 띄워야지

    ---
    
- **[JSON을 디코딩할 때 프로퍼티들은 왜 변수일까?]**
    - 구글링을 열심히 해보았지만 정확한 근거는 찾지못했다.
    - 따로 공식문서에 기재도 안되어있는거 보니 별로 중요하지도 않고, let 이든 var든 개발자에 의도에 따라 정의해주면 될 것 같다는 결론이 났다.
    - 따라서 이번 만국박람회에서는 데이터를 파싱해오고 따로 변경하거나 하지 않을 것이기 때문에 let으로 해주어도 상관 없다는 생각이 들었다.
- **[API란?]**
    - Application Programming Interface)의 약자이다.
    - API는 점원이다. 레스토랑에서 손님에게 주문 가능한 메뉴를 보여주고 손님이 고른 음식을 주방에 전달 후 음식이 나오면 고객에게 전달하는 '점원'이 API라고 볼 수 있다.
    - 응용 프로그램에서 사용할 수 있도록 운영체제나, 프로그래밍 언어가 제공하는 기능을 제어할 수 있게 만든 인터페이스를 뜻한다.
- **[Interface란?]**
    - 컴퓨터 시스템끼리 정보를 교환하는 공유 경계를 의미.
    - 터치스크린과 같은 일부 컴퓨터 하드웨어 장치들은 인터페이스를 통해 데이터를 송수신 할 수 있으며, 마우스나 마이크론 폰가 같은 장치들은 오직 시스템에 데이터를 전송만 하는 인터페이스를 제공한다.
    - 간단하게 인터페이스는 사물과 사물 또는 사물과 사람 사이에서 상호간의 소통을 위해 만들어진 매개체나 규약이라고 생각하면 된다.
- 결국 API는 어떤 프로그램에서 데이터를 주고 받기 위한 방법이 되겠다.
- Postman을 활용하여 API 직접 찔러보기.
- ![](https://i.imgur.com/RsO2R1J.png)
- ![](https://i.imgur.com/H3jsvpU.png)
