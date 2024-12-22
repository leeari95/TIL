# 241220 MPNowPlayingInfoCenter, MPRemoteCommandCenter

알림센터에 앱에서 재생중인 오디오 정보를 띄워보자~

12월 20일 (금)


# 학습내용


- MPNowPlayingInfoCenter를 어떻게 활용하는거지?
- MPRemoteCommandCenter에는 어떤 기능들이 있지?
- 재생시간 없이 '실시간'으로 표기하려면 어떻게 해야하지?
- 이미지를 네트워크로 다운받아서 표시하려면 어떻게 해야하지?


# 고민한 점 / 해결방법

## MPNowPlayingInfoCenter

* 앱이 재생하는 미디어의 정보를 설정하기 위한 객체.
* `nowPlayingInfo`라는 프로퍼티에 dictionary를 활용하여 아래와 같은 정보를 설정할 수 있다.

|**키 값**|**설명**|
|---|---|
|`MPMediaItemPropertyAlbumTitle`|앨범의 제목|
|`MPMediaItemPropertyAlbumTrackCount`|앨범에 포함된 총 트랙 수|
|`MPMediaItemPropertyAlbumTrackNumber`|현재 트랙의 번호|
|`MPMediaItemPropertyArtist`|아티스트의 이름|
|`MPMediaItemPropertyArtwork`|앨범 아트워크 이미지. `MPMediaItemArtwork` 객체를 사용하여 설정한다.|
|`MPMediaItemPropertyComposer`|작곡가의 이름|
|`MPMediaItemPropertyDiscCount`|앨범의 총 디스크 수|
|`MPMediaItemPropertyDiscNumber`|현재 디스크의 번호|
|`MPMediaItemPropertyGenre`|장르|
|`MPMediaItemPropertyPlaybackDuration`|재생 시간(초 단위)|
|`MPMediaItemPropertyTitle`|트랙의 제목|
|`MPNowPlayingInfoPropertyElapsedPlaybackTime`|현재 재생된 시간(초 단위)|
|`MPNowPlayingInfoPropertyPlaybackRate`|재생 속도. 일반적으로 1.0은 정상 재생, 0.0은 일시 정지를 의미한다.|
|`MPNowPlayingInfoPropertyDefaultPlaybackRate`|기본 재생 속도|
|`MPNowPlayingInfoPropertyPlaybackQueueIndex`|현재 재생 중인 항목의 재생 목록 인덱스|
|`MPNowPlayingInfoPropertyPlaybackQueueCount`|재생 목록의 총 항목 수|
|`MPNowPlayingInfoPropertyChapterNumber`|현재 재생 중인 챕터 번호|
|`MPNowPlayingInfoPropertyChapterCount`|총 챕터 수|
|`MPNowPlayingInfoPropertyIsLiveStream`|현재 재생 중인 항목이 라이브 스트림인지 여부 (`true` 또는 `false`)|
|`MPNowPlayingInfoPropertyMediaType`|현재 재생 중인 미디어의 유형. `MPNowPlayingInfoMediaType` 값을 사용.|

```swift
import MediaPlayer

func updateNowPlayingInfo(title: String, artist: String, albumTitle: String, duration: TimeInterval, currentTime: TimeInterval, artworkImage: UIImage?) {
    var nowPlayingInfo: [String: Any] = [
        MPMediaItemPropertyTitle: title,
        MPMediaItemPropertyArtist: artist,
        MPMediaItemPropertyAlbumTitle: albumTitle,
        MPMediaItemPropertyPlaybackDuration: duration,
        MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime,
        MPNowPlayingInfoPropertyPlaybackRate: 1.0 // 1.0은 재생 중, 0.0은 일시 정지 상태를 나타냄
    ]

    // 앨범 아트워크가 있을 경우 설정
    if let artworkImage {
        let artwork = MPMediaItemArtwork(boundsSize: artworkImage.size) { size in
            return artworkImage
        }
        nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
    }

    // MPNowPlayingInfoCenter에 정보 설정
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
}
```

