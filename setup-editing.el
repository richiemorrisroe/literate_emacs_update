(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
   '(("." . "~/.saves/")))

;; Note that the built-in `describe-function' includes both functions
;; and macros. `helpful-function' is functions only, so we provide
;; `helpful-callable' as a drop-in replacement.
(global-set-key (kbd "C-h f") #'helpful-callable)

(global-set-key (kbd "C-h v") #'helpful-variable)
(global-set-key (kbd "C-h k") #'helpful-key)

;; Lookup the current symbol at point. C-c C-d is a common keybinding
;; for this in lisp modes.
(global-set-key (kbd "C-c C-d") #'helpful-at-point)

;; Look up *F*unctions (excludes macros).
;;
;; By default, C-h F is bound to `Info-goto-emacs-command-node'. Helpful
;; already links to the manual, if a function is referenced there.
(global-set-key (kbd "C-h F") #'helpful-function)

;; Look up *C*ommands.
;;
;; By default, C-h C is bound to describe `describe-coding-system'. I
;; don't find this very useful, but it's frequently useful to only
;; look at interactive functions.
(global-set-key (kbd "C-h C") #'helpful-command)
(setq electric-indent-mode t)
(load-theme 'wheatgrass t)
(setq sentence-end-double-space nil)
(setq tab-always-indent 'complete)
(add-hook 'prog-mode-hook (lambda () (interactive) (setq show-trailing-whitespace 1)))
(add-hook 'after-init-hook 'global-company-mode)
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-to-list 'display-buffer-alist '("*shell*" display-buffer-same-window))
(smartparens-global-mode t)
(require 'smartparens-config)
(setq save-interprogram-paste-before-kill t)
(require 'cedet)
(require 'semantic)
(add-to-list 'load-path "~/mmix-mode")
    (autoload 'mmix-mode "mmix-mode" "Major mode for editing MMIX files" t)
    (setq auto-mode-alist (cons '("\\.mms" . mmix-mode)
                                      auto-mode-alist))

  (add-hook 'shell-mode-hook 'compilation-shell-minor-mode) ;;enable compile buffers in shell mode
  (setq debug-on-error t)
  (setq inferior-lisp-program "sbcl")
  (setq-default indent-tabs-mode nil)
  (setq synonyms-file        "~/mythesaurus/")
  (setq synonyms-cache-file  "~/mythesaurus/cache")
  (show-paren-mode 1);;always show bracket highlighting
  (global-linum-mode 1);;always show line numbers
  (global-visual-line-mode 1) ;;always wrap words visually
  (global-font-lock-mode 1)
  (transient-mark-mode t) ;;turn on transient mark mode, must have turned it off by accident.
  (setq x-select-enable-clipboard t) ;; enable clipboard in and out of emacs
  (fset 'yes-or-no-p 'y-or-n-p) ;;allow y or n to stand for yes or no
  (put 'erase-buffer 'disabled nil) ;;enable erase buffer command
  (put 'set-goal-column 'disabled nil) ;;enable set goal column
  ;; (load-theme 'wheatgrass t)
  (setq tramp-default-method "ssh")

  (put 'upcase-region 'disabled nil)
  (put 'downcase-region 'disabled nil)
  (server-start)
  (add-hook 'prog-mode-hook 'subword-mode)
  (global-set-key "\C-cp" 'run-python)
