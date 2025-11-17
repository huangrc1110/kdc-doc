# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = "赛事手册"
copyright = '2016-2025, 乐聚机器人'
author = 'lejurobot'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.intersphinx",
    "sphinx.ext.viewcode",
    "sphinx.ext.napoleon",
    'sphinx_markdown_builder',
    'sphinxcontrib.video',
]
exclude_patterns = []

language = 'cn'

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'sphinx_rtd_theme'
html_static_path = ['_static']
templates_path = ['_templates']
# html_logo = '_static/images/logo_darken_font.svg'
html_logo = '_static/images/logo.png'
html_theme_options = {
    'logo_only': True,
    'version_selector': True,
    'language_selector': True,
}

locale_dirs = ['locale/']
html_context = {
  'current_version' : "Tianchi",
  'versions' : [["Tianchi", "tianchi"], ["ICRA", "icra"]],
  'current_language': 'cn',
  'languages': [["cn", "cn"], ["en", "en"]],
  'DEBUG': True
}

# Hide the "View page source" link next to breadcrumbs
html_show_sourcelink = False
