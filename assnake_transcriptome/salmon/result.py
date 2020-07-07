import click, os
from assnake.core.result import Result

result = Result.from_location(name='salmon',
                              description='Quasi transcript aligner',
                              result_type='aligner',
                              location=os.path.dirname(os.path.abspath(__file__)), 
                              input_type='illumina_sample', 
                              additional_inputs=[
                                  click.option('--reference', help='Reference to use', required=True, type=click.STRING)
                              ])
