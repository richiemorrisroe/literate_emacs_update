
    ;; (load "~/Dropbox/literate_emacs_update/packages.el")

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

    (load "~/Dropbox/literate_emacs_update/package-new.el")
    (load "~/Dropbox/literate_emacs_update/keybindings.el")
    (load "~/Dropbox/literate_emacs_update/cpp.el")
    (load "~/Dropbox/literate_emacs_update/setup-editing.el")
    (load "~/Dropbox/literate_emacs_update/ess.el")
    (load "~/Dropbox/literate_emacs_update/latex-ess.el")
    (load "~/Dropbox/literate_emacs_update/org-setup.el")
(load "~/Dropbox/literate_emacs_update/python.el")
(load "~/Dropbox/literate_emacs_update/tramp.el")
  ;;default anaconda path after install
  (setq exec-path (cons "/home/richie/anaconda3/bin" exec-path))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (slime use-package smartparens rust-mode magit irony helpful helm flycheck-rust ess elpy diminish auctex anaconda-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
