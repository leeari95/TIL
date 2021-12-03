# 211011 condition, condition-list, flow chart, 일반화추상화은닉화캡슐화, Ground rules, Daily Scrum, 메소드명
# TIL (Today I Learned)

10월 11일 (월)

## 학습 내용
오늘은 활동학습으로 타입을 설계할 때 `일반화, 추상화, 캡슐화, 은닉화` 를 어떤식으로 하면 좋을 지 학습해보았다. 알고있던 개념이였지만 **역시나** 언제나처럼 마치 처음 접하는 개념마냥 새롭게 다가왔고, 팀원들과 함께 타입을 설계하는 법에 대해서 배워보는 유익한 시간을 보냈다. 이후 새로운 팀프로젝트 팀원인 `알라딘`과 함께 그라운드 룰을 정하고 프로젝트를 진행하기 시작하였다.
 
## 문제점 / 고민한 점
- `일반화, 추상화, 캡슐화, 은닉화`의 개념을 정확하게 모르겠네...
- 크루, 야곰이 `Ground rules`과 `Daily Scrum`을 강조하네? 이유가 뭘까?
- 순서도를 세세히 꼼꼼하게 적는게 정말 좋은걸까? 가독성이 떨어지진 않을까?
- 메소드명을 지을 때 파라미터명과 연결해서 지어주는 것이 나은건가? 아니면 한꺼번에 지어주는 것이 알맞을까?
- 메소드 내부에 있는 `readLine()`을 파라미터 받고, 메소드 내부로 넘겼을때 왜 커멘트 라인이 작동을 안할까?
- ` , && ` AND연산자와 쉼표의 쓰임새가 정말 같은걸까? 쉼표를 쓸때 나는 에러는 왜나는거지?
    
&nbsp;

## 해결방법
- 예전에 메모해둔 것을 찾았다...!!! 타입을 설계할 때 꼭 다시 읽어봐야지!
    - **일반화(Generalization)** 인스턴스의 공통 특징을 뽑아내는 것
    - **추상화(Abstraction)** 공통 특성 중 관심이 있는 부분만 추출하고 나머지는 무시하는 과정
    - **은닉화(Hiding)** 주요 사항이 겉으로 드러나지 않도록 감추는 것
    - **캡슐화(Encapsulation)** 중요사항을 감춘 상태에서 외부에서 그것을 사용할 수 있는 방법을 제공하고 외부와 소통을 하는 것
- 확실히 `Ground rules`을 정하고 프로젝트를 진행하니 훨씬 마음도 편하고, 스케줄 관리가 되는 느낌이라 쾌적한[?] 프로젝트를 진행할 수가 있었다..! 아침에 `Daily Scrum`도 진행해보기로 하였다.
- 순서도를 그리다가 너무 세세한 부분은 가독성이 떨어지는 것 같아 `Steven`에게 조언을 구했다. 세세한 부분은 `따로 떼어내서 작성`하는 것이 좀 더 가독성이 좋다는 생각을 듣고 반영해보았는데 훨씬 순서도가 보기 편하게 바뀌었다. 그리고 세세하게 그려보면서 로직을 어떻게 구현해야할 지 감도 잡히고, 프로젝트 진행 중간에 헷갈리면 정리하는 느낌으로 순서도를 유용하게 활용했다.
- 메소드명을 짓다가 API 문서를 보아도 헷갈리는 부분이 있었다. 알라딘과 의견을 나누어보았으나 확신이 서질 않아서 리뷰어인 `Soll`에게 의견을 물어보았는데, 따로 메소드명+파라미터명을 연결해서 지어보는 것이 좀더 좋아보인다고 의견을 주셨다. 나중에 이 부분은 PR을 보낼 때 한번 더 상세히 물어봐야겠다.
- `readLine()` 역시 항상 질문환영 방에 들어가계시는 `Steven`에게 여쭤보았다. 코드를 자세히 살펴보니 코드 `순서`의 문제였다. 순서만 해결해준다면 `readLine()`도 파라미터로 받아서 사용할 수 있을 것 같다! 내일 알라딘과 이야기 해봐야지.
- `,`는 `condition`을 `이어붙이는 용도`로 쓰는 것이고, `&&`는 `두개의 boolean expression`을 `파라미터로 받는 논리 연산자`이다.
    - `condition을 이어 붙인다`고 했는데, 이렇게 이어 붙여진 condition을 **condition-list**라고 부른다
    - **condition**은 뭘까?
    `expression`, `availability-condition`, `case-condition`, `optional-binding-condition`
    - `while, if, guard` 문에는 `condition-list`를 쓰지만, `repeat-while` 문에서는 `condition`만 쓸 수 있다.
    - 콤마로 여러 condition을 이어붙이는 것이 **허용된 곳**과 **아닌 곳**이 있는 것이다. 
        ```swift
        if let result = result && result {
        if let result = result , result {
        ```
        이 두 구문이 어떻게 다른 것일까?
        첫번째 구문은 하나의 `expression`이다. 양쪽의 A && B 를 논리연산자로 계산해 참, 거짓의 결과를 가져온다
        두번째 구문은 `expression`, `expression`으로 이루어진 `condition-list`이다. 즉 두개의 `expression`이 각 각 참이 되어야 if문이 실행된다. 옵셔널 바인딩이 성공하고, 그 값이 참이어야 실행되는 코드를 만들 수 있다.


&nbsp;

---

- 참고링크
    - [condition](https://docs.swift.org/swift-book/ReferenceManual/Statements.html#grammar_condition)
    - [condition-list](https://docs.swift.org/swift-book/ReferenceManual/Statements.html#grammar_condition-list)
    - [콤마(,)와 &&의 차이](https://soojin.ro/blog/swift-comma-vs-and-operator)
