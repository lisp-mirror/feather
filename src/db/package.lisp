(in-package :cl-user)

(defpackage #:feather.db
  (:use #:cl #:alexandria)
  ;; Base
  (:export :key
           :created-at
           :modified-at)

  ;; Username
  (:export :username
           :insert-username-record
           :list-username-records))
