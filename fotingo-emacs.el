;;; fotingo-emacs.el --- An Emacs wrapper for fotingo  -*- lexical-binding: t; coding: utf-8 -*-

;; Author: Mackenzie Bligh <mackenziebligh@gmail.com>

;; Keywords: git tools vc jira
;; Homepage: TODO
;; Version: 0.0.1

;; fotingo-emacs requires at least GNU Emacs 25.1 and fotingo TODO

;; fotingo-emacs is free software; you can redistribute it and/or modify it
;; under the terms of the gnu general public license as published by
;; the free software foundation; either version 3, or (at your option)
;; any later version.
;;
;; fotingo-emacs is distributed in the hope that it will be useful, but without
;; any warranty; without even the implied warranty of merchantability
;; or fitness for a particular purpose.  see the gnu general public
;; license for more details.
;;
;; you should have received a copy of the gnu general public license
;; along with magit.  if not, see http://www.gnu.org/licenses.

;;; Commentary:
;; TODO

;;; Code:
(require 'transient)

;; Menus
;;;###autoload (autoload 'fotingo-dispatch "fotingo-emacs.el" nil t)
(define-transient-command fotingo-dispatch()
  "Invoke a fotingo command from a list of available commands"
  ["Commands"
   ("s" "Start" fotingo-start-dispatch)
   ("r" "Review" fotingo-review-dispatch)
   ("R" "Release" fotingo-release-dispatch)])

;;;###autoload (autoload 'fotingo-start-dispatch "fotingo-emacs.el" nil t)
(define-transient-command fotingo-start-dispatch()
  "Invoke a fotingo start command with various flags"
  ["Flags"
   (fotingo-branch:-b)
   (fotingo-create:-c)
   (fotingo-type:-t)
   (fotingo-label:-l)
   (fotingo-description:-d)]
  ["Commands"
   ("s" "Start" fotingo-start)])

;;;###autoload (autoload 'fotingo-review-dispatch "fotingo-emacs.el" nil t)
(define-transient-command fotingo-review-dispatch()
  "Invoke a fotingo review command with various flags"
  ;; TODO make use emacs, and label selection
  ["Flags"
   (fotingo-label:-l)
   (fotingo-simple:-s)
   (fotingo-reviewer:-r)]
  ["Commands"
   ("r" "Review" fotingo-review)])

;;;###autoload (autoload 'fotingo-release-dispatch "fotingo-emacs.el" nil t)
(define-transient-command fotingo-release-dispatch()
  "Invoke a fotingo release command with various flags"
  ["Flags"
   (fotingo-simple:-s)]
  ["Commands"
   ("R" "Review" fotingo-release)])

;; Functions:
;;;###autoload
(defun fotingo-start()
  "Runs the fotingo start command with flags pulled from transient"
  (interactive)
  (message
   (concat "env DEBUG=any_random_string fotingo start "
           (read-from-minibuffer (concat (propertize "Issue name: " 'face '(bold default))))
           " "
           (string-join (transient-args 'fotingo-start-dispatch) " ")))
  "*fotingo*")

;;;###autoload
(defun fotingo-review()
  "Runs the fotingo review command with flags pulled from transient"
  (interactive)
  (message
   (concat "env DEBUG=any_random_string fotingo review "
           (fotingo-get-transient-flags 'fotingo-review-dispatch)))
  "*fotingo*")

;;;###autoload
(defun fotingo-release()
  "Runs the fotingo relese command with flags pulled from transient"
  (interactive)
  (message
   (concat "env DEBUG=any_random_string fotingo release "
           (string-join (transient-args 'fotingo-release-dispatch) " ")))
  "*fotingo*")

(defun fotingo-get-transient-flags(prefix)
  "fetches the transient flags from prefix, and returns them as a space separated string"
  (string-join (transient-args 'prefix) " "))

;; Flags:
(define-infix-argument fotingo-branch:-b ()
  :description "Choose a branch"
  :class 'transient-option
  :key "-b"
  :argument "--branch ")

(define-infix-argument fotingo-create:-c ()
  :description "Create a JIRA Issue"
  :class 'transient-option
  :key "-c"
  :argument "--create ")

(define-infix-argument fotingo-type:-t ()
  :description "Choose issue type"
  :class 'transient-option
  :key "-t"
  :argument "--type ")

(define-infix-argument fotingo-label:-l ()
  :description "Apply a JIRA label"
  :class 'transient-option
  :key "-l"
  :argument "--label ")

(define-infix-argument fotingo-description:-d ()
  ;; TODO make launch editor buffer
  :description "Description for a JIRA ticket"
  :class 'transient-option
  :key "-d"
  :argument "--description ")

(define-infix-argument fotingo-reviewer:-r ()
  ;; TODO confirm what this is
  :description "Github user"
  :class 'transient-option
  :key "-r"
  :argument "-r ")

(define-suffix-command fotingo-simple:-s ()
  :description "Create pull request without connecting to JIRA"
  :class 'transient-option
  :key "-s"
  :argument "--simple ")
;;; fotingo-emacs.el ends here
