## [Cluster server List] Aurora MySQL Cluster의 서버 목록 (상세 정보)
SELECT *
FROM INFORMATION_SCHEMA.REPLICA_HOST_STATUS
ORDER BY SERVER_ID \G
