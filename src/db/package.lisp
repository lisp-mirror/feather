(in-package :cl-user)

(defpackage #:feather.db
  (:use #:cl #:alexandria)
  ;; Base
  (:export :key
           :created-at
           :modified-at)

  ;; User
  (:export :insert-username-record
           :list-username-records))
