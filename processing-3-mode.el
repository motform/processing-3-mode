;;; processing-3-mode.el --- A minimalist processing-3 mode -*- lexical-binding: t -*-

;; Copyright © 2019

;; Author: Love Lagerkvist
;; Package: processing-3-mode
;; URL: https://github.com/motform/processing-3-mode
;; Package-Requires: ((emacs "25"))
;; Created: 2019-11-16
;; Version: 2020-12-31
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
;; wrapper for the `processing-java' command line tool.
;;
;; It requires P3 with CLI tools enabled, which can be installed from
;; https://github.com/processing/processing/wiki/Command-Line

;;; Code:
(require 'compile)
(require 'subr-x)

;;; Customization
(defgroup processing-3 nil
  "Processing-3-mode functions and settings."
  :group 'tools
  :prefix "processing-3-")

(defcustom processing-3-compile-cmd 'run
  "Set the command to run with `processing-3-mode-keymap-prefix+c'.
'run (default), 'build, 'present or 'export."
  :group 'processing-3
  :type 'symbol)

(defcustom processing-3-force nil
  "Set the processing-java `--force' flag.
nil (default) or t.
\nFrom the man page:
The sketch will not build if the output folder
already exists, because the contents will be replaced.
This option erases the folder first.  Use with extreme caution!"
  :group 'processing-3
  :type 'boolean
  :options '(t nil))

(defcustom processing-3-no-java nil
  "Set the processing-java `--no-java' flag.
nil (default) or t.
\nFrom the man page:
Do not embed Java.  Use at your own risk!"
  :group 'processing-3
  :type 'boolean)

(defcustom processing-3-platform nil
  "Set the processing-java `--export' flag.
nil (default), 'windows, 'macosx or 'linux.
\nFrom the man page:
Specify the platform (export to application only)."
  :group 'processing-3
  :type 'symbol)

(defcustom processing-3-args ""
  "Set a string of args to pass to `processing-java', default none.
For reference on how to use args:
https://github.com/processing/processing/wiki/Command-Line#adding-command-line-arguments"
  :group 'processing-3
  :type 'string
  :safe t)


;;; Internal functions
(define-compilation-mode processing-3-compilation-mode "processing-3-compilation"
  "Processing-3-mode specific 'compilation-mode' derivative."
  (setq-local compilation-scroll-output t)
  (require 'ansi-color))

(defun processing-3--flags ()
  "Add flags to `cmd', if set."
  (string-join (list (when processing-3-no-java "--no-java")
                     (when processing-3-force "--force"))
               " "))

(defun processing-3--trailing-args (cmd)
  "Add `--platform' if `processing-3-platform' is set and `CMD' is `--export'.
Otherwise, add whichever args are present in `processing-3-args'"
  (if (and processing-3-platform (string-equal cmd "--export"))
      (concat " --platform " (symbol-name processing-3-platform))
    processing-3-args))

(defun processing-3--build-cmd (cmd)
  "Build the cmd, where `CMD' is one of `run', `build', `present' or `export'."
  (string-join (list "processing-java"
                     (processing-3--flags)
                     (concat "--sketch=" (shell-quote-argument default-directory))
                     cmd
                     (processing-3--trailing-args cmd))
               " "))

(defun processing-3--compile (cmd)
  "Run a Processing-3 CMD in cli-compilation-mode."
  (save-some-buffers (not compilation-ask-about-save)
                     (lambda () default-directory))
  (compilation-start (processing-3--build-cmd cmd) 'processing-3-compilation-mode))


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

(defun processing-3-compile-cmd ()
  "Run `processing-java' with `processing-3-compile-cmd' (default --run)."
  (interactive)
  (processing-3--compile (concat "--" (symbol-name processing-3-compile-cmd))))


;;; Major mode
(defvar processing-3-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-c\C-r"  #'processing-3-run)
    (define-key map "\C-c\C-c"  #'processing-3-compile-cmd)
    (define-key map "\C-c\C-b"  #'processing-3-build)
    (define-key map "\C-c\C-p"  #'processing-3-present)
    (define-key map "\C-c\C-e"  #'processing-3-export)
    map)
  "Keymap for `processing-3-mode'.")


;;;###autoload
(define-derived-mode processing-3-mode
  java-mode "Processing 3"
  "Major mode for Processing 3. Provides convenience functions to use the `processing-java' cli.
\n\\{processing-3-mode-map}")

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.pde$" . processing-3-mode))

(provide 'processing-3-mode)
;;; processing-3-mode.el ends here
