## [Transaction List] 트랜잭션 목록 조회 - ARGS( ${THRESHOLD_SECONDS} )
SELECT tx.trx_state, tx.trx_mysql_thread_id,
  (unix_timestamp(now()) - unix_timestamp(tx.trx_started)) as elapsed,
  IFNULL(th.processlist_command,'Unknown') as command,
  IFNULL(th.processlist_info, tx.trx_query) as last_query_of_trx,
  th.PROCESSLIST_ID, th.PROCESSLIST_USER, th.PROCESSLIST_HOST
FROM information_schema.innodb_trx tx
  LEFT JOIN performance_schema.threads th ON th.processlist_id=tx.trx_mysql_thread_id
WHERE tx.trx_state IN ('RUNNING', 'LOCK WAIT', 'ROLLING BACK', 'COMMITTING')
  AND (unix_timestamp(now()) - unix_timestamp(tx.trx_started))>=${THRESHOLD_SECONDS}
ORDER BY tx.trx_started ASC;
