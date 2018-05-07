
(use-package magit)
(use-package bashcompletion)
(use-package flycheck
  :config
  (global-flycheck-mode 1))
;; (use-package auctex
;;   :init
;;   (require 'tex)
;;   :config
;;   ((setq TeX-auto-save t)
;; (setq TeX-parse-self t)))
(use-package elpy
  :init
  (elpy-enable))
(use-package smartparens
  :config
  (smartparens-global-mode t)
  (require 'smartparens-config))
(use-package ess)
