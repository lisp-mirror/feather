(in-package #:feather/test)

(def-suite db.usernames :in db)

(in-suite db.usernames)

;;;; Fixtures ******************************************************************

(def-fixture connected-db ()
  "Open and close DB connection."
  (postmodern:with-connection
      (list feather::*db-name* feather::*db-user* feather::*db-pwd*
            feather::*db-host* :pooled-p nil)
    (&body)))

;;;; Helpers *******************************************************************

(defun random-username ()
  (format nil "test-user-~A"
          (local-time:format-timestring
           nil (local-time:Now)
           :format '(:year :month :day "-" :hour :min :sec :usec))))

;;;; insert-username-record ****************************************************

(def-test insert-username-record ()  
  "Insertion works and initialised data is correct."
  (with-fixture connected-db ()
    (let* ((username (random-username))
           (dao (feather.db::insert-username-record username))
           (actual (postmodern:get-dao 'feather.db:username
                                       (feather.db:key dao))))
      (is (string-equal username (feather.db:username actual))))))

