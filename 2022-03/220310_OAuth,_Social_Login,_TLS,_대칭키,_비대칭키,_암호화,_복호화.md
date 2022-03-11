# 220310 OAuth, Social Login, TLS, 대칭키, 비대칭키, 암호화, 복호화

# TIL (Today I Learned)
3월 10일 (목)

## 학습 내용

- OAuth / Social Login 활동학습

&nbsp;

## 고민한 점 / 해결 방법

**[암호화 방식]**

암호화 방식에는 크게 3가지 정도 있다.
* 대칭키
    * 암호화 복호화에 동일한 키를 사용하는 방식. 그래서 키를 비공개함
    * 정보 교환당사자 간에 동일한 키를 공유해야 하므로, 여러 사람과 정보 교환 시 많은 키를 유지/관리해야 하는 어려움 존재
* 비대칭
    * 암호화 복호화에 쌍을 이룬 서로 다른(공개키-개인키)를 사용하는 방식. 하나의 키는 공개
    * 데이터 암호화 속도가 대칭키 암호화 방식에 비해 느리기 때문에 일반적으로 대칭키 암호화 방식의 키 분배 또는 카드번호와 같은 작은 크기의 데이터 암호화에 많이 사용된다.
* 해싱
    * HD5
    * 만약에 abc라는 글자를 해싱을 한다고 하면 항상 123이 나오도록 하는 알고리즘
    * 항상 일정한 값을 넣으면 일정한 출력이 나오는 알고리즘이다.
    * 암호화 대신 썼던 이유는 글자를 넣으면 임의의 글자가 나오기 때문에 유추하기 어려웠다.
    * 하지만 해커들이 이미 테이블을 완성했기 때문에 변화된 문자열을 통해 암호를 유추할 수 있게되어서 더이상 사용하지 않는다.


**[대칭키/비대칭키 암호화 방식의 대표적인 알고리즘]**

### 대칭키

* ### `DES`
    * ![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FddmrN1%2FbtrbtoJCiDF%2FeuecUhWqO80gmE12WMqLZ1%2Fimg.png)
    * 64bit 블록, 128bit 암호화 키 사용
    * 평문을 64bit로 나눠 각 블록에 치환과 전치를 16Round 반복하여 암호화
* ### `3-DES`
    * ![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbKuhMO%2Fbtrbor8jqnY%2FXLRYuP8fhCaGpSSOmrSfY0%2Fimg.png)
    * 암호화키 2개를 사용하여 암호화(K1) -> 복호화(K2) -> 암호화(K1) 순으로 암호화
* ### `AES`
    *![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Fx60Ea%2FbtrbkXl5YAq%2FjVNVJBMmIfOC1BQde9x05k%2Fimg.png)
    * 128bit 평문을 128bit로 암호화
    * 키 크기에 따라 10/12/14회 Round 수행
    * 라운드 키의 수 = N + 1개

### 비대칭키

![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Fbi9uLq%2FbtrbllnjBl8%2FQzYfVM7KmH6EYVOVSiQs0k%2Fimg.png)

* ### RSA
    * 큰 숫자를 소인수분해하는 것이 어렵다는 것에 기반하여 개발
    * 공개키만 가지고 개인키 추측 불가
* ### DSA
    * 이산대수의 어려움을 안정성의 바탕으로 개발

**[Google, Apple, Naver, Kakao의 TLS 인증서는 어떤 알고리즘(들)에 의해 암(복)호화 하는지 알아보기]**

