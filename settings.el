(add-hook 'shell-mode-hook 'compilation-shell-minor-mode) ;;enable compile buffers in shell mode
  (setq debug-on-error t)
  (setq-default indent-tabs-mode nil)
  (show-paren-mode 1);;always show bracket highlighting.
  (add-hook 'prog-mode-hook (lambda () global-linum-mode 1));;always show line numbers
  (global-font-lock-mode 1)
  (transient-mark-mode t) ;;turn on transient mark mode, must have turned it off by accident.
  (setq x-select-enable-clipboard t) ;; enable clipboard in and out of emacs
  (fset 'yes-or-no-p 'y-or-n-p) ;;allow y or n to stand for yes or no
  (put 'erase-buffer 'disabled nil) ;;enable erase buffer command
  (put 'set-goal-column 'disabled nil) ;;enable set goal column
  ;; (load-theme 'wheatgrass t)
  (setq tramp-default-method "ssh")
  (setq dired-listing-switches "-alh")
  (put 'upcase-region 'disabled nil)
  (put 'downcase-region 'disabled nil)
  (server-start)
