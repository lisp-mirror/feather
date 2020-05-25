; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10; indent-tabs-mode: nil -*-

(in-package :cl-user)

;;; On Windows the ASDF cache dir must be set to C:/lisp/cache/ because the
;;; default is too long. It prevents some libaries from compiling.

(let* ((output-dir (asdf:apply-output-translations 
                    (asdf:system-source-directory
                     (asdf:find-system :sltv-server))))
       (cache-dir (if (find :linux *features*)
                      (uiop:subpathname (user-homedir-pathname) 
                                        ".cache/common-lisp/")
                      #P"c:/lisp/cache/")))
  ;; Clean ASDF fasl dir
  (uiop:delete-directory-tree output-dir
                              :validate #'(lambda (dir)
                                            (uiop:subpathp dir cache-dir))
                              :if-does-not-exist :ignore))


