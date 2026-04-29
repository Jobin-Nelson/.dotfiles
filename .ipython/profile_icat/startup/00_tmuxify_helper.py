def _tr(path: str):
    """Hidden helper to run the tmuxify temp file with dedenting."""
    import os
    import textwrap

    if not os.path.exists(path):
        return

    with open(path, 'r') as f:
        # Dedent here so the Bash script stays simple
        code = textwrap.dedent(f.read())

    # store_history=False keeps this call out of your IPython history
    get_ipython().run_cell(code, store_history=False)
