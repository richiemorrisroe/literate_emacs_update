(unless (package-installed-p 'use-package)
	(package-refresh-contents)
	(package-install 'use-package))

	(unless (package-installed-p 'diminish)
	(package-refresh-contents)
	(package-install 'diminish))
      (use-package magit :ensure t)
  (setq package-archives '(("elpa" . "https://tromey.com/elpa/")
			   ("gnu" . "https://elpa.gnu.org/packages/")
			   ("marmalade" . "https://marmalade-repo.org/packages/")))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives
'("melpa-stable" . "https://stable.melpa.org/packages/"))
;; (add-to-list 'package-archives
;; '("melpa" . "https://melpa.org/packages/"))
(global-set-key "\C-cg" 'magit-status)
(global-set-key (kbd "C-x m") 'execute-extended-command)
  (use-package helpful
    :ensure t)
