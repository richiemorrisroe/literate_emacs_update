(setq package-list '(use-package
		       diminish
		       ))
  ;;taken from http://stackoverflow.com/questions/10092322/how-to-automatically-install-emacs-packages-by-specifying-a-list-of-package-name
  (package-initialize)

  (unless package-archive-contents
    (package-refresh-contents))

  (dolist (package package-list)
    (unless (package-installed-p package)
      (package-install package)))

(require 'package)
  (setq package-enable-at-startup nil)
  (add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
  ;; (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
      (package-initialize)

      (unless (package-installed-p 'use-package)
        (package-refresh-contents)
        (package-install 'use-package))

        (unless (package-installed-p 'diminish)
        (package-refresh-contents)
        (package-install 'diminish))

      (eval-when-compile
        (require 'use-package))
      (require 'diminish)
      (require 'bind-key)
      (setq package-archives '(("elpa" . "http://tromey.com/elpa/")
                                   ("gnu" . "http://elpa.gnu.org/packages/")
                                   ("marmalade" . "http://marmalade-repo.org/packages/")
                                   ("org" . "http://orgmode.org/elpa/")
                                   ("melpa" . "http://melpa.org/packages/")
                                   ))

      (use-package flycheck
                   :ensure t
                   :config
        (add-hook 'after-init-hook #'global-flycheck-mode))

    (use-package tex 
      :ensure auctex
      ;; :config
      ;; ((setq TeX-auto-save t)

      ;; (setq TeX-parse-self t))  
    )
      (use-package smartparens
                   :ensure t
                   :config
                   (smartparens-global-mode t)
                   (require 'smartparens-config))
  (use-package ess
    :ensure t)

  (use-package helm
    :ensure t
    :config
    (require 'helm-config))
(require 'package)



;; Add melpa to your packages repositories
;; (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

;; Install use-package if not already installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;; Enable defer and ensure by default for use-package
;; Keep auto-save/backup files separate from source code:  https://github.com/scalameta/metals/issues/1027


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
  )

(use-package lsp-ui)

;; lsp-mode supports snippets, but in order for them to work you need to use yasnippet
;; If you don't want to use snippets set lsp-enable-snippet to nil in your lsp-mode settings
;;   to avoid odd behavior with snippets and indentation
(use-package yasnippet)

;; Add company-lsp backend for metals
(use-package company-lsp)
(setq lsp-keymap-prefix  "\C-cl")

(use-package lsp-mode
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-mode . lsp)
         (ess-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
         :config (setq lsp-prefer-flymake nil)
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
(require 'dap-python)
;; (use-package dap-python) 

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
