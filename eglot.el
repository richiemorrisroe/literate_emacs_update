(require 'eglot)

(exec-path-from-shell-initialize)
;; (use-package eglot-pyright
;;   :ensure t
;;   :config
;;   (add-to-list 'eglot-server-programs
;;                '(python-mode . ("pyright-langserver" "--stdio"))))
(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  :init
  (global-corfu-mode))
(use-package lsp-pyright
  :ensure t)

(add-hook 'python-mode-hook 'eglot-ensure)


(add-hook 'ess-r-mode-hook 'eglot-ensure)

(setq read-process-output-max (* 1024 1024)) ;; 1mb
