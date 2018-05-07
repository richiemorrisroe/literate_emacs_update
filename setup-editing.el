
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
