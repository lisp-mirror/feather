(in-package :feather)

;;; Setup huncentoot
(setq hunchentoot:*dispatch-table*
      (list
       (hunchentoot:create-folder-dispatcher-and-handler "/assets/" (asdf:system-relative-pathname "feather" "src/assets/"))))

;;;; Helpers *******************************************************************

(defmacro check-parameter-non-zero-string (maybe-string)
  "Check if MAYBE-STRING is a string with non-zero length. Signal error if not."
  `(unless (and (stringp ,maybe-string) (not (str:emptyp ,maybe-string)))
     (api-handler-error 'feather::parameter-error
                        hunchentoot:+HTTP-BAD-REQUEST+
                        "~A requires a non-zero length STRING value."
                        ',maybe-string
                        ,maybe-string)))

(defun backtrace-to-hunchentoot-log (error)
  (when hunchentoot:*log-lisp-errors-p*
    (hunchentoot:log-message*
     hunchentoot:*lisp-errors-log-level*
     "~A~@[~%~A~]" error (when hunchentoot:*log-lisp-backtraces-p*
                           (with-output-to-string (s)
                             (trivial-backtrace:print-backtrace-to-stream s))))))

;; Format of RFC7808 error response.
;; {
;;   "type":"MISSING-PARAMETER-ERROR",
;;   "title":"An expected parameter was not supplied.",
;;   "status":404,
;;   "detail":"The parameter was not included."
;; }
;;
;; Type: the error class.
;; Title: the error class' description.
;; Status: the http status code
;; Detail: specific detail about the error when it was triggered.

(defun return-error-rfc7808 (type title status detail)
  "Return an error response following RFC7807 in JSON format.
   https://tools.ietf.org/html/rfc7807"
  (setf (hunchentoot:content-type*) "application/problem+json")
  (setf (hunchentoot:return-code*) status)
  (st-json:write-json-to-string
   (st-json:jso "type" (format nil "~A" type)
                "title" title
                "status" status
                "detail" detail)))

;;;; Decorators ****************************************************************

(defun @errors (next)
  "This decorator should be first in the list of decorators. It encapsulates
   everything with an error handler so the route handler can focus on the happy
   case. Foreseen errors should be caught and translated into an
   API-HANDLER-ERROR so that the HTTP status can be specified. Any other errors
   not so translated will be returned as a generic 500 error."
  (handler-case
      (funcall next)
    (api-handler-error (c)
      (when (>= (api-error-status c) 500)
        (backtrace-to-hunchentoot-log c))
      (return-error-rfc7808 (api-error-type c) (api-error-title c)
                            (api-error-status c) (api-error-detail c)))
    (error (c)
      (backtrace-to-hunchentoot-log c)
      (return-error-rfc7808 (type-of c)
                            (if-let (title (documentation (type-of c) 'type))
                              title "Untitled")
                            hunchentoot:+HTTP-INTERNAL-SERVER-ERROR+
                            (format nil "~A" c)))))

(defun @db (next)
  "Open a new connection to the DB for the duration of the request handler."
  (postmodern:with-connection feather:*db-spec*
    (cl-postgres-plus-uuid:set-uuid-sql-reader)
    (funcall next)))
