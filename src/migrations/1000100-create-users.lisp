(in-package :migration-user)

(with-timestamped-migration 

  (def-query-migration migration-timestamp
      "create usernames"
    :execute "CREATE TABLE usernames ( 
                 key SERIAL UNIQUE, 
                 username TEXT UNIQUE NOT NULL)"
    :revert "DROP TABLE usernames"))
 
