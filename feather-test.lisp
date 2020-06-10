(in-package :cl-user)

;; Configure ASDF to find the project systems
(load "src/prep-quicklisp.lisp")

;; Load the server
(ql:quickload :qlot)
(qlot:quickload :feather/test)

;; Go
(5am:run-all-tests)
(quit)
