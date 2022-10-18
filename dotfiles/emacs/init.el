(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq user-emacs-directory "~/.config/emacs/")
(setq custom-file (concat user-emacs-directory "lisp/custom.el"))
(load custom-file)

;; Don't show fancy colours in terminals.
(if (not (display-graphic-p))
    (global-font-lock-mode 0))

;; Fix the looks.
(load-theme 'badwolf t)
(set-face-attribute 'mode-line nil :box nil)
(set-face-attribute 'mode-line-inactive nil :box nil)
(set-face-attribute 'fringe nil :background nil)
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
(setq-default c-default-style "k&r"
	      c-basic-offset 4
	      indent-tabs-mode nil)

;; Programming mode hooks.
(add-hook 'c-mode-hook 'whitepace-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Enable Magit.
(require 'magit)

;; Enable essential keybinds.
(global-set-key (kbd "C-x C-b") 'buffer-menu)
(global-set-key (kbd "C-c C-f") 'find-file-at-point)
(global-set-key (kbd "C-c C-c") 'comment-region)
(global-set-key (kbd "C-c C-v") 'uncomment-region)
(global-set-key (kbd "C-c C-j") 'replace-string)

(global-set-key (kbd "C-c g") 'magit-file-dispatch)
(global-set-key (kbd "C-c d") 'magit-diff-buffer-file)
(global-set-key (kbd "C-c s") 'magit-status)
(global-set-key (kbd "C-c p") 'magit-push)
(global-set-key (kbd "C-c c") 'magit-commit)

;; Enable shorter answers.
(fset 'yes-or-no-p 'y-or-n-p)

;; Enable region overwrite.
(delete-selection-mode t)
