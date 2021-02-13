(load (expand-file-name "~/quicklisp/slime-helper.el"))
  ;; Replace "sbcl" with the path to your implementation
  (setq inferior-lisp-program "sbcl")
  (use-package lsp-mode
    :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
           (python-mode . lsp)
           (ess-r-mode . lsp)
           (java-mode .lsp)
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
  ;; (use-package lsp-python-ms
  ;;   :ensure t
  ;;   :hook (python-mode . (lambda ()
  ;;                           (require 'lsp-python-ms)
  ;;                           (lsp))))
  ;; (use-package lsp-pyre
  ;;   :ensure t
  ;;   :hook (python-mode . (lambda ()
  ;;                           (require 'lsp-pyre)
  ;;                           (lsp))))
  (use-package lsp-pyright
    :ensure t
    :hook (python-mode . (lambda ()
                           (require 'lsp-pyright)
                           (lsp))))

  (setq company-minimum-prefix-length 1
        company-idle-delay 0.1)

  ;; (use-package lsp-jedi
  ;;   :ensure t
  ;;   :config
  ;;   (with-eval-after-load "lsp-mode"
  ;;     (add-to-list 'lsp-disabled-clients 'pyls)
  ;;         (add-to-list 'lsp-enabled-clients 'jedi)))

  ;; (use-package lsp-jedi
  ;;   :ensure t
  ;;   :hook (python-mode . (lambda ()
  ;;                          (require 'lsp-jedi)
  ;;                          (lsp))))
