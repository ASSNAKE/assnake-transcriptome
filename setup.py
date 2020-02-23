from typing import Union

from setuptools import setup, find_packages
from setuptools.command.develop import develop
from setuptools.command.install import install
from assnake.utils import get_config_loc, load_config_file
import os, shutil
import click



setup(
    name='assnake-transcriptome',
    version='0.0.1',
    packages=find_packages(),
    entry_points = {
        'assnake.plugins': ['assnake-transcriptome = assnake_transcriptome.snake_module_setup:snake_module']
    }
)