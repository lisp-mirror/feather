(in-package #:feather.db)

(defclass username (base)
  ((username :col-type TEXT
             :initarg :username
             :accessor username))
  (:metaclass postmodern:dao-class)
  (:table-name usernames))

(defun insert-username-record (username)
  "Insert a single record. Unique check is done by the DB. Other safety checks
   can be done here before trying the insert."
  (postmodern:insert-dao
   (make-instance 'username
                  :username username)))

(defun list-username-records ()
  "List the 5 newest username records."
  (postmodern:query-dao
   'feather.db::username
   (:limit
    (:order-by
     (:select '* :from 'usernames)
     (:desc 'key))
    5)))
