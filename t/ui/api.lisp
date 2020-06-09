(in-package #:feather/test)

(def-suite api :in ui)

(in-suite api)

(def-test username-create-one ()
  "Return created username."
  (let* ((username (random-username))
         response)
    (with-fixture with-running-server ()
      (with-fixture drakma-request ((format nil "~A~A" +TEST-HOST+
                                            "/api/usernames")
                                    :method :post
                                    :parameters
                                    `(("username" . ,username)))
        (is (= 200 *status-code*))
        ;; Response is JSON
        (is (string= "/api/usernames" (puri:uri-path *response-uri*)))
        (is (string= "application/json"
                     (drakma:header-value :content-type *headers*)))
        (finishes (setf response (st-json:read-json-from-string *http-body*)))
        ;; Expected keys
        (multiple-value-bind (value found) (st-json:getjso "key" response)
          (is-true found)
          (is (/= 0 value)))
        (multiple-value-bind (value found) (st-json:getjso "username" response)
          (is-true found)
          (is (string-equal username value)))))))

(def-test username-create-duplicate ()
  "Return error for duplicate entry."
  (let* ((username (random-username))
         response)
    (with-fixture with-running-server ()
      (with-fixture drakma-request ((format nil "~A~A" +TEST-HOST+
                                            "/api/usernames")
                                    :method :post
                                    :parameters
                                    `(("username" . ,username)))
        (is (= 200 *status-code*)))
      (with-fixture drakma-request ((format nil "~A~A" +TEST-HOST+
                                            "/api/usernames")
                                    :method :post
                                    :parameters
                                    `(("username" . ,username)))
        (is (= 400 *status-code*))
        ;; Response is JSON
        (is (string= "/api/usernames" (puri:uri-path *response-uri*)))
        (is (string= "application/problem+json"
                     (drakma:header-value :content-type *headers*)))
        (finishes (setf response (st-json:read-json-from-string *http-body*)))
        ;; Expected keys
        (multiple-value-bind (value found) (st-json:getjso "type" response)
          (declare (ignore value))
          (is-true found))
        (multiple-value-bind (value found) (st-json:getjso "title" response)
          (declare (ignore value))
          (is-true found))
        (multiple-value-bind (value found) (st-json:getjso "status" response)
          (declare (ignore value))
          (is-true found))
        (multiple-value-bind (value found) (st-json:getjso "detail" response)
          (declare (ignore value))
          (is-true found))))))
