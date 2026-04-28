#!/usr/bin/env python

font_name = "small_block.flf"

# FIGlet Header:
# signature(flf2a), hardblank($), height(2), baseline(2), max_length(15),
# old_layout(-1 for Full Width/No Smushing), comment_lines(3)
header = "flf2a$ 2 2 15 -1 3\n"
comments = "Custom Small Block Unicode Font\nExact spacing preserved\n2-row height\n"

# Precise mapping from your provided alphabet + trailing space
chars = {
    'A': ('▄▀█ ', '█▀█ '),
    'B': ('█▄▄ ', '█▄█ '),
    'C': ('█▀▀ ', '█▄▄ '),
    'D': ('█▀▄ ', '█▄▀ '),
    'E': ('█▀▀ ', '██▄ '),
    'F': ('█▀▀ ', '█▀░ '),
    'G': ('█▀▀ ', '█▄█ '),
    'H': ('█░█ ', '█▀█ '),
    'I': ('█ ', '█ '),
    'J': ('░░█ ', '█▄█ '),
    'K': ('█▄▀ ', '█░█ '),
    'L': ('█░░ ', '█▄▄ '),
    'M': ('█▀▄▀█ ', '█░▀░█ '),
    'N': ('█▄░█ ', '█░▀█ '),
    'O': ('█▀█ ', '█▄█ '),
    'P': ('█▀█ ', '█▀▀ '),
    'Q': ('█▀█ ', '▀▀█ '),
    'R': ('█▀█ ', '█▀▄ '),
    'S': ('█▀ ', '▄█ '),
    'T': ('▀█▀ ', '░█░ '),
    'U': ('█░█ ', '█▄█ '),
    'V': ('█░█ ', '▀▄▀ '),
    'W': ('█░█░█ ', '▀▄▀▄▀ '),
    'X': ('▀▄▀ ', '█░█ '),
    'Y': ('█▄█ ', '░█░ '),
    'Z': ('▀█ ', '█▄ '),
    ' ': ('  ', '  '),
}


def generate_flf():
    with open(font_name, "w", encoding="utf-8") as f:
        f.write(header)
        f.write(comments)

        # FIGlet requires definitions for ASCII 32 through 126
        for i in range(32, 127):
            char_key = chr(i).upper()

            if char_key in chars:
                top, bot = chars[char_key]
            else:
                # Fallback for undefined characters (numbers, symbols)
                top, bot = ("  ", "  ")

            # Syntax: Line 1 ends with @, Line 2 ends with @@
            if i == 32:  # Space character
                f.write("$$@\n$$@@\n")
            else:
                f.write(f"{top}@\n{bot}@@\n")


if __name__ == "__main__":
    generate_flf()
    print(f"Successfully generated: {font_name}")
