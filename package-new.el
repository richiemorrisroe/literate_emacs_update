(use-package magit
  :ensure t)
;; (use-package bashcompletion
;;   :ensure t)
(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode 1))
;; (use-package auctex
;;   :init
;;   (require 'tex)
;;   :config
;;   ((setq TeX-auto-save t)
;; (setq TeX-parse-self t)))
(use-package elpy
  :ensure t
  :init
  (elpy-enable))
(use-package smartparens
  :ensure t
  :config
  (smartparens-global-mode t)
  (require 'smartparens-config))
(use-package ess
  :ensure t
  :init (require 'ess-site))
