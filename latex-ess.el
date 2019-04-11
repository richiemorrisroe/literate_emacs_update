
  (add-hook 'Rnw-mode-hook
            (lambda ()
              (add-to-list 'TeX-command-list
                           '("Sweave" "R CMD Sweave %s"
                             TeX-run-command nil (latex-mode) :help "Run Sweave") t)
              (add-to-list 'TeX-command-list
                           '("LatexSweave" "%l %(mode) %s"
                             TeX-run-TeX nil (latex-mode) :help "Run Latex after Sweave") t)
              (setq TeX-command-default "Sweave")))
  (setq TeX-file-extensions
        '("Snw" "Rnw" "nw" "tex" "sty" "cls" "ltx" "texi" "texinfo"))
  (add-to-list 'auto-mode-alist '("\\.Rnw\\'" . Rnw-mode))
  (add-to-list 'auto-mode-alist '("\\.Snw\\'" . Rnw-mode))
  (setq ess-swv-plug-into-AUCTeX-p t)
  (autoload 'ess-rdired "ess-rdired"
         "View *R* objects in a dired-like buffer." t)
  (setq ess-help-pop-to-buffer t)
  (setq TeX-auto-save t);;tell tex to autosave
  (setq TeX-parse-self t)
  (setq reftex-plug-into-AUCTeX t)
  (setq-default TeX-master nil)
  (add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ; with AUCTeX LaTeX mode
  (add-hook 'Rnw-mode-hook 'turn-on-reftex)
  (add-hook 'tex-mode-hook (function (lambda () (setq ispell-parser 'tex))))
  (setq reftex-file-extensions
        '(("Snw" ".Snw")
          ("Rnw" ".Rnw")
          ("nw" ".nw")
  ("tex" ".tex" ".ltx")
  ("bib" ".bib")))
  (setq TeX-file-extensions
        '("Snw" "Rnw" "nw" "tex" "sty" "cls" "ltx" "texi" "texinfo"))
  (autoload 'ebib "ebib" "Ebib, a BibTeX database manager." t)
  (setq reftex-external-file-finders
        '(("tex" . "kpsewhich -format=.tex %f")
          ("bib" . "kpsewhich -format=.bib %f")))
  (add-hook 'prog-mode-hook 'auto-revert-mode)
  (add-hook 'LaTeX-mode-hook 'auto-revert-mode)
  (setq reftex-try-all-extensions t)