## 이미지를 비동기로 받아 설정하는 방법

Kingfisher 라이브러리를 활용해서 이미지를 비동기로 다운로드 받아서 처리하는 방법이 있다.

이렇게 비동기로 이미지를 다운로드 받는 경우에는, nowPlayingInfo 설정 또한 맨 마지막에 비동기로 설정하게 된다.

```swift
import MediaPlayer
import Kingfisher

func fetchArtwork(from url: URL) async -> MPMediaItemArtwork? {
    do {
        let result = try await KingfisherManager.shared.retrieveImage(with: url)
        let artwork = MPMediaItemArtwork(boundsSize: result.image.size) { _ in
            return result.image
        }
        return artwork
    } catch {
        print("이미지 다운로드 실패: \(error)")
        return nil
    }
}
```

## MPRemoteCommandCenter

* 외부 액세서리 및 시스템 컨트롤이 전송하는 원격 제어 이벤트에 응답하는 객체.
* 이 객체로 '재생', '일시정지' 버튼의 이벤트를 받아 앱 내에서 작업을 처리할 수 있다.

```swift
private func setupRemoteCommandHandlers() {
    // 재생 버튼 처리
    commandCenter.playCommand.addTarget { [weak self] event in
        guard let self = self else { return .commandFailed }

        if !self.isPlaying {
            self.play()
            return .success
        }
        return .commandFailed
    }

    // 일시정지 버튼 처리
    commandCenter.pauseCommand.addTarget { [weak self] event in
        guard let self = self else { return .commandFailed }

        if self.isPlaying {
            self.pause()
            return .success
        }
        return .commandFailed
    }
}
```

> 이 외에도 다양한 명령들이 존재한다.

|**Command**|**설명**|
|---|---|
|`playCommand`|재생 버튼이 눌렸을 때|
|`pauseCommand`|일시 정지 버튼이 눌렸을 때|
|`stopCommand`|정지 버튼이 눌렸을 때|
|`togglePlayPauseCommand`|재생/일시 정지 토글 버튼이 눌렸을 때|
|`nextTrackCommand`|다음 트랙 버튼이 눌렸을 때|
|`previousTrackCommand`|이전 트랙 버튼이 눌렸을 때|
|`seekForwardCommand`|앞으로 탐색 버튼이 눌렸을 때|
|`seekBackwardCommand`|뒤로 탐색 버튼이 눌렸을 때|
|`skipForwardCommand`|정해진 시간만큼 앞으로 건너뜀|
|`skipBackwardCommand`|정해진 시간만큼 뒤로 건너뜀|
|`changePlaybackRateCommand`|재생 속도 변경|
|`changeRepeatModeCommand`|반복 모드 변경|
|`changeShuffleModeCommand`|셔플 모드 변경|
|`rateCommand`|미디어 평가(별점 등)|
|`likeCommand`|좋아요 버튼|
|`dislikeCommand`|싫어요 버튼|
|`bookmarkCommand`|북마크 추가 버튼|

## 재생이 모두 끝났을 때 알림 받는 방법

아래처럼 NotificationCenter를 활용해서 AVPlayerItemDidPlayToEndTime을 구독하면 된다!

```swift
NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                       object: item,
                                       queue: .main,
                                       using: { _ in
    // 여기서 앱 내에서 재생중인 AVPlayer의 재생을 멈추도록 구현해보자.
})
```


---


# 참고 링크


- [https://developer.apple.com/documentation/mediaplayer/mpnowplayinginfocenter](https://developer.apple.com/documentation/mediaplayer/mpnowplayinginfocenter)
- [https://developer.apple.com/documentation/mediaplayer/mpremotecommandcenter](https://developer.apple.com/documentation/mediaplayer/mpremotecommandcenter)
- [https://developer.apple.com/documentation/avfoundation/avplayeritem/didplaytoendtimenotification](https://developer.apple.com/documentation/avfoundation/avplayeritem/didplaytoendtimenotification)
