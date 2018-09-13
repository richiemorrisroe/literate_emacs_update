    (require 'package)
    (setq package-enable-at-startup nil)
    (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
    (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
    (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
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
				 ("melpa" . "https://melpa.org/packages/")
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
(use-package ess)
(use-package helpful
  :ensure t)
(use-package helm
  :ensure t
  :config
  (require 'helm-config))
