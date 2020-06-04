(in-package :feather)

;; Global variables ************************************************************

(defvar *db-spec*)

;; Secrets *********************************************************************

;; These are dev values. Production values are loaded from a file at startup if
;; it exists

(defvar *db-name* "sltv")
(defvar *db-user* "sltv_server_dev")
(defvar *db-pwd* "(Tes3!rd")
(defvar *db-host* "localhost")
