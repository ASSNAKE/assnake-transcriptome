import assnake.api.loaders
import assnake
from tabulate import tabulate
import click
import pandas as pd 
from assnake.cli.cli_utils import sample_set_construction_options, add_options, generic_command_individual_samples, generate_result_list
import os, datetime 

@click.command('salmon', short_help='Salmon quasi trabscript aligner')

@add_options(sample_set_construction_options)
@click.option('--reference', 
                help='Reference to use', 
                required=True,
                type=click.STRING )

@click.pass_obj
def salmon_invoke(config, reference, **kwargs):
    sample_set, sample_set_name = generic_command_individual_samples(config, **kwargs)

    res_list = []

    for s in sample_set.samples_pd.to_dict(orient='records'):
        preprocessing = s['preproc']
        res_list.append( '{fs_prefix}/{df}/salmon__v1.1.0/{reference}/{sample}/{preproc}/quant.sf'.format(
            fs_prefix = s['fs_prefix'].rstrip('\/'),
            df = s['df'],
            preproc = preprocessing,
            sample = s['fs_name'],
            reference = reference
        ))

    config['requests'] += res_list
    

    