## [Transaction Query History] 트랜잭션에서 실행했던 쿼리 이력 조회 - ( ${THRESHOLD_SECONDS} ) 
-- // Long transaction thread에서 실행했던 쿼리 이력 조회 (동일 트랜잭션의 쿼리만 표시됨)
WITH ps_init AS (/*!99999 ~~PS~CAPTURE~TIMER~INIT~~ (UNIQUE_NAME) */
     SELECT NOW() as dttm, UNIX_TIMESTAMP(NOW()) as dttm_ts, TIMER_START as ps_timer
     FROM performance_schema.events_statements_current ps_esc
     WHERE ps_esc.thread_id=PS_CURRENT_THREAD_ID()
       AND ps_esc.SQL_TEXT LIKE '%~~PS~CAPTURE~TIMER~INIT~~%')
SELECT
  ps_thd.PROCESSLIST_ID,
  ps_esh.THREAD_ID,
  CONCAT(ps_thd.PROCESSLIST_USER,'@',ps_thd.PROCESSLIST_HOST) AS DB_ACCOUNT,
  ps_esh.EVENT_ID,
  ps_esh.EVENT_NAME,
  ps_esh.SQL_TEXT,
  (CASE WHEN ps_esh.TIMER_WAIT IS NULL THEN NULL
    WHEN ps_esh.TIMER_WAIT >= 604800000000000000 THEN CONCAT(ROUND(ps_esh.TIMER_WAIT / 604800000000000000, 2), ' w')
    WHEN ps_esh.TIMER_WAIT >= 86400000000000000  THEN CONCAT(ROUND(ps_esh.TIMER_WAIT / 86400000000000000, 2), ' d')
    WHEN ps_esh.TIMER_WAIT >= 3600000000000000   THEN CONCAT(ROUND(ps_esh.TIMER_WAIT / 3600000000000000, 2), ' h')
    WHEN ps_esh.TIMER_WAIT >= 60000000000000     THEN CONCAT(ROUND(ps_esh.TIMER_WAIT / 60000000000000, 2), ' m')
    WHEN ps_esh.TIMER_WAIT >= 1000000000000      THEN CONCAT(ROUND(ps_esh.TIMER_WAIT / 1000000000000, 2), ' s')
    WHEN ps_esh.TIMER_WAIT >= 1000000000         THEN CONCAT(ROUND(ps_esh.TIMER_WAIT / 1000000000, 2), ' ms')
    WHEN ps_esh.TIMER_WAIT >= 1000000            THEN CONCAT(ROUND(ps_esh.TIMER_WAIT / 1000000, 2), ' us')
    WHEN ps_esh.TIMER_WAIT >= 1000               THEN CONCAT(ROUND(ps_esh.TIMER_WAIT / 1000, 2), ' ns')
    ELSE CONCAT(ps_esh.TIMER_WAIT, ' ps') END) as DURATION,
  DATE_SUB(ps_init.dttm, INTERVAL ((ps_init.ps_timer - ps_esh.TIMER_START)/1000000000000.0) SECOND) as START_TIME,
  DATE_SUB(ps_init.dttm, INTERVAL ((ps_init.ps_timer - ps_esh.TIMER_END  )/1000000000000.0) SECOND) as END_TIME,
  trx.trx_started
FROM information_schema.innodb_trx trx
  INNER JOIN performance_schema.threads ps_thd ON ps_thd.processlist_id=trx.trx_mysql_thread_id
  INNER JOIN performance_schema.events_statements_history ps_esh ON ps_esh.thread_id = ps_thd.thread_id
  INNER JOIN ps_init ON TRUE
WHERE trx.trx_started<=DATE_SUB(NOW(), INTERVAL ${THRESHOLD_SECONDS} SECOND)
  AND DATE_SUB(ps_init.dttm, INTERVAL ((ps_init.ps_timer - ps_esh.TIMER_START)/1000000000000.0) SECOND) >= trx.trx_started
ORDER BY ps_esh.timer_end ASC;
