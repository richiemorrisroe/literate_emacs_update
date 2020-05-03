;;utility keybindings
  (global-set-key "\C-co" 'browse-url-at-point)
  (global-set-key "\C-cm" 'man)
  (global-set-key "\C-xt" 'transpose-lines); keybinding to transpose lines
  ;;org mode keybindings
  (global-set-key (kbd "\C-cw") 'balance-windows)
  ;; process commands all C-c<letter>
  (global-set-key "\C-cr" 'R); keybinding for replace string
  (global-set-key "\C-cs" 'shell); keybinding to start shell process
  (global-set-key "\C-cp" 'run-python)
  (global-set-key "\C-xc" 'inferior-lisp)
  (global-set-key "\C-cg" 'magit-status)

  (global-set-key "\C-cl" 'org-store-link)
  (global-set-key "\C-cc" 'org-capture) ;;i should either start using
					;;these or delete them
  (global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key "\C-ci" 'org-redisplay-inline-images)
