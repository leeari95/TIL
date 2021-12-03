# 211103 TDD, Unit Test, TableView
# TIL (Today I Learned)

11월 3일 (수)

## 학습 내용
오늘은 목요일 활동학습을 위해 Unit Test와 TDD를 예습을 진행하였다. 이후에 Auto Layout의 진도를 조금 나가보았다. TDD는 이전에 flutter를 독학할 때 당시에 강의로 조금 배워본 적이 있는데, 오래되서 다 까먹어버렸다. 기억을 더듬어가며 다시 배워보았다.

&nbsp;

## 문제점 / 고민한 점
- 현업에서는 Unit Test를 필수로 사용할까..?
- TDD로 개발을 진행하려면 어떤 방식으로 하는거였지?
- Auto Layout 강의 중에 TableView 관련 클래스와 프로토콜이 나오는데 뭐가 뭔지 하나도 모르겠네...
    ![](https://i.imgur.com/d9lzJpt.png)
- TableView에서 터치시 셀이 커지고 작아지는 기능을 구현하는데 예상치 못한 nil이 발생하였다며 제대로 동작하지가 않는다.

&nbsp;
## 해결방법
- 기업마다 다르겠지만 많은 기업에서 Unit Test를 적용하여 개발을 진행한다고 한다.
- Red > Green > refacotr를 기억하자. TDD Cycle을 통해서 좋은 코드를 도출해내어 코드를 작성한다. (테스트코드 작성 > 테스트를 통과하는 코드를 작성 > 재사용성과 의존성이 낮은 코드를 작성 > 많은 성공을 이루어낸 코드를 최종적으로 작성)
- # UITableViewDataSource
    테이블 뷰의 셀에 사용되는 데이터를 관리하기 위해 채택하는 프로토콜
    테이블 뷰는 데이터를 보여주기만 하는 것이지 자체적으로 데이터를 관리할 수는 없다. 그래서 해당 프로토콜을 사용해야한다.Data source object는 테이블에서 데이터와 관련된 요청이 오면 응답하며 테이블의 데이터를 직접 관리하거나 앱의 다른 부분과 조정하여 해당 데이터를 관리한다.
- 아무리 찾아봐도 어떤 부분이 잘못됬는지 못찾았다... 분명 강의대로 따라서 했는데 오류는 왜 발생하는 것일까? 쩝...


&nbsp;

---

- 참고링크
    - [UIListContentConfiguration](https://developer.apple.com/documentation/uikit/uilistcontentconfiguration)
    - [Filling a Table with Data](https://developer.apple.com/documentation/uikit/views_and_controls/table_views/filling_a_table_with_data)
    - [UITableViewCell](https://developer.apple.com/documentation/uikit/uitableviewcell)
    - [UITableViewDataSource](https://developer.apple.com/documentation/uikit/uitableviewdatasource)
    - [TDD](https://ko.wikipedia.org/wiki/%ED%85%8C%EC%8A%A4%ED%8A%B8_%EC%A3%BC%EB%8F%84_%EA%B0%9C%EB%B0%9C)
    - [Unit Test 강의](https://yagom.net/courses/unit-test-%ec%9e%91%ec%84%b1%ed%95%98%ea%b8%b0/)
