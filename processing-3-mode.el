;;; processing-3-mode.el --- arduino-cli command wrapper -*- lexical-binding: t -*-

;; Copyright © 2019

;; Author: Love Lagerkvist
;; Package: processing-3-mode
;; URL: https://github.com/motform/processing-3-mode
;; Package-Requires: ((emacs "25"))
;; Created: 2019-11-16
;; Updated: 2020-12-31
;; Keywords: extensions processing

;; This file is NOT part of GNU Emacs.

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package is a minimalist Processing 3 mode that also contains a
;; wrapper for the `processing-java` command line tool.
;;
;; It requires P3 with CLI tools enabled, which can be installed from
;; https://github.com/processing/processing/wiki/Command-Line
;;
;; Flags are yet to be supported, ditto command line arguments.

;;; Code:
(require 'cc-vars)
(require 'compile)

;;; Customization

(defgroup processing-3 nil
  "Processing 3 functions and settings."
  :group 'tools
  :prefix "processing-3-")

(defcustom processing-3-mode-keymap-prefix (kbd "C-c C-p")
  "Arduino-cli keymap prefix."
  :group 'processing-3
  :type 'string)


;;; Internal functions
(define-compilation-mode processing-3-compilation-mode "processing-3-compilation"
  "Processing-3-mode specific `compilation-mode' derivative."
  (setq-local compilation-scroll-output t)
  (require 'ansi-color))

(defun processing-3--compile (cmd)
  "Run a Processing-3 CMD in cli-compilation-mode."
  (let ((cmd (concat "processing-java --sketch=" (shell-quote-argument default-directory) " " cmd)))
    (save-some-buffers (not compilation-ask-about-save)
                       (lambda () default-directory))
    (compilation-start cmd 'processing-3-compilation-mode)))

;;; User commands
(defun processing-3-run ()
  "Preprocess, compile, and run a sketch."
  (interactive)
  (processing-3--compile "--run"))

(defun processing-3-build ()
  "Preprocess and compile a sketch into .class files."
  (interactive)
  (processing-3--compile "--build"))

(defun processing-3-present ()
  "Preprocess, compile, and run a sketch in presentation mode."
  (interactive)
  (processing-3--compile "--present"))

(defun processing-3-export ()
  "Export a sketch."
  (interactive)
  (processing-3--compile "--export"))


;;; Major mode
(defvar processing-3-command-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "r") #'processing-3-run)
    (define-key map (kbd "c") #'processing-3-run)         ; for those of us used to C-c.
    (define-key map (kbd "b") #'processing-3-build)
    (define-key map (kbd "p") #'processing-3-present)
    (define-key map (kbd "e") #'processing-3-export)
    map)
  "Keymap for processing-3-mode commands after `processing-3-mode-keymap-prefix'.")
(fset 'processing-3-command-map processing-3-command-map)

(defvar processing-3-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map processing-3-mode-keymap-prefix 'processing-3-command-map)
    map)
  "Keymap for processing-3-mode.")


;;;###autoload
;; Borrowed from https://github.com/ptrv/processing2-emacs/
(define-derived-mode processing-3-mode
  java-mode "Processing 3"
  "Major mode for Processing 3. Provides convenience functions to use the `processing-java' cli.
\n\\{processing-3-mode-map}")

(add-to-list 'auto-mode-alist '("\\.pde$" . processing-3-mode))

(provide 'processing-3-mode)
;;; processing-3-mode.el ends here
