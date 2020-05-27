(in-package :migration-user)

;; This macro extracts the migration timestamp from the filename and makes
;; it available for use in def-query-migration.
;; Filename format: INTEGER-some-text-description.lisp
;; The INTEGER value should be used as the migration timestamp.

(defmacro with-timestamped-migration (&body body) 
  `(multiple-value-bind (file-timestamp desc-start)
       (split-sequence:split-sequence #\- (pathname-name *load-truename*)
                                      :count 1)
     (let* ((migration-timestamp (parse-integer (car file-timestamp)))
            (desc (subseq (pathname-name *load-truename*) desc-start)))
       (declare (ignorable migration-timestamp desc))
       ,@body)))
