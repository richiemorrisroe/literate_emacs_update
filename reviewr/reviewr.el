;;; reviewr.el --- Review agent-generated diffs with annotations  -*- lexical-binding: t; -*-

;; Copyright (C) 2024

;; Author: Richie
;; Version: 0.2.0
;; Package-Requires: ((emacs "29.1") (magit "4.0.0"))
;; Keywords: tools, magit, review

;;; Commentary:

;; `reviewr-mode' is a minor mode for reviewing code diffs (e.g. agent-generated
;; changes shown in magit-diff) with line-by-line annotations — approve, reject,
;; comment — and sending the structured review results back to an agent-shell
;; buffer so the agent can act on your feedback.
;;
;; ## Workflow
;;
;;   1. Agent (Claude Code, etc.) generates code via agent-shell.
;;   2. The changes appear as unstaged diffs in magit.
;;   3. Open the diff buffer (magit-status + press `d` or `TAB` on a file).
;;   4. Use `reviewr-mode` keybindings to mark lines/hunks.
;;   5. Send the compiled review to the agent with `C-c e s`.
;;
;; ## Keybindings
;;
;;   C-c e a   reviewr-approve-line         Approve line(s) at point or region
;;   C-c e k   reviewr-reject-line          Reject line(s) at point or region
;;   C-c e c   reviewr-comment-line         Add a comment to line(s) at point or region
;;   C-c e u   reviewr-unmark-line          Remove annotation from line(s)
;;   C-c e A   reviewr-approve-hunk         Approve the entire current hunk
;;   C-c e K   reviewr-reject-hunk          Reject the entire current hunk
;;   C-c e n   reviewr-next-unreviewed      Jump to next unreviewed hunk
;;   C-c e p   reviewr-prev-unreviewed      Jump to previous unreviewed hunk
;;   C-c e s   reviewr-send-review          Send structured review to agent-shell
;;   C-c e S   reviewr-send-review-and-switch  Send review and switch to agent
;;   C-c e v   reviewr-show-summary         Show review summary in a popup
;;   C-c e .   reviewr-show-line-comments   Show comments on the current line
;;   C-c e x   reviewr-clear-annotations    Clear all annotations in buffer

;;; Code:

(require 'magit)
(require 'magit-diff)

;; ---- Customization -------------------------------------------------------

(defgroup reviewr nil
  "Review agent-generated diffs with annotations."
  :group 'tools
  :prefix "reviewr-")

(defcustom reviewr-auto-activate t
  "Whether `reviewr-mode' auto-activates in `magit-diff-mode' buffers."
  :type 'boolean
  :group 'reviewr)

(defcustom reviewr-default-agent-shell nil
  "When non-nil, the specific agent-shell buffer name to send reviews to.
When nil, use the most recent agent-shell buffer or prompt to create one."
  :type '(choice (const :tag "Most recent or prompt" nil)
                 (string :tag "Buffer name"))
  :group 'reviewr)

