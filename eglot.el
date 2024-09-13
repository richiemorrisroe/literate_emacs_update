(require 'eglot)

;; (use-package eglot-pyright
;;   :ensure t
;;   :config
;;   (add-to-list 'eglot-server-programs
;;                '(python-mode . ("pyright-langserver" "--stdio"))))


(use-package lsp-pyright
  :ensure t)

(add-hook 'python-mode-hook 'eglot-ensure)


(add-hook 'ess-r-mode-hook 'eglot-ensure)

(setq read-process-output-max (* 1024 1024)) ;; 1mb
