(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")))

(add-to-list 'package-archives '("elpa" . "https://elpa.gnu.org/packages/"))

(package-initialize)
(unless package-archive-contents
    (package-refresh-contents))
;; Download packages
;; which-key - show keys in emacs
;; flycheck - syntax checker
;; evil - vim integration in emacs
;; doom-themes - cool themes for emacs
;; company - completion plugin
;; ivy - completion plugin not only for code
;; use-package managing packages
;; ivy-xref ivy-like references in lsp
;; undo-tree next generation of undo/redo
;; tree-sitter       -+ Better highlighting
;; tree-sitter-langs -+
;; graphviz-dot-mode - convinient graphviz preview

(add-to-list 'auto-mode-alist '("^/usr/include/c++/12.2.1/" . c++-mode))

(setq package-selected-packages '(lsp-ui tree-sitter-langs tree-sitter undo-tree helm
					 ivy-xref use-package helm ivy company ccls
					 which-key flycheck lsp-mode evil doom-themes
					 graphviz-dot-mode uncrustify-mode helm-xref
					 clang-format))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
 (mapc #' package-install package-selected-packages))

;; load theme
(load-theme 'doom-monokai-classic t)
;; Turn off menu and tool bar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
;; which-key enable
(use-package which-key
  :config (which-key-mode 1))

;; Enable flycheck and company
(global-company-mode)
(global-flycheck-mode)

;; write only errors
(setq warning-minimum-level :error)

;; Lsp config
;; Turn off flymake
(setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))

;; Lsp config
(use-package lsp-mode
  :hook (((c-mode c++-mode) . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :config
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-lens-enable nil)
  (setq lsp-log-io nil)
  (setq lsp-use-plists t)
  (setq lsp-prefer-flymake nil)
  :commands lsp)


(setq gc-cons-threshold 1000000000
      read-process-output-max (* 1024 1024)
      )

(use-package ccls
  :init
  (setq ccls-initialization-options '(:index (:comments 2) :completion (:detailedLabel t)))
  :config
  (setq ccls-executable "/usr/bin/ccls")
  (setq ccls-sem-highlight-method 'overlay)
  :bind ("C-l" . ccls-code-lens-mode)
  :hook ((c-mode c++-mode) . (lambda () (require 'ccls) (lsp))))

;; Useful function for ccls
(defun ccls/callee () (interactive) (lsp-ui-peek-find-custom "$ccls/call" '(:callee t)))
(defun ccls/caller () (interactive) (lsp-ui-peek-find-custom "$ccls/call"))
(defun ccls/vars (kind) (lsp-ui-peek-find-custom "$ccls/vars" `(:kind ,kind)))
(defun ccls/base (levels) (lsp-ui-peek-find-custom "$ccls/inheritance" `(:levels ,levels)))
(defun ccls/derived (levels) (lsp-ui-peek-find-custom "$ccls/inheritance" `(:levels ,levels :derived t)))
(defun ccls/member (kind) (interactive) (lsp-ui-peek-find-custom "$ccls/member" `(:kind ,kind)))


(use-package lsp-ui
  :config
   (setq lsp-ui-doc-include-signature nil)  ; don't include type signature in the child frame
   (setq lsp-ui-sideline-show-symbol t)  ; don't show symbol on the right of info
   (setq lsp-ui-doc-enable t)
   (setq lsp-ui-sideline-enable t)
   (setq lsp-ui-sideline-show-code-actions t)
   (setq lsp-ui-sideline-show-hover t)
   (setq lsp-modeline-code-actions-enable t)
   (setq lsp-eldoc-enable-hover t)
   (setq lsp-eldoc-render-all t)
)

(use-package undo-tree
  :config
  (global-undo-tree-mode)
  (setq undo-tree-auto-save-history t)
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo/"))))

;; Enable evil
(use-package evil
  :init
  (evil-mode 1)
  :bind (
	 :map evil-normal-state-map
	      ("g d" . lsp-ui-peek-find-definitions)
  	      ("g r" . lsp-ui-peek-find-references)
	      ("g h" . lsp-ui-doc-show)
	      ("g v" . (lambda () (interactive) (ccls/member 0)))       ;; get members of class / namespace
	      ("g i" . (lambda () (interactive) (ccls/derived 1)))    ;; get direct derived classes
	      ("g I" . (lambda () (interactive) (ccls/derived 1000))) ;; get all derived classes
	      ("g b" . (lambda () (interactive) (ccls/base 1)))       ;; get direct base classes
	      ("g B" . (lambda () (interactive) (ccls/base 1000)))    ;; get all base classes
	      ("g f" . (lambda () (interactive) (ccls/member 3)))     ;; => member function / function in namespace
	      ("g c" . ccls/caller)
	      ("g C" . ccls/callee)

	)
  :config
  (setq evil-undo-system 'undo-tree))

;; graphviz-dot-mode
(use-package graphviz-dot-mode
  :ensure t
  :config
  (setq graphviz-dot-indent-width 4))

;; ivy config
(ivy-mode)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key (kbd "M-x") 'execute-extended-command)
(global-set-key (kbd "C-x C-f") 'find-file)

(defun my-c-mode ()
  (setq c-basic-offset 4
	c-default-style "linux")
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'substatement-open nil)
  (c-set-offset 'inline-open nil)
)

;; c/c++ code style config
(use-package cc-mode
  :init
  :hook ((c-mode c++-mode) . my-c-mode)
)

;; clang-format config

(defun clang-format-save-hook-for-this-buffer ()
  "Create a buffer local save hook."
  (add-hook 'before-save-hook
            (lambda ()
              (when (locate-dominating-file "." ".clang-format")
                (clang-format-buffer))
              ;; Continue to save.
              nil)
            nil
            ;; Buffer local hook.
            t))

(use-package clang-format
  :config
  (setq clang-format-style "file")
  :hook
  ((c-mode c++-mode) . clang-format-save-hook-for-this-buffer)
  )

;; (use-package uncrustify-mode
;;   :hook ((c-mode c++-mode) . uncrustify-mode)
;; )

;; Enable helm


(use-package helm
  :init
  (helm-mode 1)
  :bind*
  ("C-c C-f" . helm-find-files)
  (
  :map helm-map
  ("C-j" . helm-next-line)
  ("C-k" . helm-previous-line)
  ("C-;" . helm-execute-persistent-action)
  )
  )

(define-key global-map (kbd "C-c C-f") #'helm-find-files)

(use-package tree-sitter
  :hook
  ((c-mode c++-mode) . tree-sitter-hl-mode)
  )


;; global config

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(setq backup-directory-alist '((".*" . "~/.emacs.d/autosaves/")))
(setq auto-save-file-name-transforms `((".*" "~/.emacs.d/autosaves/" t)))
(make-directory "~/.emacs.d/autosaves/" t)

(setq create-lockfiles nil)



;; ivy-xref config
(use-package ivy-xref
  :ensure t
  :init
  ;; xref initialization is different in Emacs 27 - there are two different
  ;; variables which can be set rather than just one
  (when (>= emacs-major-version 27)
    (setq xref-show-definitions-function #'ivy-xref-show-defs))
  ;; Necessary in Emacs <27. In Emacs 27 it will affect all xref-based
  ;; commands other than xref-find-definitions (e.g. project-find-regexp)
  ;; as well
  (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(graphviz-dot-preview-extension "jpg")
 '(package-selected-packages '(cmake-mode helm-lsp evil doom-themes)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
