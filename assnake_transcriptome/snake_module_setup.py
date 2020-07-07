import os
import assnake

snake_module = assnake.SnakeModule(name = 'assnake-transcriptome', 
                           install_dir = os.path.dirname(os.path.abspath(__file__)),
                           )