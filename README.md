# HouseKeepingBook

패스트 캠퍼스에서 진행한 팀 해커톤 프로젝트 입니다.

월 단위로 예산을 정하고 사용한 금액에 태그를 달아 관리하고 통계를 계산 할 수 있습니다.



## Description

- 개발 기간: 2020.01.17 (1일)
- 참여 인원: iOS 3명
- 사용 기술
  - Language: Swift
  - FrameWork: UIKit
  - Library: JTAppleCalendar
- 담당 구현 파트
  - 달력
  - 통계



## Implementation

<img src = "https://github.com/JoongChangYang/HouseKeepingBook/assets/housekeepingbook-x4.gif"></img>

- 달력
  - JTAppleCalendar library를 이용하여 달력 구현
  - 이달의 예산 설정 및 남은 예산 표현
  - 하루마다의 그날의 소비량에 따라 달력에 색으로 표시
  - 스크롤로 달력을 넘기는 기능
- 통계
  - 날짜별 소비 통계
    - 날짜 별로 얼마를 썻는지 표현
    - 날짜 별로 소비한 금액이 전체 소비금액의 몇 퍼센트인지 표현
  - 태그별 소비 통계
    - 태그 별로 얼마를 썻는지 표현
    - 태그별로 소비한 금액이 전체 소비금액의 몇 퍼센트 인지 표현 

## Truble Shooting

- 좌 우로 쓸어넘기면서 이전달, 다음달 달력으로 이동하는 스크롤 달력을 만들려고 `UIScrollView` 에 쓸어 넘길때 마다 새로운 달력 뷰를 생성하여 추가 하려고 했으나 `AutoLayout`이 불안정하고 사용자가 쓸어넘긴 만큼의 달력 뷰와 데이터를 메모리에 가지고있어야 하는 문제
  - `UIScrollView` 안에는 3개의 달력 뷰만을 가지고 있고 가운데 있는 달력 뷰에서 다른 뷰로 이동하면 나머지 달력 뷰 들 과 데이터들을 업데이트 하고 다시 중간의 달력뷰로 `contentOffset.x`를 이동시켜 해결 
  - `AutoLayout`을 새로 조작할 필요가 없고 불필요하게 많은 달력을 메모리에 가지고 있을 필요가 없음