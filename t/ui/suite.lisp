(in-package #:feather/test)

(def-suite ui :in main)

(in-suite ui)

(defparameter +TEST-HOST+ "http://localhost:8080")

(def-fixture with-running-server (&optional (debug-logs-p nil)
                                            (user-dribble-p nil))
  "Start the web server, run the code and stop it again"
  (feather:start :debug-logs-p debug-logs-p :user-dribble-p user-dribble-p)
  (unwind-protect (&body)
    (feather:stop :user-dribble-p user-dribble-p)))
