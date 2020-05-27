(in-package :migration-user)

(with-timestamped-migration 

  (def-query-migration migration-timestamp
      "create usernames"
    :execute "CREATE TABLE usernames ( 
                 key SERIAL UNIQUE, 
                 created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT current_timestamp,
                 modified_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT current_timestamp,
                 username TEXT UNIQUE NOT NULL)"
    :revert "DROP TABLE usernames"))
 
