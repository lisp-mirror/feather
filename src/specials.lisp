(in-package :feather)

;; Global variables ************************************************************

(defvar *db-spec*)

;; Secrets *********************************************************************

;; These are dev values. Production values are loaded from a file at startup if
;; it exists

(defvar *db-name* "feather_dev")
(defvar *db-user* "feather_dev")
(defvar *db-pwd* "feather_dev")
(defvar *db-host* "localhost")
