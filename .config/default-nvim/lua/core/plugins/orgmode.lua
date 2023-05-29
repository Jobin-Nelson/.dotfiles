return {
	'nvim-orgmode/orgmode',
	lazy = false,
	config = function()
		require('orgmode').setup_ts_grammar()
		require('orgmode').setup({
			org_agenda_files = {
				'~/playground/projects/org_files/**/*',
				'~/playground/dev/illumina/ticket_notes/work/**/*',
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
		vim.keymap.set('n', 'yi=', '<cmd>normal! mmf=yT=`m<CR>', { desc = 'Copy org = inline code' })
		vim.keymap.set('n', 'yi~', '<cmd>normal! mmf~yT~`m<CR>', { desc = 'Copy org ~ inline code' })
	end
}