(defcustom reviewr-always-submit nil
  "When non-nil, auto-submit the review text to the agent after insertion."
  :type 'boolean
  :group 'reviewr)

(defcustom reviewr-approve-face '((t (:background "#1a3a1a" :extend t)))
  "Face for approved lines."
  :type 'list
  :group 'reviewr)

(defcustom reviewr-reject-face '((t (:background "#3a1a1a" :extend t)))
  "Face for rejected lines."
  :type 'list
  :group 'reviewr)

(defcustom reviewr-comment-face '((t (:background "#3a3a1a" :extend t)))
  "Face for commented lines."
  :type 'list
  :group 'reviewr)

(defcustom reviewr-review-preamble
  "## Code Review Results

I have reviewed the changes. Here is my feedback:
"
  "Text prepended to the compiled review report."
  :type 'string
  :group 'reviewr)

;; ---- Faces ---------------------------------------------------------------

(defface reviewr-approve-line
  '((t (:background "#1a4a1a" :extend t)))
  "Face for approved lines."
  :group 'reviewr)

(defface reviewr-reject-line
  '((t (:background "#4a1a1a" :extend t)))
  "Face for rejected lines."
  :group 'reviewr)

(defface reviewr-comment-line
  '((t (:background "#4a4a1a" :extend t)))
  "Face for commented lines."
  :group 'reviewr)

;; ---- Keymap --------------------------------------------------------------

(defvar reviewr-mode-map
  (let ((map (make-sparse-keymap)))
    ;; Line-level
    (define-key map (kbd "C-c e a") #'reviewr-approve-line)
    (define-key map (kbd "C-c e k") #'reviewr-reject-line)
    (define-key map (kbd "C-c e c") #'reviewr-comment-line)
    (define-key map (kbd "C-c e u") #'reviewr-unmark-line)
    ;; Hunk-level
    (define-key map (kbd "C-c e A") #'reviewr-approve-hunk)
    (define-key map (kbd "C-c e K") #'reviewr-reject-hunk)
    ;; Navigation
    (define-key map (kbd "C-c e n") #'reviewr-next-unreviewed)
    (define-key map (kbd "C-c e p") #'reviewr-prev-unreviewed)
    ;; Review actions
    (define-key map (kbd "C-c e s") #'reviewr-send-review)
    (define-key map (kbd "C-c e S") #'reviewr-send-review-and-switch)
    (define-key map (kbd "C-c e v") #'reviewr-show-summary)
    (define-key map (kbd "C-c e .") #'reviewr-show-line-comments)
    (define-key map (kbd "C-c e x") #'reviewr-clear-annotations)
    map)
  "Keymap for `reviewr-mode'.")

;; ---- Minor Mode ----------------------------------------------------------

;;;###autoload
(define-minor-mode reviewr-mode
  "Minor mode for reviewing code diffs with line-by-line annotations.

When enabled in a `magit-diff-mode' buffer, lets you mark individual
lines or entire hunks as approved, rejected, or commented.  A
structured review report can then be sent to an agent-shell buffer.

Keybindings:
\\{reviewr-mode-map}"
  :lighter " Reviewr"
  :keymap reviewr-mode-map
  :group 'reviewr
  (if reviewr-mode
      (progn
        (when (derived-mode-p 'magit-diff-mode)
          (setq-local reviewr--annotations (make-hash-table :test #'equal))
          (message "reviewr: C-c e a/k/c to annotate, C-c e s to send review")))
    (reviewr-clear-annotations)
    (kill-local-variable 'reviewr--annotations)))

;;;###autoload
(defun reviewr-activate-in-magit-diff ()
  "Activate `reviewr-mode' in `magit-diff-mode' buffers."
  (when (and reviewr-auto-activate
             (derived-mode-p 'magit-diff-mode))
    (reviewr-mode +1)))

;; ---- Annotation State ----------------------------------------------------

(defvar-local reviewr--annotations nil
  "Hash table keyed by (file . line-number) → plist of annotation data.

Each value is a plist:
  :status  - one of `approved', `rejected', `commented'
  :comment - string (only for `commented')
  :file    - file path string
  :line    - line number integer
  :content - the diff line text")

(defvar-local reviewr--overlays nil
  "List of overlays created by reviewr.")

(defun reviewr--line-key (&optional pos)
  "Return a unique key (FILE . LINE) for the diff line at POS (or point).
Works inside a magit-diff hunk."
  (let* ((file (magit-diff--file))
         (line (line-number-at-pos pos)))
    (when file
      (cons file line))))

(defun reviewr--get-hunk-bounds ()
  "Return (START . END) of the hunk at point, or nil if not in a hunk."
  (let ((section (magit-current-section)))
    (when (and section (eq (oref section type) 'hunk))
      (cons (oref section start) (oref section end)))))

(defun reviewr--diff-line-p ()
  "Return non-nil if point is on a diff line inside a hunk body.
Excludes the hunk header line."
  (let ((bounds (reviewr--get-hunk-bounds)))
    (and bounds
         (>= (point) (save-excursion
                       (goto-char (car bounds))
                       (forward-line 1)
                       (point)))
         (<= (point) (cdr bounds)))))

(defun reviewr--line-text ()
  "Return the text of the current line (without properties)."
  (buffer-substring-no-properties (line-beginning-position)
                                  (line-end-position)))

;; ---- Annotating Lines ----------------------------------------------------

(defun reviewr--annotate-lines (status &optional comment)
  "Mark lines in the region or at point with STATUS.
STATUS is one of `approved', `rejected', `commented'.
COMMENT is an optional string (required when status is `commented')."
  (unless (reviewr--diff-line-p)
    (user-error "Point is not on a diff line inside a hunk"))
  (let* ((beg (if (region-active-p) (region-beginning) (line-beginning-position)))
         (end (if (region-active-p) (region-end) (line-end-position)))
         (lines ()))
    ;; Collect all lines in range
    (save-excursion
      (goto-char beg)
      (beginning-of-line)
      (while (<= (point) end)
        (when (reviewr--diff-line-p)
          (push (list (point) (reviewr--line-key) (reviewr--line-text)) lines))
        (forward-line 1)))
    (setq lines (nreverse lines))

    (when (and (eq status 'commented) (not comment))
      (setq comment (read-string "Review comment: ")))

    (dolist (line-info lines)
      (let ((pos (nth 0 line-info))
            (key (nth 1 line-info))
            (text (nth 2 line-info)))
        ;; Store annotation
        (puthash key
                 `(:status ,status
                   :comment ,comment
                   :file ,(car key)
                   :line ,(cdr key)
                   :content ,text)
                 reviewr--annotations)
        ;; Apply overlay
        (reviewr--apply-overlay pos status)))
    (message "reviewr: marked %d line(s) as %s"
             (length lines) status)))

(defun reviewr--apply-overlay (pos status)
  "Place or update an overlay at POS with face for STATUS."
  ;; Remove existing overlay at this line
  (dolist (ov (overlays-at pos))
    (when (overlay-get ov 'reviewr-annotation)
      (delete-overlay ov)))
  ;; Create new overlay
  (let* ((face (pcase status
                 ('approved 'reviewr-approve-line)
                 ('rejected 'reviewr-reject-line)
                 ('commented 'reviewr-comment-line)))
         (ov (make-overlay (line-beginning-position pos)
                           (1+ (line-end-position pos)))))
    (overlay-put ov 'face face)
    (overlay-put ov 'reviewr-annotation status)
    (overlay-put ov 'reviewr-line-key (reviewr--line-key pos))
    (push ov reviewr--overlays)
    ov))

;;;###autoload
(defun reviewr-approve-line ()
  "Approve line(s) at point or in the active region."
  (interactive)
  (reviewr--annotate-lines 'approved))

;;;###autoload
(defun reviewr-reject-line ()
  "Reject line(s) at point or in the active region."
  (interactive)
  (reviewr--annotate-lines 'rejected))

;;;###autoload
(defun reviewr-comment-line (comment)
  "Add a comment to line(s) at point or in the active region."
  (interactive "sComment: ")
  (reviewr--annotate-lines 'commented comment))

;;;###autoload
(defun reviewr-unmark-line ()
  "Remove annotation from line(s) at point or in the active region."
  (interactive)
  (let ((beg (if (region-active-p) (region-beginning) (line-beginning-position)))
        (end (if (region-active-p) (region-end) (line-end-position))))
    (save-excursion
      (goto-char beg)
      (beginning-of-line)
      (while (<= (point) end)
        (let* ((key (reviewr--line-key))
               (ovs (overlays-at (point))))
          (when key
            (remhash key reviewr--annotations))
          (dolist (ov ovs)
            (when (overlay-get ov 'reviewr-annotation)
              (setq reviewr--overlays (delq ov reviewr--overlays))
              (delete-overlay ov))))
        (forward-line 1))))
  (message "reviewr: annotations removed"))

;; ---- Hunk-level Annotations ----------------------------------------------

(defun reviewr--annotate-hunk (status)
  "Annotate all diff lines in the current hunk with STATUS."
  (let ((bounds (reviewr--get-hunk-bounds)))
    (unless bounds
      (user-error "Not on a hunk"))
    (save-excursion
      (goto-char (car bounds))
      (forward-line 1)                ; skip hunk header
      (let ((count 0))
        (while (< (point) (cdr bounds))
          (when (and (not (eolp))
                     (memq (char-after) '(?\s ?- ?\+)))
            (reviewr--annotate-lines status)
            (setq count (1+ count)))
          (forward-line 1))
        (message "reviewr: marked %d lines in hunk as %s" count status)))))

;;;###autoload
(defun reviewr-approve-hunk ()
  "Approve all diff lines in the current hunk."
  (interactive)
  (reviewr--annotate-hunk 'approved))

;;;###autoload
(defun reviewr-reject-hunk ()
  "Reject all diff lines in the current hunk."
  (interactive)
  (reviewr--annotate-hunk 'rejected))

;; ---- Navigation ----------------------------------------------------------

(defun reviewr--find-unreviewed-hunks ()
  "Return a list of (START . END) for hunks with no annotations."
  (let ((unreviewed ())
        (ann reviewr--annotations))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "^@@" nil t)
        (let* ((hunk-start (line-beginning-position 0))
               (hunk-end (save-excursion
                           (if (re-search-forward "^@\\|\\'" nil t)
                               (line-beginning-position 0)
                             (point-max))))
               (has-annotations nil))
          ;; Check if any line in this hunk has annotations
          (save-excursion
            (goto-char hunk-start)
            (forward-line 1)
            (while (< (point) hunk-end)
              (when (reviewr--line-key)
                (when (gethash (reviewr--line-key) ann)
                  (setq has-annotations t)
                  (goto-char hunk-end)))
              (forward-line 1)))
          (unless has-annotations
            (push (cons hunk-start hunk-end) unreviewed)))))
    (nreverse unreviewed)))

;;;###autoload
(defun reviewr-next-unreviewed ()
  "Jump to the next hunk without annotations."
  (interactive)
  (let* ((current (point))
         (hunks (reviewr--find-unreviewed-hunks))
         (next (seq-find (lambda (h) (> (car h) current)) hunks)))
    (if next
        (progn
          (goto-char (car next))
          (recenter))
      (message "reviewr: no more unreviewed hunks"))))

;;;###autoload
(defun reviewr-prev-unreviewed ()
  "Jump to the previous hunk without annotations."
  (interactive)
  (let* ((current (point))
         (hunks (nreverse (reviewr--find-unreviewed-hunks)))
         (prev (seq-find (lambda (h) (< (car h) current)) hunks)))
    (if prev
        (progn
          (goto-char (car prev))
          (recenter))
      (message "reviewr: no previous unreviewed hunks"))))

;; ---- Review Summary ------------------------------------------------------

(defun reviewr--build-review-report ()
  "Compile all annotations into a structured review report string."
  (unless (hash-table-p reviewr--annotations)
    (user-error "No annotations in this buffer"))
  (let* ((by-file (make-hash-table :test #'equal))
         (approved-count 0)
         (rejected-count 0)
         (comment-count 0))

    ;; Group annotations by file
    (maphash
     (lambda (key ann)
       (let* ((file (or (plist-get ann :file) "unknown"))
              (existing (gethash file by-file '())))
         (puthash file (cons ann existing) by-file)
         (cl-incf (pcase (plist-get ann :status)
                    ('approved approved-count)
                    ('rejected rejected-count)
                    ('commented comment-count)))))
     reviewr--annotations)

    ;; Build report
    (with-temp-buffer
      (insert (or reviewr-review-preamble ""))
      (newline)

      (maphash
       (lambda (file annotations)
         (let ((file-approved 0) (file-rejected 0) (file-commented 0))
           (dolist (ann annotations)
             (cl-incf (pcase (plist-get ann :status)
                        ('approved file-approved)
                        ('rejected file-rejected)
                        ('commented file-commented))))

           (insert (format "### %s\n" file))

           (when (> file-approved 0)
             (insert (format "✅ Approved: %d line(s)\n" file-approved)))
           (when (> file-rejected 0)
             (insert (format "❌ Rejected: %d line(s)\n" file-rejected)))
           (when (> file-commented 0)
             (insert (format "💬 Comments: %d\n" file-commented)))

           (insert "\n")

           ;; Detail per line
           (dolist (ann (nreverse annotations))
             (let* ((status (plist-get ann :status))
                    (line (plist-get ann :line))
                    (content (plist-get ann :content))
                    (comment (plist-get ann :comment))
                    (marker (pcase status
                              ('approved "✅")
                              ('rejected "❌")
                              ('commented "💬"))))
               (insert (format "%s | L%s | `%s`\n" marker line (or content "")))
               (when comment
                 (insert (format "   └─ %s\n" comment)))))
           (insert "\n")))
       by-file)

      ;; Summary line
      (insert (format "---\n**Summary:** ✅ %d approved | ❌ %d rejected | 💬 %d comments\n"
                      approved-count rejected-count comment-count))
      (buffer-string))))

;;;###autoload
(defun reviewr-show-summary ()
  "Display the current review summary in a popup buffer."
  (interactive)
  (unless (and (derived-mode-p 'magit-diff-mode) reviewr-mode)
    (user-error "reviewr-mode is not active"))
  (let ((report (reviewr--build-review-report)))
    (with-current-buffer (get-buffer-create "*reviewr-summary*")
      (erase-buffer)
      (insert report)
      (goto-char (point-min))
      (display-buffer (current-buffer)
                      '(display-buffer-pop-up-window
                        (inhibit-same-window . t))))))

;;;###autoload
(defun reviewr-show-line-comments ()
  "Show the comment on the current line, if any."
  (interactive)
  (let* ((key (reviewr--line-key))
         (ann (and key (gethash key reviewr--annotations))))
    (if ann
        (let ((status (plist-get ann :status))
              (comment (plist-get ann :comment)))
          (message "reviewr: %s%s"
                   (pcase status
                     ('approved "✅ Approved")
                     ('rejected "❌ Rejected")
                     ('commented (format "💬 Comment: %s" comment)))
                   (if (and (eq status 'commented) comment)
                       ""
                     "")))
      (message "reviewr: no annotation on this line"))))

;; ---- Sending Review ------------------------------------------------------

(defun reviewr--find-agent-shell-buffer ()
  "Find an agent-shell buffer to send to.
Returns a buffer object or nil."
  (or (and reviewr-default-agent-shell
           (get-buffer reviewr-default-agent-shell))
      (let ((bufs (seq-filter
                   (lambda (b)
                     (with-current-buffer b
                       (derived-mode-p 'agent-shell-mode)))
                   (buffer-list))))
        (car bufs))))

(defun reviewr--get-or-create-agent-shell-buffer ()
  "Get an agent-shell buffer, creating one if needed.
Returns a buffer object."
  (or (reviewr--find-agent-shell-buffer)
      (with-temp-buffer
        (save-window-excursion
          (call-interactively #'agent-shell)
          (current-buffer)))))

;;;###autoload
(defun reviewr-send-review ()
  "Send the compiled review report to the agent-shell buffer."
  (interactive)
  (unless (and (derived-mode-p 'magit-diff-mode) reviewr-mode)
    (user-error "reviewr-mode is not active"))
  (let* ((report (reviewr--build-review-report))
         (shell-buffer (reviewr--get-or-create-agent-shell-buffer)))
    (unless shell-buffer
      (user-error "No agent-shell buffer available and could not create one"))
    (with-demoted-errors "reviewr error: %S"
      (agent-shell--insert-to-shell-buffer
       :shell-buffer shell-buffer
       :text report
       :submit reviewr-always-submit))
    (message "reviewr: sent review report to %s" (buffer-name shell-buffer))))

;;;###autoload
(defun reviewr-send-review-and-switch ()
  "Send the compiled review report and switch to the agent-shell buffer."
  (interactive)
  (unless (and (derived-mode-p 'magit-diff-mode) reviewr-mode)
    (user-error "reviewr-mode is not active"))
  (let* ((report (reviewr--build-review-report))
         (shell-buffer (reviewr--get-or-create-agent-shell-buffer)))
    (unless shell-buffer
      (user-error "No agent-shell buffer available and could not create one"))
    (with-demoted-errors "reviewr error: %S"
      (agent-shell--insert-to-shell-buffer
       :shell-buffer shell-buffer
       :text report
       :submit reviewr-always-submit))
    (switch-to-buffer shell-buffer)))

;;;###autoload
(defun reviewr-clear-annotations ()
  "Remove all reviewr annotations and overlays from the current buffer."
  (interactive)
  (when (and (derived-mode-p 'magit-diff-mode) reviewr-mode)
    (dolist (ov reviewr--overlays)
      (ignore-errors (delete-overlay ov)))
    (setq reviewr--overlays nil)
    (when (hash-table-p reviewr--annotations)
      (clrhash reviewr--annotations))
    (message "reviewr: all annotations cleared")))

;; ---- Register hooks ------------------------------------------------------

;;;###autoload
(add-hook 'magit-diff-mode-hook #'reviewr-activate-in-magit-diff)

(provide 'reviewr)

;;; reviewr.el ends here
