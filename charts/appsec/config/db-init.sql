ALTER DATABASE {{ .Values.db.database }} SET READ_COMMITTED_SNAPSHOT ON
ALTER DATABASE {{ .Values.db.database }} SET ALLOW_SNAPSHOT_ISOLATION ON