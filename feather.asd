(defpackage #:feather-system
  (:use :cl :asdf :uiop))

(in-package :feather-system)

(defsystem #:feather
  :serial t
  :depends-on (:closer-mop
               :cl-change-case
               :cl-hash-util
               :cl-postgres-plus-uuid
               :cl-pass
               :darts.lib.email-address
               :djula
               :easy-routes
               :hunchentoot
               :local-time
               :modest-config
               :postmodern
               :st-json
               :str
               :uuid)
  :pathname "src"
  :components ((:file "package")
               ;; (:file "conditions")
               (:file "specials")
               (:file "utils")
               (:module "db"
                        :components ((:file "package")
                                     (:file "base")
                                     (:file "usernames")))
               (:module "logic"
                        :components ((:file "package")
                                     (:file "logic")))
               (:module "ui"
                        :components ((:file "ui-common")
                                     (:file "routes")
;;                                     (:file "api")
                                     ))
               (:file "main"))
  :in-order-to ((test-op (test-op :feather/test))))

(defsystem #:feather/migrate
  :serial t
  :depends-on (:database-migrations
               :modest-config)
  :pathname "src"
  :components ((:file "migrate")
               (:module "migrations"
                        :components #.(mapcar
                                       #'(lambda (p)
                                           (list :file (pathname-name p)))
                                       (directory-files (system-relative-pathname
                                                         :feather
                                                         #p"src/migrations/")
                                                        "*.lisp")))))

(defsystem #:feather/test
  :serial t
  :depends-on (:fiveam
               :feather
               :drakma
               :plump)
  :pathname "t"
  :components ((:file "package")
               (:file "suite")
               (:file "main")
               (:module "db"
                        :components ((:file "suite")
                                     (:file "users")
                                     ))
               (:module "logic"
                        :components ((:file "suite")
                                     ))
               (:module "ui"
                        :components ((:file "suite")
                                     (:file "routes")
                                     (:file "api"))))
  :perform (test-op (o c) (symbol-call :fiveam '#:run-all-tests)))
