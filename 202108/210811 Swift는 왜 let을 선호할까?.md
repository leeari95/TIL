# 210811 Swift는 왜 let을 선호할까?
# TIL (Today I Learned)

날짜: 2021년 8월 11일
작성자: 이아리
태그: ARC, Constants, Heap, Variables, 값타입, 메모리관리, 참조타입

## 학습내용

오늘은 캠프를 진행하다가 Set에 대한 개념이 부족하여 글쓰기를 통하여 복습하고 정리해보았다. 그리고 어제 함수를 작성하는 과정에서 왜 Swift는 var보다 let 선언을 선호하는지에 대해 궁금하여 찾아보았다. 찾다보니 Swift는 메모리 관리를 어떻게 하는지도 궁금하게 되어 찾아보았는데, 공부할 내용이 너무 방대했다. ARC를 기준으로 메모리 구조와 값타입, 참조타입에 대해서도 얕게만 알고 있었는데.. 이번 계기로 좀더 깊게 공부를 시작해봐야할 것 같다. 오늘은 시작 전에 맛보기로 공부 키워드를 습득해보았다.

## 공부내용 정리

**Swift가 var 및 let을 사용하는 것을 귀찮게 참견하는 이유?**

- 상수(let)는 변경할 필요가 없는 값으로 코드를 보다 안전하고 명확하게 하기 위해 Swift는 전반적으로 상수가 사용된다. 이는 나중에 실수로 값을 변경하지 않도록 하는데 좋다. (휴먼에러)
- 또한 상수로 선언하면 메모리 관리에 더 좋은지 찾아보았더니, 성능에는 아무런 영향이 없다고 한다. 컴파일러가 알아서 최적화 해주기 때문이다. 따라서 Swift가 let 사용하라고 권하는 것은 이 Swift 언어가 지향하는 것이 '안전성'이기 때문이라 생각한다. let으로 선언하면 위와 같이 휴먼에러를 방지할 수 있으니깐 말이다.

**관련링크**

[https://stackoverflow.com/questions/53147092/in-swift-how-bad-it-is-to-declare-variable-in-loops](https://stackoverflow.com/questions/53147092/in-swift-how-bad-it-is-to-declare-variable-in-loops)

[https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html)

- 이후 메모리의 관한 내용 찍먹..

    **Swift는 메모리 관리를 어떻게 할까?**

    ARC(Automatic Reference Counting)를 사용한다.

    **ARC(Automatic Reference Counting)는 무엇인가?**

    - 메모리 영역 중 Heap 영역을 관리한다. Swift는 **Reference Type**들은 자동으로 Heap에 할당한다. Heap의 특징은 사용하고 난 후에는 반드시 메모리 해제를 해줘야 한다. ARC는 이러한 사용하고 남은 Heap의 메모리를 해제해준다.

    **ARC의 메모리 관리 방법**

    Referenc Count(참조 횟수)를 계산하여 참조횟수가 0이면 더 이상 사용하지 않는 메모리라 생각하여 해제한다.

    **RC(**Referenc Count)**란 무엇인가?**

    인스턴스를 현재 누가 가르키고 있느냐 없느냐(참조하냐 안하냐)를 숫자로 표현한 것.

    **RC는 어떤 기준으로 숫자를 셀까?**

    Count Up : 인스턴스의 주소값을 변수에 할당할 때, 인스턴스 생성, 기존 인스턴스 다른 변수에 대입

    Count Down : 인스턴스를 가리키던 변수가 메모리에서 해제되었을 때, nil이 지정되었을 때, 변수에 다른 값을 대입한 경우, 프로퍼티의 경우 속해 있는 클래스 인스턴스가 메모리에서 해제될 때

    **Swift에서 값 타입과 참조 타입**

    ![ex_screenshot](/img/30.png)


## 오늘의 글쓰기

[https://leeari95.tistory.com/14](https://leeari95.tistory.com/14)
