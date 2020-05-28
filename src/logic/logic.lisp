(in-package #:feather.logic)

;;;; Users *********************************************************************

(defun create-username (username)
  "Create a username. Return a hash table."
  (let* ((rec (feather.db:insert-username-record username)))
    (hu:hash-create `(("key" ,(feather.db:key rec))
                      ("username" ,(feather.db:username rec))))))

(defun list-usernames ()
  "List all the last 5 usernames. Return array of hash tables."
  (mapcar #'(lambda (un)
              (hu:hash-create `(("key" ,(feather.db:key un))
                                ("username" ,(feather.db:username un)))))
          (feather.db:list-username-records)))
