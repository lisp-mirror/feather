;;;This file should test the stuff in src/main.lisp

(in-package :feather/test)

(in-suite main)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun initialize ()
    ;; Initialise Drakma
    (unless (member '("application" . "json")
                    drakma:*text-content-types* :test #'equal)
      (push (cons "application" "json") drakma:*text-content-types*))
    (unless (member '("application" . "problem+json")
                    drakma:*text-content-types* :test #'equal)
      (push (cons "application" "problem+json") drakma:*text-content-types*)))

  (initialize))
