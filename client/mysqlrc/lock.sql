## [Lock Transaction List] 잠금 목록 조회
SELECT r.trx_wait_started AS wait_started,
  TIMEDIFF(NOW(), r.trx_wait_started) AS wait_age,
  TIMESTAMPDIFF(SECOND, r.trx_wait_started, NOW()) AS wait_age_secs,
  CONCAT(rl.object_schema, '.', rl.object_name) AS locked_table,
  rl.index_name AS locked_index,
  rl.lock_type AS locked_type,
  r.trx_id AS waiting_trx_id,
  r.trx_started as waiting_trx_started,
  TIMEDIFF(NOW(), r.trx_started) AS waiting_trx_age,
  r.trx_rows_locked AS waiting_trx_rows_locked,
  r.trx_rows_modified AS waiting_trx_rows_modified,
  r.trx_mysql_thread_id AS waiting_pid,
  sys.format_statement(r.trx_query) AS waiting_query,
  rl.engine_lock_id AS waiting_lock_id,
  rl.lock_mode AS waiting_lock_mode,
  b.trx_id AS blocking_trx_id,
  b.trx_mysql_thread_id AS blocking_pid,
  sys.format_statement(b.trx_query) AS blocking_query,
  bl.engine_lock_id AS blocking_lock_id,
  bl.lock_mode AS blocking_lock_mode,
  b.trx_started AS blocking_trx_started,
  TIMEDIFF(NOW(), b.trx_started) AS blocking_trx_age,
  b.trx_rows_locked AS blocking_trx_rows_locked,
  b.trx_rows_modified AS blocking_trx_rows_modified
FROM performance_schema.data_lock_waits w
  INNER JOIN information_schema.innodb_trx b  ON b.trx_id = CAST(w.blocking_engine_transaction_id AS CHAR)
  INNER JOIN information_schema.innodb_trx r  ON r.trx_id = CAST(w.requesting_engine_transaction_id AS CHAR)
  INNER JOIN performance_schema.data_locks bl ON bl.engine_lock_id = w.blocking_engine_lock_id
  INNER JOIN performance_schema.data_locks rl ON rl.engine_lock_id = w.requesting_engine_lock_id
ORDER BY r.trx_wait_started;
