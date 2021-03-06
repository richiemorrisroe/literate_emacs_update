;; (setq exec-path (append  '("~/anaconda3/bin") exec-path))
;; (when (executable-find "jupyter")
;;   (setq
;;    python-shell-interpreter "jupyter"
;;    python-shell-interpreter-args "console --simple-prompt"
;;    python-shell-prompt-regexp "In \\[[0-9]+\\]: "
;;    python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
;;    python-shell-completion-setup-code
;;    "from IPython.core.completerlib import module_completion"
;;    python-shell-completion-module-string-code
;;    "';'.join(module_completion('''%s'''))\n"
;;    python-shell-completion-string-code
;;    "';'.join(get_ipython().Completer.all_completions('''%s'''))\n"))
(setq python-shell-interpreter "jupyter")
(setq python-shell-interpreter-args "console")

(elpy-enable)
