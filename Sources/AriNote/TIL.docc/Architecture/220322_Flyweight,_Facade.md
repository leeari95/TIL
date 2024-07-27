# 220322 Flyweight, Facade 

# TIL (Today I Learned)

3월 22일 (화)

## 학습 내용

- 데코레이터 외에 나머지 패턴 공부

&nbsp;

## 고민한 점 / 해결 방법

**[Flyweight Pattern]**

### 플라이웨이트 패턴이란?

메모리 사용량과 처리를 최소화하기 위한 디자인 패턴.
각 객체의 모든 데이터를 유지하는 대신 여러 객체 간에 State 공통 부분을 공유하여 메모리에 더 많은 객체를 넣을 수 있는 구조적 디자인 패턴이다.

### 구조

![](https://i.imgur.com/soFAOqg.png)

* Flyweight
    * 공유할 수 있는 정보를 갖는 플라이웨이트 객체를 정의.
* FlyweightFactory
    * Flyweight 객체를 만들고 관리한다.
    * Flyweight의 공유정보가 올바르게 공유되도록 한다.
    * 클라이언트가 Flyweight 객체를 요청하면 팩토리가 이전에 만들어 놓은 동일한 Flyweight 객체가 있는지 찾아보고 없다면 새로 생성한다.
* Concreate Flyweight
    * Flyweight 인터페이스를 구현하고 공유 상태에 대한 저장공간을 확보한다.
    * 여기에 저장하는 상태들은 intrinsic state(고유한 상태)라고 한다.
* Unshared Concreate Flyweight (Context)
    * 이 클래스는 Concrete Flyweight 객체를 자식으로 갖는다.
    * 모든 Flyweight 서브 클래스를 공유할 필요는 없다.
* Client
    * Flyweight에 대한 참조를 유지한다.
    * Flyweight 객체의 각각의 상태를 처리하거나 저장한다.

### 언제 사용할까?

* 싱글톤을 사용하지만, 구성이 다른 여러개의 비슷한 공유 인스턴스가 필요할 때 사용한다.

### 장점

* 앱에 유사한 인스턴스를 대량으로 만들어야할 때 메모리 절약 가능

### 단점
* Flyweight Factory에서 인스턴스가 이미 존재하는지 확인하기 위한 데이터 검색을 수행하는 런타임 비용이 추가 발생
    * 메모리 절약과 trade-off라서 어쩔 수 없긴 하지만 공유하는 인스턴스가 많아질 수록 런타임 비용이 커진다.
* 코드가 복잡해질 수 있다.


---

**[Facade Pattern]**

### 파사드 패턴이란?

![](https://i.imgur.com/lDHLA6g.png)

라이브러리, 프레임워크, 혹은 복잡한 클래스들의 집합에 대한 단순화된 인터페이스를 제공하는 디자인패턴이다.
하나의 시스템을 서브 시스템들의 조합으로 구성하면 복잡성을 줄이는데 도움이 된다.
이러한 설계의 목표는 서브 시스템 간 통신 및 종속성을 최소화하는 것인데, 이를 위한 방법으로 서브 시스템의 기능을 단순한 인터페이스를 제공하는 파사드 객체를 사용하는 것이다.

### 구조

![](https://i.imgur.com/TRWfVRB.png)

* Facade
    * 어떤 Subsystem 클래스가 클라이언트의 요청에 응답해야하는지 알고 있다.
    * 클라이언트의 요청을 적절한 Subsystem에게 전달한다.
* Subsystem
    * Subsystem 기능을 구현한다.
    * Facade 객체에서 전달받은 요청을 처리한다.
    * 서브 시스템 클래스들은 Facade 객체의 존재를 모른다.
* Client
    * 클라이언트는 서브 시스템 객체를 직접 호출하는 대신 Facade를 사용한다.

### 언제 사용할까?

* 서브 시스템을 계층화하고 싶을 때
* 복잡한 서브 시스템들을 간단하게 사용하기 위한 인터페이스를 만들고 싶을 때


### 장점

* 서브 시스템의 복잡성으로부터 코드를 분리할 수 있다.
* 서브 시스템으로 부터 클라이언트를 보호하고 클라이언트가 서브 시스템을 사용하기 쉽게 만들어준다.
* Facade를 사용하여 시스템과 객체 간 종속성을 계층화할 수 있다.
* 컴파일 종속성을 줄여 서브 시스템이 변경될 때 컴파일 시간을 줄여준다.

### 단점

* Facade 객체는 앱의 모든 클래스에 결합된 객체가 될 수도 있다.


https://icksw.tistory.com/246
https://refactoring.guru/design-patterns/facade



---

- 참고링크
    - https://icksw.tistory.com/246
    - https://icksw.tistory.com/247
    - https://refactoring.guru/design-patterns/facade
    - https://it-mesung.tistory.com/183