* ## Google의 경우...
    * TLS_AES_128_GCM_SHA256
        * 암호화 복호화하는 방식들의 쌍을 표현하는 방법중 하나이다. ([Cipher Suite](https://ko.wikipedia.org/wiki/%EC%95%94%ED%98%B8%ED%99%94_%EC%8A%A4%EC%9C%84%ED%8A%B8))

> `TLS` - 프로토콜(SSL/TLS)
`AES_128` - 대칭키를 이용한 블록 암호화 방식
`GCM` - 블록 암호 운용방식
`SHA256` - 메세지 인증 (무결성)

Apple, Naver, Kakao도 비슷~


**[공동인증서(구 공인인증서)는 어떤 방식으로 암(복)호화가 이뤄지는지 알아보기]**

![](https://i.imgur.com/2v2SXTM.png)


SEED
* 한국인터넷진흥원(KISA)에서 1999년에 개발한 대칭키 암호화 알고리즘

ARIA
* 한국인터넷진흥원에서 SEED의 단점을 보완하여 새롭게 낸 대칭키 암호화 알고리즘

PKI(Public Key Infrastructure)

![](https://i.imgur.com/XIuN6jU.png)

>예전 공인인증서는 비밀키를 사용자에게 맡겨버린게 함정이다...
집에도 비밀키(인증서)를 설치하고.. 피시방에도 깔아두고.. 회사컴에도 깔아두고..... 해커도 가지고 있고...


**[암호화를 왜 알아둬야 할까?]**
* 직접 암호화를 구현할 일은 없겠지만... 어떤 동작으로 이루어지고 있는지, 어떤 방식으로 암호화가 되고 있는지 알고있어야 나중에 개발할 때 서버개발자와 원활한 대화를 할 수 있다.

---

**[OAuth와 소셜 로그인]**

### OAuth란?
* 각종 웹, 모바일 어플리케이션에서 타사의 API를 사용하고 싶을 때 권한 획득을 위한 프로토콜(Protocol)이다.
* 사용자와 서버 사이에서 인증을 중개해주는 역할을 가진 메커니즘으로 제각각으로 분리된 인증방식을 통일한 표준화된 인증방식이다.
* fecebook으로 로그인, Google 계정으로 로그인, Naver로 로그인
* 이러한 기능으로 여러분은 특정 서비스에 대한 회원가입 과정을 거치지 않고 기존에 사용하던 서비스들의 계정으로 로그인을 진행할 수 있다.

### Authentication(인증)과 Authorization(권한 부여)의 차이
* 인증은 '내가 누구인가'를 증명하는 것으로 로그인과 같은 것이다
* 권한 부여는 인증을 통해 로그인한 사람이 '일반 사용자'인지 '관리자'인지 구분하는 것이다. 이 권한 부여를 통해 로그인한 사람이 접근할 수 있는 범위가 결정된다. (관리자라면 관리자 페이지 접근이 가능한 것과 같은 것)

### OAuth 구성 요소
* Resource Owner (사용자, 브라우저 등)
* Authorization server(OAuth 인증 서버)
* Resource Server(REST API)
* Client(서버 = 앱)
* RedirectURL
    * OAuth 2.0 서비스가 응용 프로그램을 승인한 후 사용자를 반환하는 곳으로 반드시 등록되어야 한다.
    * 그렇지 않으면 사용자 데이터를 도용할 수 있는 악성 응용 프로그램을 쉽게 만들 수 있다.
    * 이 URL은 인증 프로세스 중 가로칠 수 있는 행위의 코드를 막는 https 엔트 포인트가 되어야 한다.
* state 매개변수
    * OAuth 2.0 서비스에 불투명한 문자열이므로 초기 권한 부여 요청 시 전달되는 상태 값은 사용자가 애플리케이션을 승인한 후 반환한다.

### OAuth 2.0의 장점
* 타사의 정보를 통해 특정 사이트를 이용한다는 것은 매우 위험할 수 있으나 직접 타사의 아이디와 비밀번호를 입력하던 예전 방식보다 안전한 사용을 제공한다.
* 정보는 회원 정보뿐만 아니라 기타 API에 대한 정보에도 접근이 가능하다.
* Excess token이 server간에 교환됨으로 key가 탈취될 위험이 준다
* 유저가 A site의 계정으로 다른 B, C site들에 로그인할 수 있으므로 해당 유저는 A의 계정만 관리하면되고, B, C들은 유저의 개인정보를 못 가지게 되서 혹 B, C가 해킹 당할 경우에도 A의 개인정보를 바꿀 필요가 없다.
* 사용자가 직접 B, C의 접근 권한을 취소 시킬 수 있다.

이렇게 사용자들이 타사에서 사용하고 있는 서비스들에 대한 정보를 가져와 가공하여보다 가치있는 결과물을 사용자들에게 제공할 수 있다.
가장 많이 이용되는 곳이 바로 타사의 인증된 회원정보를 통한 로그인이다.
일반 로그인은 회원가입할 때 사용했던 아이디와 비밀번호를 통한 인증(Authentication)이라면 OAuth 2.0은 타사 서비스(Google, facebook)의 이메일 정보에 우리가 만든 서비스의 접근을 허락(Authorization)하여 사용자를 인증(Authentication)한다.

```
Client - 사용자가 사용하려는 우리가 만든 서비스
Resource Server - 서비스에 자신의 API를 제공하는 타사 서비스
Resource Owner - 타사 서비스 API의 정보의 주인, 즉 우리가 만든 서비스를 타사 서비스를 통해 이용하려는 사용자
```

---

애플이 인정하는 암/복호화 셋트
- https://developer.apple.com/documentation/security/1550981-ssl_cipher_suite_values?language=objc

애플이 권장하는 TLS 버전
- https://developer.apple.com/documentation/security/secure_transport

---

- 참고링크
    - https://kdevkr.github.io/ssl-certificate/
    - https://rsec.kr/?p=455
    - https://velog.io/@curiosity806/HTTPS%EC%9D%98-%EC%95%94%ED%98%B8%ED%99%94SSLTLS-%EB%8C%80%EC%B9%AD%ED%82%A4-%EB%B9%84%EB%8C%80%EC%B9%AD%ED%82%A4
    - https://velog.io/@inyong_pang/Programming-%EC%95%94%ED%98%B8%ED%99%94-%EC%95%8C%EA%B3%A0%EB%A6%AC%EC%A6%98-%EC%A2%85%EB%A5%98%EC%99%80-%EB%B6%84%EB%A5%98
    - https://babbab2.tistory.com/5?category=960153
    - https://support.google.com/a/answer/9795993?hl=ko
