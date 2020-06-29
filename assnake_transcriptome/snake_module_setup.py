import os
import assnake

import assnake_transcriptome.salmon.result as salmon


this_dir = os.path.dirname(os.path.abspath(__file__))
snake_module = assnake.SnakeModule(name = 'assnake-transcriptome', 
                           install_dir = this_dir,
                           snakefiles = [],
                           invocation_commands = [],
                           initialization_commands = [],
                           results = [salmon]
                           )