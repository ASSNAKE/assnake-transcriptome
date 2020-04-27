import os
import assnake
from assnake.utils import read_yaml


from assnake_transcriptome.invocation_commands import feature_counts
from assnake_transcriptome.salmon.commands import salmon_invoke

this_dir = os.path.dirname(os.path.abspath(__file__))
snake_module = assnake.SnakeModule(name = 'assnake-transcriptome', 
                           install_dir = this_dir,
                           snakefiles = ['./hisat2_workflow.smk', './salmon/workflow.smk'],
                           invocation_commands = [feature_counts, salmon_invoke],
                           initialization_commands = [],
                           wc_configs = [
                            #    read_yaml(os.path.join(this_dir, './wc_config.yaml'))
                               ])