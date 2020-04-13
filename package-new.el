  (require 'package)
  (setq package-enable-at-startup nil)
  (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
  (add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
      (package-initialize)

      (unless (package-installed-p 'use-package)
        (package-refresh-contents)
        (package-install 'use-package))

      (eval-when-compile
        (require 'use-package))
      (require 'diminish)
      (require 'bind-key)
      (setq package-archives '(("elpa" . "https://tromey.com/elpa/")
                                   ("gnu" . "https://elpa.gnu.org/packages/")
                                   ("marmalade" . "https://marmalade-repo.org/packages/")
                                   ("org" . "https://orgmode.org/elpa/")
                                   ("melpa-stable" . "https://stable.melpa.org/packages/")
                                   ))
      (use-package magit :ensure t)
      (use-package flycheck
                   :ensure t
                   :config
        (global-flycheck-mode 1))

    (use-package tex 
      :ensure auctex
      ;; :config
      ;; ((setq TeX-auto-save t)

      ;; (setq TeX-parse-self t))  
    )
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
    :ensure t)
  (use-package helpful
    :ensure t)
  (use-package helm
    :ensure t
    :config
    (require 'helm-config))
(require 'package)



;; Add melpa to your packages repositories
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

;; Install use-package if not already installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;; Enable defer and ensure by default for use-package
;; Keep auto-save/backup files separate from source code:  https://github.com/scalameta/metals/issues/1027
(setq use-package-always-defer t
      use-package-always-ensure t
      backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; Enable scala-mode and sbt-mode
(use-package scala-mode
  :mode "\\.s\\(cala\\|bt\\)$")

(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map)
   ;; sbt-supershell kills sbt-mode:  https://github.com/hvesalai/emacs-sbt-mode/issues/152
   (setq sbt:program-options '("-Dsbt.supershell=false"))
)

;; Enable nice rendering of diagnostics like compile errors.
(use-package flycheck
  :init (global-flycheck-mode))

(use-package lsp-mode
  ;; Optional - enable lsp-mode automatically in scala files
  :hook (scala-mode . lsp)
  :config (setq lsp-prefer-flymake nil))

(use-package lsp-ui)

;; lsp-mode supports snippets, but in order for them to work you need to use yasnippet
;; If you don't want to use snippets set lsp-enable-snippet to nil in your lsp-mode settings
;;   to avoid odd behavior with snippets and indentation
(use-package yasnippet)

;; Add company-lsp backend for metals
(use-package company-lsp)
(setq lsp-keymap-prefix "s-l")

(use-package lsp-mode
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-mode . lsp)
         (R-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
(use-package company-lsp :commands company-lsp)
;; if you are helm user
(use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; if you are ivy user
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
(use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; optional if you want which-key integration
(use-package which-key
  :config
  (which-key-mode))

(setq gc-cons-threshold 400000000)
(setq read-process-output-max (* 1024 1024)) 
(setq lsp-response-timeout 20)
(use-package lsp-python-ms
  :ensure t
  :hook (python-mode . (lambda ()
                          (require 'lsp-python-ms)
                          (lsp))))

(setq company-minimum-prefix-length 1
      company-idle-delay 0.0)
