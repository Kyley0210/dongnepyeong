# 동네평 — Claude Code 작업 안내

중국 다종뎬핑(大众点评)을 본뜬 한국형 동네 가게 리뷰 앱이에요. 사장님이 가게를 올리고, 손님이 별점과 자유 리뷰를 남겨요.
사용자는 한국어 사용자이고 개발자가 아니에요. **항상 한국어로, 쉬운 말로** 답하고, 전문 용어는 꼭 필요할 때만 짧게 풀어서 쓰세요.

## 꼭 지킬 것
- **무료 요금제(Firebase Spark)만 사용.** Blaze 업그레이드, 결제 수단 등록, Cloud Storage, Cloud Functions는 쓰지 마세요. 사진은 Firestore `photos` 컬렉션에 base64(JPEG 압축, 문서당 1MB 미만)로 저장해요.
- 사용자 비밀번호는 입력하지 마세요. 로그인은 사용자가 직접 해요.
- 실제 사이트에 배포하기 전에 무엇을 바꿨는지 짧게 알려 주세요.

## 구조
- `public/index.html` — 앱 전체(HTML+CSS+JS 한 파일, 번들러 없음). Firebase Web SDK 10.12.2를 gstatic ESM으로 불러와요.
- `public/firebase-config.js` — Firebase 웹 설정(공개돼도 되는 값). 프로젝트 ID: `dongnepyeong`
- `firestore.rules` — 보안 규칙(익명 로그인 불가, 가게 주인만 수정, 주소 중복 등록 방지 `addrKeys`, 리뷰는 가게당 1인 1개 `storeId_uid`, 답글은 가게 주인만, 사진은 본인만).
- `firebase.json`, `.firebaserc`, `firestore.indexes.json` — 배포 설정.
- `deploy.sh` — 배포 스크립트. 실행: `bash deploy.sh`
- `README.md` — 무료 한도와 설정 설명.
- `_to_delete/` — 예전 버전 파일(유료 기능). 쓰지 않음.

## 앱 주요 기능(이미 구현됨)
- 아래 탭: 홈 / 사장님 / 리뷰(+) / 즐겨찾기 / 마이(오른쪽 위 톱니 → 설정)
- 홈: 지역 선택, 주변·트렌드·랭킹 탭, 카테고리 2줄×5개 가로 스와이프(‘전체’ 칸 없음, 클럽 따로 없음), 카테고리마다 세부 업종과 ‘기타’
- 가게 등록: 썸네일 1장 + 가게 사진, 영업시간(클릭으로 몇 시~몇 시), 휴무일 여러 개 선택, 전화번호 앞자리 선택(010, 02…) + 나머지 입력, 상세 주소 안내 문구, 성인 전용 표시, 같은 지역·같은 주소 중복 등록 막기, 삭제 시 경고창
- 가게 페이지: 위에 썸네일, 아래로 가게 사진과 손님 사진을 가로 스크롤, 지도·전화 버튼(택시 없음)
- 언어: 한국어/English/日本語/中文. `T("한국어 문장")` + `I18N` 사전. 저장 데이터는 한국어로 두고 표시할 때만 번역.
- 성인 표시 나이: ko 19+, en/zh 18+, ja 20+
- 리뷰 번역: 무료라서 ‘Google 번역으로 보기’ 링크 방식

## 배포
- 사이트: https://dongnepyeong.web.app
- `bash deploy.sh`(내부적으로 `./.firebase-cli deploy --project dongnepyeong --only firestore,hosting`)
- 처음 배포할 때 규칙 릴리스에서 409 "already exists" 오류가 한 번 났고, 다시 실행하니 성공했어요. 또 나면 한 번 더 실행하세요.

## 처음 할 일(추천)
- 아직 git 기록이 없어요. 처음 열면 `git init` 후 첫 커밋을 만들어 두면 언제든 되돌릴 수 있어요.
