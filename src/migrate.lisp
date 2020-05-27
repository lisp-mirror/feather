(in-package :cl-user)

(defpackage :feather-migrate
  (:use :common-lisp)
  (:export :upgrade
	   :downgrade))

(in-package :feather-migrate)

(defun set-db-connection ()
  (let* ((sf (asdf:system-relative-pathname
              :feather "../config/feather-migrate.lisp"))
         db-name db-user db-pwd db-host)
    (if (uiop:file-exists-p sf)
        ;; Load secrets from file
        (let ((cfg (modest:load-config sf)))
          (format t "~&Found config file: ~A~%" sf)
          (setf db-user (getf cfg :db-user))
          (setf db-name (getf cfg :db-name))
          (setf db-pwd (getf cfg :db-pwd))
          (setf db-host (getf cfg :db-host)))
        ;; Set dev values
        (progn
          (format t "~&No config file found.~%")
          (setf db-user "feather_dev")
          (setf db-name "feather_dev")
          (setf db-pwd "feather_dev")
          (setf db-host "localhost")))
    ;; Set the global DB connection parameter variable
    (setf migration-user::*db-connection-parameters*
          (list db-name db-user db-pwd db-host :pooled-p t)))) 

(defun upgrade (&optional number)
  "NUMBER is the target to where migrations should be done. NUMBER is
   inclusive. If none is specified all existing migrations will run."
  (set-db-connection)
  (migration-user::upgrade number))

(defun downgrade (number)
  "NUMBER is the target to where migrations should be reverted. NUMBER is
   exclusive, i.e. everything above the specifed NUMBER will be
   removed. Specify 0 to empty the database."
  (set-db-connection)
  (migration-user::downgrade (+ 1 number)))
