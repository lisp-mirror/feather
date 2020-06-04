(in-package #:feather)

;; ;;;; Pathnames ****************************************************************

(defun executable-directory-pathname ()
  #+sbcl sb-ext:*runtime-pathname*
  #+ccl (uiop:pathname-directory-pathname
         ccl:*heap-image-name*))

(defun secrets-file-pathname () 
  "Pathname of the secrets file."
  (asdf:system-relative-pathname :feather "../config/cfg-sltv-server.lisp"))

;;;; Environment **************************************************************

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun in-emacs-p ()
    "Currently in emacs."
    #-SWANK nil
    #+SWANK t))
