import click
import glob
import os
from assnake.core.sample_set import generic_command_individual_samples, generate_result_list
from assnake.core.command_builder import sample_set_construction_options, add_options
from assnake.core.result import Result
from assnake.core.config import read_assnake_instance_config

from pathlib import Path


@click.command('salmon', short_help='Quasi transcript aligner')
@add_options(sample_set_construction_options)
@click.option('--reference',
              help='Reference to use',
              required=True,
              type=click.STRING)
@click.pass_obj
def salmon_invoke(config, reference, **kwargs):
    sample_set, sample_set_name = generic_command_individual_samples(
        config, **kwargs)

    res_list = []

    for s in sample_set.to_dict(orient='records'):
        preprocessing = s['preproc']
        res_list.append('{fs_prefix}/{df}/salmon__v1.1.0/{reference}/{df_sample}/{preproc}/quant.sf'.format(
            fs_prefix=s['fs_prefix'].rstrip('\/'),
            df=s['df'],
            preproc=preprocessing,
            df_sample=s['df_sample'],
            reference=reference
        ))

    config['requests'] += res_list
    config['requested_results'] += [{'result': 'salmon',
                                     'sample_set': sample_set, 'type': 'aligner'}]


result = Result.from_location(name='salmon',
                              location=os.path.dirname(os.path.abspath(__file__)), 
                              input_type='illumina_sample', 
                              additional_inputs=None, 
                              invocation_command=salmon_invoke)
