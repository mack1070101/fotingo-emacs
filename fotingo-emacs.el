;;; fotingo-emacs.el --- An Emacs wrapper for fotingo  -*- lexical-binding: t; coding: utf-8 -*-

;; Author: Mackenzie Bligh <mackenziebligh@gmail.com>

;; Keywords: git tools vc jira
;; Homepage: https://github.com/mack1070101/fotingo-emacs
;; Version: 0.0.1

;; fotingo-emacs requires at least GNU Emacs 25.1 and fotingo 1.9.2

;; fotingo-emacs is free software; you can redistribute it and/or modify it
;; under the terms of the gnu general public license as published by
;; the free software foundation; either version 3, or (at your option)
;; any later version.
;;
;; fotingo-emacs is distributed in the hope that it will be useful, but without
;; any warranty; without even the implied warranty of merchantability
;; or fitness for a particular purpose. See the gnu general public
;; license for more details.
;;
;; You should have received a copy of the gnu general public license
;; along with fotingo-emacs.  if not, see http://www.gnu.org/licenses.

;;; Commentary:
;; fotingo-emacs is an Emacs interface to the cli tool fotingo. Fotingo is a
;; CLI to ease the interaction between Git, Github and Jira when working on tasks.
;; fotingo-emacs aims to provide the same level of convenience provided by Magit
;; and is designed to follow a similar work flow. It is designed to fit into Magit's
;; transient menus to help supplement existing version control work flows.

;;; Code:
(require 'transient 'goto-address-mode)

(setq fotingo-command "env DEBUG=any_random_string fotingo")

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
  ["Flags"
   (fotingo-label:-l)
   (fotingo-simple:-s)
   (fotingo-yes:-y)
   (fotingo-reviewer:-r)]
  ["Commands"
   ("r" "Review" fotingo-review)])

;;;###autoload (autoload 'fotingo-release-dispatch "fotingo-emacs.el" nil t)
(define-transient-command fotingo-release-dispatch()
  "Invoke a fotingo release command with various flags"
  ["Flags"
   (fotingo-issue:-i)
   (fotingo-yes:-y)
   (fotingo-simple:-s)]
  ["Commands"
   ("R" "Release" fotingo-release)])

;; Functions:
;;;###autoload
(defun fotingo-start()
  "Runs the fotingo start command with flags pulled from transient"
  (interactive)
  (fotingo-cli-command
   (string-join (list "start"
                      (read-from-minibuffer (concat (propertize
                                                     "Issue name: "
                                                     'face
                                                     '(bold default)))))
                " ")
   'fotingo-start-dispatch))

;;;###autoload
(defun fotingo-review()
  "Runs the fotingo review command with flags pulled from transient"
  (interactive)
  (fotingo-cli-command "review" 'fotingo-review-dispatch))

;;;###autoload
(defun fotingo-release()
  "Runs the fotingo relese command with flags pulled from transient"
  (interactive)
  (fotingo-cli-command "release" 'fotingo-release-dispatch))

;;;###autoload
(defun fotingo-cli-command (command-name dispatch-func)
  "Executes a shell-command for fotingo"
  (interactive)
  (let* ((output-buffer (get-buffer-create "*fotingo*")))
    (with-current-buffer output-buffer (goto-address-mode))
    (split-window-below-and-focus)
    (switch-to-buffer output-buffer)
    (other-window -1)
    (call-process-shell-command
     (string-join (list fotingo-command
                        command-name
                        (fotingo-transient-args-to-string dispatch-func))
                  " ")
     nil
     output-buffer
     t)))

(defun fotingo-transient-args-to-string(fotingo-func)
  "Converts transient args to strings"
  (string-join (transient-args fotingo-func) " "))

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
  :description "Description for a JIRA ticket"
  :class 'transient-option
  :key "-d"
  :argument "--description ")

(define-infix-argument fotingo-reviewer:-r ()
  :description "Request review from a Github user"
  :class 'transient-option
  :key "-r"
  :argument "-r ")

(define-infix-argument fotingo-simple:-s()
  :description "Create without corresponding JIRA issue"
  :key "-s"
  :argument "--simple")

(define-infix-argument fotingo-issue:-i ()
  :description "Issue name"
  :class 'transient-option
  :key "-i"
  :argument "-i ")

(define-infix-argument fotingo-yes:-y ()
  :description "Use fotingo defaults; skip launching editor"
  :key "-y"
  :argument "--yes")
;;; fotingo-emacs.el ends here
