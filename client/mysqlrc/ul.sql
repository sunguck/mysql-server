## [User List] 사용자 목록 조회 (시스템 계정 제외)
SELECT User, Host, plugin, Create_priv as `Create`, Drop_priv as `Drop`, Select_priv as `Select`, Insert_priv as `Insert`, Update_priv as `Update`, Delete_priv as `Delete` 
FROM mysql.user 
WHERE User NOT IN ('AWS_COMPREHEND_ACCESS','AWS_LAMBDA_ACCESS','AWS_LOAD_S3_ACCESS','AWS_SAGEMAKER_ACCESS','AWS_SELECT_S3_ACCESS','mysql.infoschema','mysql.session','mysql.sys','rds_superuser_role','rdsadmin')
ORDER BY User, Host;
