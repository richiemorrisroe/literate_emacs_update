
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((R . t)
     (emacs-lisp . t)
     (sql . t)
     (python . t)
     (latex . t)
     ;; (sh . t)
     (java . t)
     (C . t)
     (lisp . t)
     ;; (stan . t)
     ))
  (setq org-babel-confirm-evaluate nil)
  (setq org-default-notes-file "~/Dropbox/Notes/notes.org")
  (add-hook 'prog-mode-hook 'flyspell-prog-mode)
  (global-set-key "\C-ci" 'org-redisplay-inline-images)

  (setq org-edit-src-content-indentation 0)
  (setq org-src-tab-acts-natively t)
  (setq org-src-preserve-indentation t)
  (setq exec-path (append exec-path '("/home/richie/anaconda3/bin/" "~/.local/bin/")))
