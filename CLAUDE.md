# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains example Jupyter notebooks for [bazzite-ai](https://github.com/atrawog/bazzite-ai). The notebooks demonstrate GPU/CUDA verification, PyTorch workflows, and data science templates designed to run in the bazzite-ai Jupyter pod environment.

## Environment

These notebooks require the bazzite-ai Jupyter environment with:
- Python 3.13+
- PyTorch with CUDA 12.6+
- ML/AI stack (transformers, langchain, HuggingFace ecosystem)
- Data science libraries (pandas, numpy, matplotlib, seaborn, scikit-learn)

Start the environment:
```bash
ujust jupyter start
```

## Notebooks

| Notebook | Purpose |
|----------|---------|
| `01-cuda-verification.ipynb` | Verify CUDA/GPU access, check GPU properties, benchmark CPU vs GPU performance |
| `02-pytorch-quickstart.ipynb` | Neural network training workflow: model definition, training loop, visualization, model save/load |
| `03-data-science-template.ipynb` | Data exploration, visualization (matplotlib/seaborn), statistical analysis, scikit-learn ML basics |

## Architecture

All notebooks follow a consistent structure:
1. Markdown header with learning objectives
2. Library imports and device setup (GPU detection)
3. Numbered sections with markdown explanations before code
4. Summary section with next steps and resources

The notebooks are designed as templates - synthetic data is used for demonstrations, with comments indicating where to substitute real datasets.

## Development Notes

- Notebooks include executed outputs showing results from an RTX 4080 SUPER GPU
- GPU availability checks include fallback messages for CPU-only environments
- Model files (e.g., `simple_nn_model.pth`) are generated during execution and excluded via `.gitignore`
