(in-package #:feather.db)

;; Base class only contains common fields. It should not be used directly
;; because there is no such table.
(defclass base ()
  ((key :col-type SERIAL
        :reader key) 
   (created_at :col-type TIMESTAMP
               :reader created-at)
   (modified_at :col-type TIMESTAMP
                :reader modified-at))
  (:metaclass postmodern:dao-class)
  (:keys key))
