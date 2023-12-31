return {
	'nvim-orgmode/orgmode',
  event = 'VeryLazy',
	config = function()
		require('orgmode').setup_ts_grammar()
		require('orgmode').setup({
			org_agenda_files = {
				'~/playground/projects/org_files/**/*',
				'~/playground/dev/illumina/ticket_notes/work_org_files/**/*',
			},
			org_default_notes_file = '~/playground/projects/org_files/refile.org',
			org_todo_keywords = { 'TODO(t)', 'NEXT(n)', '|', 'DONE(d)', 'CANCELLED(c)' },
			org_archive_location = '~/playground/projects/org_files/archive_file.org',
			org_hide_leading_stars = false,
			org_hide_emphasis_markers = true,
			org_agenda_span = 'day',
			org_blank_before_new_entry = { heading = false, plain_list_item = false },
			org_indent_mode = 'noindent',
			org_log_into_drawer = 'LOGBOOK',
		})
    for _, key in ipairs({ '=', '~'}) do
      vim.keymap.set('v', 'i'..key, string.format('t%soT%s', key, key), { desc = string.format('inner org %s', key) })
      vim.keymap.set('v', 'a'..key, string.format('f%soF%s', key, key), { desc = string.format('around org %s', key) })
      vim.keymap.set('o', 'i'..key, string.format('<cmd>normal! t%svT%s<CR>', key, key), { desc = string.format('inner org %s', key) })
      vim.keymap.set('o', 'a'..key, string.format('<cmd>normal! f%svF%s<CR>', key, key), { desc = string.format('around org %s', key) })
    end
	end
}
