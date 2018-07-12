(setq package-list '(auctex
                     bash-completion
                     flycheck
                     magit
                     use-package
                     elpy
                     smartparens))
;;taken from http://stackoverflow.com/questions/10092322/how-to-automatically-install-emacs-packages-by-specifying-a-list-of-package-name
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))
