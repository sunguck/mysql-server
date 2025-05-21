## [Index Progress]  인덱스 생성 진행 상태
SELECT EVENT_NAME, WORK_COMPLETED, WORK_ESTIMATED, (WORK_COMPLETED / WORK_ESTIMATED) * 100 as `Progress %` 
FROM performance_schema.events_stages_current
ORDER BY TIMER_START ASC;
