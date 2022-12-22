(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq custom-file (concat user-emacs-directory "lisp/custom.el"))
(load custom-file)

;; Fix the looks.
(load-theme 'modus-operandi t)
(set-face-attribute 'mode-line nil :box nil)
(set-face-attribute 'mode-line-inactive nil :box nil)
(set-face-attribute 'fringe nil :background nil)
(set-face-attribute 'line-number nil :background nil)
(set-face-attribute 'line-number-current-line nil :inherit 'hl-line :background)
(set-face-attribute 'font-lock-comment-face nil :italic t)
(set-face-attribute 'highlight nil :background "#303030")
(set-face-attribute 'region nil :background "#404040")

(global-hl-line-mode t)

;; Fix the cursor.
(setq blink-cursor-mode nil)
(setq-default cursor-type 'bar)

;; Don't beep at me, cunt.
(setq ring-bell-function 'ignore)

;; Don't disturb me with error messages.
(setq debug-on-error nil)
(setq warning-minimum-level :emergency)

;; Don't pollute my file tree with backup files.
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Don't use GNU-style indentation.
(setq-default c-default-style "bsd"
	      c-basic-offset 8
              tab-width 8
	      indent-tabs-mode nil)

;; Programming mode hooks.
(if (display-graphic-p)
    (add-hook 'prog-mode-hook 'display-line-numbers-mode))

;; Enable essential keybinds.
(global-set-key (kbd "C-x C-b") 'buffer-menu)
(global-set-key (kbd "C-c C-f") 'find-file-at-point)
(global-set-key (kbd "C-c C-c") 'comment-region)
(global-set-key (kbd "C-c C-v") 'uncomment-region)
(global-set-key (kbd "C-c C-j") 'replace-string)

;; Enable shorter answers.
(fset 'yes-or-no-p 'y-or-n-p)

;; Enable region overwrite.
(delete-selection-mode t)

;; Show column number in the modeline.
(column-number-mode t)
