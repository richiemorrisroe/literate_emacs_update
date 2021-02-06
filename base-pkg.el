(unless (package-installed-p 'use-package)
            (package-refresh-contents)
            (package-install 'use-package))

            (unless (package-installed-p 'diminish)
            (package-refresh-contents)
            (package-install 'diminish))

      (setq package-archives '(("elpa" . "https://tromey.com/elpa/")
                               ("gnu" . "https://elpa.gnu.org/packages/")))
    (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
    (add-to-list 'package-archives
    '("melpa-stable" . "https://stable.melpa.org/packages/"))
    (add-to-list 'package-archives
    '("melpa" . "https://melpa.org/packages/"))
(use-package magit :ensure t)
(use-package ess :ensure t
  :init (require 'ess-site))
(use-package helpful
        :ensure t)
  (load-theme 'wheatgrass t)
  (use-package elpy
  :ensure t

  )
(setq use-package-always-defer t
        use-package-always-ensure t
        backup-directory-alist `((".*" . ,temporary-file-directory))
        auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; (desktop-save-mode 1)
