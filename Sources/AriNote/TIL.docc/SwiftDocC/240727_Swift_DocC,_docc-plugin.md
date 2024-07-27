# 240727 Swift DocC, docc-plugin

Swift DocC를 활용해서 TIL을 웹페이지로 변환해보자!

7월 27일 (토)

# 학습내용

- 커맨드로 동작하는 프로젝트 생성 방법
- 문서 카탈로그 생성 방법
- docc-plugin 사용하기

# 고민한 점 / 해결방법

#

## 커맨드로 동작하는 프로젝트를 만드려면?

> swift로 스크립트를 짜서 커맨드로 실행해주고 싶어서 한번 찾아보았던 방법이다.

다음과 같은 명령어로 패키지를 생성해주면 된다.

```
swift package init --type executable --name {패키지 이름}
```

* 패키지를 생성하는데, executable 타입은 실행 가능한 프로그램을 의미한다.


해당 타입으로 생성하게 되면, 다음과 같은 구조로 파일이 생성된다.

```
├── Package.swift
├── Sources
│   └── {패키지 이름}
└──     └── main.swift
```

![](https://github.com/user-attachments/assets/5c93c8ee-b1f6-474d-8fc7-9123a25a1102)

#

## 문서 카탈로그 생성하기

> Documentation: Swift DocC는 Swift 컴파일러와 Objective-C 컴파일러의 공개 API 정보를 문서 카탈로그의 콘텐츠와 결합하여 훨씬 더 풍부한 DocC 아카이브를 생성한다.
> 쉽게 말하면, DocC는 개발자들이 만든 코드를 설명하는 주석과 코드 자체의 정보를 결합하여, 더 이해하기 쉬운 문서를 만든다. 

1. Xcode 프로그램을 열고, 왼쪽에 있는 Project navigator에서 작업하고 있는 프로젝트나 패키지를 클릭한다.

2. `File` > `New` > `File from Template`을 선택하여 file template chooser를 열어준다. (CMD + N)
![](https://github.com/user-attachments/assets/9bf45a2c-8fd9-4fbb-8be0-fff0c2a5f6c3)


3. 템플릿 중에 `Documentation` 섹션으로 가서 `Documentation Catalog`라는 템플릿을 선택하고, `Next` 버튼을 클릭한다.
![](https://github.com/user-attachments/assets/4430f431-57be-44e2-9e73-95a244afb434)

4. `Next` 버튼을 클릭하면 `Documentation`이 생성된다.
![](https://github.com/user-attachments/assets/268b55b3-22ae-409d-94f9-aeb607f6d602)

#

## docc-plugin

Swift-DocC 플러그인은 SwiftPM 라이브러리 및 실행 파일에 대한 문서 작성을 지원하는 Swift 패키지 관리자 명령 플러그인이다.

docc-plugin을 사용하면, 작성한 Documentation을 손쉽게 웹페이지로 빌드할 수 있고, preview도 확인해볼 수 있다.

사용하려면 아래와 같이 종속성을 추가해주면 된다.

```swift
let package = Package(
    // name, platforms, products, etc.
    dependencies: [
        // other dependencies
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0"),
    ],
    targets: [
        // targets
    ]
)
```

> 플러그인을 실행하려면 Swift 5.6 이상이 필요하다.

이후 Github Pages 배포를 위해 다음과 같은 커맨드를 사용하였다.

```
$ swift package --allow-writing-to-directory {저장위치} \
    generate-documentation --target {타겟이름} \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path {레포지토리-이름} \ 
    --output-path {저장위치}
```
|Value|Example|
|:---|:---|
|저장위치|`./docs`|
|타겟이름|`AriNote`|
|레포지토리-이름|`TIL`|

|Command|Description|
|:---|:---|
|`--allow-writing-to-directory`|SPM이 지정된 디렉토리에 쓰기 권한을 허용하도록 한다.|
|`generate-documentation`|Swift 패키지에 대한 문서를 생성한다.|
|`--disable-indexing`|문서 생성 시 인덱싱을 비활성화한다. 인덱싱은 문서 검색 기능을 지원하지만, 여기서는 이를 비활성화하여 문서 생성 속도를 높일 수 있다.|
|`--transform-for-static-hosting`|생성된 문서를 정적 웹 호스팅을 위해 변환한다. 웹 서버에 올려서 정적 사이트로 문서를 제공할 수 있게 한다.|
|`--hosting-base-path`|정적 호스팅을 위한 기본 경로를 설정한다. 생성된 문서의 URL 경로에 TIL을 추가하여 기본 경로로 설정한다. Github Pages로 웹 배포 시 `username.github.io/repository-name`와 같은 형식으로 배포되기 때문에 레포지토리 이름을 넣어준다.|
|`--output-path`|생성된 문서를 저장할 디렉토리를 지정한다.|




# Trouble shooting

## Swift Package 내에서 라이브러리로 지정한 타겟을 인식하지 못하는 문제

### 원인

패키지 생성한 후 불필요하게 있는 .swift 파일을 제거해주었는데, 해당 타겟을 인식하지 못해서 Xcode에 다음과 같은 에러가 발생했다.

```
public headers ("include") directory path for 'AriNote' is invalid or not contained in the target
```

### 이유

타겟 내에 swift 파일이 없으면 빈 타겟으로 인식하기 때문에 나타나는 현상이라고 한다. 타겟 내에 최소 하나의 swift 파일이 존재해야한다.

### 해결

아래와 같이 빈 swift 파일을 추가해주니 경고가 해결되었다.

![](https://github.com/user-attachments/assets/f815a505-246b-47d3-8b9c-fa39cbe205d6)




---

# 참고 링크

- https://developer.apple.com/documentation/Xcode/documenting-apps-frameworks-and-packages
- https://swiftlang.github.io/swift-docc-plugin/documentation/swiftdoccplugin/
- https://github.com/x-0o0/package-docc-example