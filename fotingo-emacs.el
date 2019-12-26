;;; fotingo-emacs.el --- An Emacs wrapper for fotingo  -*- lexical-binding: t; coding: utf-8 -*-

;; Author: Mackenzie Bligh <mackenziebligh@gmail.com>

;; Keywords: git tools vc jira
;; Homepage: TODO

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

;; Code:
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
