(guix-emacs-autoload-packages)

(require 'treemacs)
(require 'treemacs-evil)

(load-theme 'dracula t)
(tool-bar-mode -1)
(evil-mode 1)

(with-eval-after-load 'geiser-guile
  (add-to-list 'geiser-guile-load-path "~/src/guix"))

(setq user-full-name "Jean-Pierre De Jesus DIAZ")
(setq user-mail-address "me@jeandudey.tech")


(setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
      treemacs-deferred-git-apply-delay        0.5
      treemacs-directory-name-transformer      #'identity
      treemacs-display-in-side-window          t
      treemacs-eldoc-display                   'simple
      treemacs-file-event-delay                2000
      treemacs-file-extension-regex            treemacs-last-period-regex-value
      treemacs-file-follow-delay               0.2
      treemacs-file-name-transformer           #'identity
      treemacs-follow-after-init               t
      treemacs-expand-after-init               t
      treemacs-find-workspace-method           'find-for-file-or-pick-first
      treemacs-git-command-pipe                ""
      treemacs-goto-tag-strategy               'refetch-index
      treemacs-header-scroll-indicators        '(nil . "^^^^^^")
      treemacs-hide-dot-git-directory          t
      treemacs-indentation                     2
      treemacs-indentation-string              " "
      treemacs-is-never-other-window           nil
      treemacs-max-git-entries                 5000
      treemacs-missing-project-action          'ask
      treemacs-move-forward-on-expand          nil
      treemacs-no-png-images                   nil
      treemacs-no-delete-other-windows         t
      treemacs-project-follow-cleanup          nil
      treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
      treemacs-position                        'left
      treemacs-read-string-input               'from-child-frame
      treemacs-recenter-distance               0.1
      treemacs-recenter-after-file-follow      nil
      treemacs-recenter-after-tag-follow       nil
      treemacs-recenter-after-project-jump     'always
      treemacs-recenter-after-project-expand   'on-distance
      treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
      treemacs-project-follow-into-home        nil
      treemacs-show-cursor                     nil
      treemacs-show-hidden-files               t
      treemacs-silent-filewatch                nil
      treemacs-silent-refresh                  nil
      treemacs-sorting                         'alphabetic-asc
      treemacs-select-when-already-in-treemacs 'move-back
      treemacs-space-between-root-nodes        t
      treemacs-tag-follow-cleanup              t
      treemacs-tag-follow-delay                1.5
      treemacs-text-scale                      nil
      treemacs-user-mode-line-format           nil
      treemacs-user-header-line-format         nil
      treemacs-wide-toggle-width               70
      treemacs-width                           35
      treemacs-width-increment                 1
      treemacs-width-is-initially-locked       t
      treemacs-workspace-switch-cleanup        nil)

(treemacs-follow-mode t)
(treemacs-filewatch-mode t)
(treemacs-fringe-indicator-mode 'always)
(treemacs-git-commit-diff-mode t)

(global-set-key (kbd "C-x t t") #'treemacs)
(global-set-key (kbd "C-x t d") #'treemacs-select-directory)
