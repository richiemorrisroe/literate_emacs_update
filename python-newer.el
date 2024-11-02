(setq python-shell-interpreter "ipython"
          python-shell-interpreter-args "--simple-prompt -i")
(use-package python-black
  :demand t
  :after python
  :hook (python-mode . python-black-on-save-mode-enable-dwim))
