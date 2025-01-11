## [User List] 사용자 목록 조회 (시스템 계정 포함)
SELECT User, Host, plugin, Create_priv as `Create`, Drop_priv as `Drop`, Select_priv as `Select`, Insert_priv as `Insert`, Update_priv as `Update`, Delete_priv as `Delete` 
FROM mysql.user 
ORDER BY User, Host;
