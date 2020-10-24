(use-package lsp-mode
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-mode . lsp)
         (ess-r-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
         :config (setq lsp-prefer-flymake nil)
  :commands lsp)

;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
;; (use-package company-lsp :commands company-lsp)
;; ;; if you are helm user
;; (use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; ;; if you are ivy user
;; (use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;; (use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; ;; optionally if you want to use debugger
;; (use-package dap-mode)
;; ;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; optional if you want which-key integration
(use-package which-key
  :config
  (which-key-mode))

(setq gc-cons-threshold 400000000)
(setq read-process-output-max (* 1024 1024)) 
(setq lsp-response-timeout 60)
(use-package lsp-python-ms
  :ensure t
  :hook (python-mode . (lambda ()
                          (require 'lsp-python-ms)
                          (lsp))))

(setq company-minimum-prefix-length 1
      company-idle-delay 0.0)
