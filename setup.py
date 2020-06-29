from typing import Union

from setuptools import setup, find_packages
from setuptools.command.develop import develop
from setuptools.command.install import install
import os, shutil
import click



setup(
    name='assnake-transcriptome',
    version='0.0.2',
    packages=find_packages(),
    entry_points = {
        'assnake.plugins': ['assnake-transcriptome = assnake_transcriptome.snake_module_setup:snake_module']
    }
)