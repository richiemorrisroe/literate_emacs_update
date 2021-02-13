;;utility keybindings
    (global-set-key (kbd "C-x m") 'execute-extended-command)
    (global-set-key "\C-co" 'browse-url-at-point)
    (global-set-key "\C-cm" 'man)
    (global-set-key "\C-xt" 'transpose-lines); keybinding to transpose lines
    ;;org mode keybindings
    (global-set-key (kbd "\C-cw") 'balance-windows)
    ;; process commands all C-c<letter>
    (global-set-key "\C-cr" 'R); keybinding for R
    (global-set-key "\C-cs" 'shell); keybinding to start shell process
    (global-set-key "\C-cp" 'run-python)
    (global-set-key "\C-xc" 'inferior-lisp)
    (global-set-key "\C-cg" 'magit-status)

    ;; (global-set-key "\C-cl" 'org-store-link)
  ;;   (global-set-key "\C-cc" 'org-capture) ;;i should either start using
  ;;                                         ;;these or delete them
  ;;   (global-set-key "\C-ca" 'org-agenda)
  ;; (global-set-key "\C-cb" 'org-iswitchb)
  (global-set-key "\C-ci" 'org-redisplay-inline-images)
(global-set-key "\C-c_" 'ess-smart-assign)
;; Note that the built-in `describe-function' includes both functions
;; and macros. `helpful-function' is functions only, so we provide
;; `helpful-callable' as a drop-in replacement.
(global-set-key (kbd "C-h f") #'helpful-callable)

(global-set-key (kbd "C-h v") #'helpful-variable)
(global-set-key (kbd "C-h k") #'helpful-key)

;; Lookup the current symbol at point. C-c C-d is a common keybinding
;; for this in lisp modes.
(global-set-key (kbd "C-c C-d") #'helpful-at-point)

;; Look up *F*unctions (excludes macros).
;;
;; By default, C-h F is bound to `Info-goto-emacs-command-node'. Helpful
;; already links to the manual, if a function is referenced there.
(global-set-key (kbd "C-h F") #'helpful-function)

;; Look up *C*ommands.
;;
;; By default, C-h C is bound to describe `describe-coding-system'. I
;; don't find this very useful, but it's frequently useful to only
;; look at interactive functions.
(global-set-key (kbd "C-h C") #'helpful-command)
