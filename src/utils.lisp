(in-package #:feather)

(defun executable-directory-pathname ()
  #+sbcl sb-ext:*runtime-pathname*
  #+ccl (uiop:pathname-directory-pathname
         ccl:*heap-image-name*))

(defun secrets-file-pathname () 
  "Pathname of the secrets file."
  (asdf:system-relative-pathname :feather "../config/cfg-feather.lisp"))

(defun assets-directory-pathname () 
  "Pathname of the assets directory."
  (if (in-emacs-p)
      (asdf:system-relative-pathname "feather" "src/assets/")
      (uiop:subpathname (executable-directory-pathname) "assets/")))
  
(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun in-emacs-p ()
    "Currently in emacs."
    #-SWANK nil
    #+SWANK t))
