(setq user-full-name "Jobin Nelson"
      user-mail-address "jobinnelson369@gmail.com")

(setq display-line-numbers-type 'relative
    make-backup-files nil
    auto-save-default nil
    tab-bar-mode +1)

(setq projectile-project-search-path '("~/playground/projects/"))

(setq doom-font (font-spec :family "Hack Nerd Font" :size 15)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 20)
      doom-variable-pitch-font (font-spec :family "Caskaydia Cove Nerd Font" :size 15))

(setq doom-theme 'doom-one)

(setq org-directory "~/playground/projects/org_files/"
      org-archive-location "~/playground/projects/org_files/archive_file.org::"
      org-log-done 'time)
