(in-package #:feather)

(define-condition api-handler-error (error)
  ((type :initarg :type
         :reader api-error-type
         :documentation "The error type.")
   (title :initarg :title
          :reader api-error-title
          :documentation "Fixed description or error type.")
   (status :initarg :status
           :reader api-error-status
           :documentation "HTTP status to return.")
   (detail :initarg :detail
           :reader api-error-detail
           :documentation "Description of this error instance."))
  (:report (lambda (condition stream)
             (format stream "Error ~A: (~A) ~A~%~A"
                     (api-error-status condition)
                     (api-error-type condition)
                     (api-error-title condition)
                     (api-error-detail condition))))
  (:documentation "An error occured during execution of an API handler."))

(defun api-handler-error (type http-status format-control &rest format-arguments)
  "Signal an error that should return a specific HTTP error status with the error description object."
  (error 'api-handler-error
         :type type
         :title (if-let (title (documentation type 'type)) title "Undefined")
         :status http-status
         :detail (apply #'format nil format-control format-arguments)))
