(in-package #:feather/test)

(def-suite main)

;;;; Fixtures ******************************************************************
    
(def-fixture drakma-request (&rest args)
  "Make an HTTP request and bind return values to variables."
  (multiple-value-bind (*http-body* *status-code* *headers* *response-uri*
                                    *stream* *close-stream-p* *reason*)
      (apply #'drakma:http-request args)
    (declare (ignorable *http-body* *status-code* *headers* *response-uri*
                        *stream* *close-stream-p* *reason*))
    (&body)))

