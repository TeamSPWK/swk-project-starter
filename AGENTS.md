# swk-project-starter 유지보수 원칙

이 저장소는 생성될 프로젝트가 아니라 템플릿 자체다. 구조와 실제 동작의 정본은 [README.md](README.md), [setup.sh](setup.sh), [CI](.github/workflows/), [hooks](.claude/hooks/)다.

- `setup.sh`는 템플릿 작업트리에서 실행하지 않는다. remote와 템플릿 자산을 교체·삭제하므로 생성된 프로젝트나 폐기 가능한 복사본에서만 실행한다.
- 스캐폴딩할 때 템플릿 소유 파일을 보존하고, upstream이 생성한 에이전트 문서는 마커를 경계로 병합한다. 한쪽을 다른 쪽으로 덮어쓰지 않는다.
- 템플릿 MIT 라이선스 제거 설명과 `setup.sh`의 식별 가드를 하나의 불변조건으로 유지한다. 둘 중 하나를 바꾸면 둘을 함께 갱신하고, 생성된 복사본에서 `setup.sh`를 실제 실행해 `LICENSE` 제거를 확인한다.
