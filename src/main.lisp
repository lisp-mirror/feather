(in-package :feather)

;;; Application configuration
(defun initialise ()  
  ;; Load secrets from file
  (if-let (sf (uiop:file-exists-p (secrets-file-pathname)))
    (let ((cfg (modest:load-config sf)))
      (format t "~&Found config file: ~A~%" sf)
      (setf *db-user* (getf cfg :db-user))
      (setf *db-name* (getf cfg :db-name))
      (setf *db-pwd* (getf cfg :db-pwd))
      (setf *db-host* (getf cfg :db-host))
      )
    (unless (in-emacs-p)
      (format t "~&No config file found.~%")))

  ;; Set the global DB connection parameter variable
  (setf *db-spec* (list *db-name* *db-user* *db-pwd* *db-host* :pooled-p t))

  ;; Configure Huncentoot. Set assets location.
  (setq hunchentoot:*dispatch-table*
        (list (hunchentoot:create-folder-dispatcher-and-handler
               "/assets/" (assets-directory-pathname))))
  
  ;; Configure Hunchentoot. Don't show errors to users.
  (setf hunchentoot:*show-lisp-errors-p* nil)
  (setf hunchentoot:*show-lisp-backtraces-p* nil)

  (unless (in-emacs-p)
    (format t "~&~A~%" (executable-directory-pathname))))

(defun finalise ()
  ;; Finalisation code
  )

;;; Hunchentoot control
(defvar *acceptor* nil)

(defun start-http-server (&key (debug-logs-p nil) (user-dribble-p t))
  "Start the HTTP server in a new thread. This function is non-blocking. Use 
   this function to start the server during development."
  (when *acceptor*
    (when user-dribble-p (format t "Web server is already running.~%"))
    (return-from start-http-server))
  (when user-dribble-p (format t "Starting web server.
Point your browser to http://localhost:8080~%"))
  (setf *acceptor* (make-instance
                    'easy-routes:easy-routes-acceptor
                    :address "localhost"
                    :port 8080
                    :access-log-destination (if debug-logs-p
                                                *ERROR-OUTPUT*
                                                nil)))
  (hunchentoot:start *acceptor*))

(defun stop-http-server(&key (user-dribble-p t))
  "Stop the HTTP server. Use this function to stop the server during
   development."
  (when user-dribble-p (format t "Stopping web server.~%"))
  (when *acceptor*
    (hunchentoot:stop *acceptor*))
  (setf *acceptor* nil))

(defun start (&key (debug-logs-p nil) (user-dribble-p t))
  (initialise)
  (start-http-server :debug-logs-p debug-logs-p :user-dribble-p user-dribble-p))

(defun stop (&key (user-dribble-p t))
  (stop-http-server :user-dribble-p user-dribble-p)
  (finalise)) 

;;; OS specific signal handling 
#+ccl
(progn
  (define-condition interactive-interrupt
      (serious-condition) ()
    (:documentation "Signal that Ctl-C was caught"))

  (defun ccl-break-hook (cond hook)                              
    "SIGINT handler on CCL."
    (declare (ignorable cond hook))
    (signal 'interactive-interrupt)))

#+ccl
(defun install-signal-handlers ()
  "Set up CCL to call the hook function when Ctrl-C is pressed."
  (setf ccl:*break-hook* #'ccl-break-hook))
  
#+sbcl
(defun install-signal-handlers ()
  "Nothing to do. Only for uniform API.")

;;; Command line execution. 
(defun exit-cleanly ()
  "Exit on SIGINT (Ctrl-C). Don't land in the 
   debugger."
  (stop)
  (uiop:quit 0))

(defun exit-with-backtrace (c)
  "Print the backtrace and exit. Don't land in the debugger."
  (stop)
  (uiop:print-condition-backtrace c :count 15)
  (uiop:quit 1))

(defun handle-conditions (c)
  "On Ctrl-C, exit. Otherwise print backtrace then exit."
  (typecase c
    #+sbcl
    (sb-sys:interactive-interrupt (exit-cleanly))
    #+ccl
    (interactive-interrupt (exit-cleanly))
    (t (exit-with-backtrace c))))

(defun main (argv)
  "Entry point for command-line execution. LOOP keeps the main thread running
   to prevent Lisp from exiting."
  (declare (ignore argv))
  (handler-bind
      ((serious-condition #'handle-conditions))
    (install-signal-handlers)
    (start :debug-logs-p t :user-dribble-p t)
    (format t "Ctrl-C to exit.~%")
    ;;(error "Uncomment to see startup error.")
    (loop (sleep 1))))
