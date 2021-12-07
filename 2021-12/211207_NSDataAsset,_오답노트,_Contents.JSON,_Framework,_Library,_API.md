# 211207 NSDataAsset, 오답노트, Contents.JSON, Framework, Library, API
# TIL (Today I Learned)


12월 7일 (화)

## 학습 내용
- 만국박람회 프로젝트 STEP1 PR 작성
- NSDataAsset 타입이란?
- 카훗 오답노트
- Contents.JSON?
- 프레임워크와 라이브러리, API 정리

&nbsp;

## 고민한 점 / 해결 방법
**[NSDataAsset]**
* 에셋 카탈로그에 저장된 데이터 집합 타입으로부터의 객체이다.
*  해당 타입을 활용하여 Asset에 있는 JSON 파일을 디코딩해볼 수 있다.
```swift
// 파일이름을 전달하면 JSON파일을 디코딩해주는 함수
   func decode(fileName: String) -> T? {
        guard let dataAsset: NSDataAsset = NSDataAsset(name: fileName) else { // Data 옵셔널바인딩
            return nil
        }
        let decoder: JSONDecoder = JSONDecoder()
        let exposition = try? decoder.decode(T.self, from: dataAsset.data) // 바인딩한 data를 파라미터로 넘겨줌
        return exposition
    }
```
**[카훗 오답노트]**
* ARC를 통한 인스턴스의 생명주기는 컴파일타임에 결정된다
* 백그라운드 사용 앱은 백그라운드 실행 중 시스템이 앱을 언제 종료할지 알 수 있다.
    * `이 앱은 백그라운드에서 실행하게 만들겁니다.` 라고 명시한 것이기 때문에 언제 종료하는지 알수 없으면 안된다.
* 코드를 통해 프로그래머가 정확하게 확인할 수 있는 사항은?
    * 앱이 어떤 방법(홈에서, 푸쉬에서 등)을 통해 실행됐는지
    * 앱이 백그라운드로 전환된 시점
    * 앱의 첫 화면이 보여지는 시점
        * 앱이 종료된 시점은 절대 알수가 없다.
* 컴퓨터 CPU의 구성요소가 아닌 것은 RAM이다.
    * M1칩 같은 경우에는 CPU가 아니라 통합 칩셋이다. RAM과 CPU가 가까이 붙어있기 때문에 빠른 속도를 낼 수 있는 것이다.
* LLDB 명령어 중 po를 통해 출력하는 문자열을 임의로 지정하려면 debugDescription 프로퍼티를 구현해야 한다.

**[Contents.JSON]**
* Asset 카탈로그에 파일을 넣어줄 때 필요한 정보를 가지고 있으며, 이 파일을 Asset에 넣어주게 되면 자동으로 정보를 인식한다.
* Asset 별로 필요한 Key가 따로 정해져 있었다. 이는 Asset Catalog Format Reference에서 확인할 수 있다.
* Image Set type idiom에서 universal을 선택하게 되면 기기, 플랫폼에 관계없이 전부 이미지를 사용할 수 있다. 

**[Framework]**
* 목적에 따라 효율적으로 구조를 짜놓은 개발 방식
* 애플리케이션의 토대를 뜻한다.
* 사용자가 프레임워크의 규칙을 준수해야한다.

>특징
* 공통적인 개발 환경을 제공한다.
* 개발할 수 있는 범위가 정해져있다.

**[Library]**
* 특정 기능에 대한 도구/함수들을 모아둔 집합.
* 재사용 가능한 코드의 집합을 뜻한다.
* 사용자가 라이브러리를 가져다 쓴다.

>특징
* 개발하는데 필요한 것들을 모아둔 일종의 저장소를 말한다.
* 목적에 맞는 라이브러리를 필요할 때 호출해서 사용한다.

**[API]**
* 다른 프로그램이 제공하는 기능을 제어할 수 있게 만든 인터페이스
* 프로그램과 운영체제를 연결해 주는 다리 역할을 수행한다.

>특징
* 다른 프로그램(운영체제)과 연결해주는 다리 역할을 한다.
* 구현이 아닌 제어를 담당한다.
* API를 조합해 획기적인 프로그램을 만들 수 있다
    * 예시) 버스 시간을 알려주는 프로그램은 공공 API를 이용한 프로그램이다.

**[프레임워크와 라이브러리의 차이점]**
* 프레임워크는 Flow에 대한 제어 권한을 자체적으로 가지고 있다.
* 라이브러리는 Flow에 대한 제어 권한을 사용자가 가지고 있다. 
* 즉 흐름에 대한 제어 권한이 어디에 있느냐의 차이가 있다.
>집짓기에 비유하자면,
>집의 기본 토대를 애플리케이션 개발에서는 프레임워크 라고 하고,
>집 안에 전자제품 중 스마트 TV를 다양한 기능들의 집합체인 라이브러리라고 한다.
>더불어 다양한 기능들을 제어하는 TV 리모콘을 API라고 한다.

**[Foundation은 라이브러리에 대한 설명과도 잘 어울리는 것 같은데?]**
* 프레임워크는 라이브러리보다 더 큰 의미이고 추상적인 개념이다. 따라서 프레임워크는 때에 따라 라이브러리가 될 수도 있다는 생각이 들었다.
&nbsp;
---

- 참고링크
    - https://baobab.live/82
    - 호댕의 12/6일자 TIL
    - https://stackoverflow.com/questions/148747/what-is-the-difference-between-a-framework-and-a-library
    - https://www.youtube.com/watch?v=_j4u4ftWwhQ
    - https://medium.com/@hongseongho/%ED%94%84%EB%A0%88%EC%9E%84%EC%9B%8C%ED%81%AC%EC%99%80-%EB%9D%BC%EC%9D%B4%EB%B8%8C%EB%9F%AC%EB%A6%AC%EC%9D%98-%EC%B0%A8%EC%9D%B4-2f5bf35140ca
