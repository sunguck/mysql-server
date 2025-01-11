## [User Client SSL] 클라이언트 SSL 사용 여부 확인
SELECT t.processlist_user, t.processlist_id, t.connection_type,
  s.ssl_version, s.ssl_cipher, s.ssl_sessions_reused
FROM sys.session_ssl_status s
  INNER JOIN performance_schema.threads t ON t.thread_id=s.thread_id
WHERE s.ssl_version IS NOT NULL
ORDER BY s.ssl_version;
