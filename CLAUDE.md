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
# First-time setup (install instance 1 on port 8888)
ujust jupyter install 1 8888

# Start/stop the environment
ujust jupyter start 1
ujust jupyter stop 1
```

## Jupyter Commands

All commands use the format `ujust jupyter <command>`:

| Command | Purpose |
|---------|---------|
| `install <INSTANCE> <PORT> [GPU] [TAG]` | Install new instance |
| `start <INSTANCE\|all>` | Start instance(s) |
| `stop <INSTANCE\|all>` | Stop instance(s) |
| `restart <INSTANCE\|all>` | Restart instance(s) |
| `logs <INSTANCE> [LINES]` | View logs |
| `list` | List all instances |
| `status <INSTANCE>` | Detailed status |
| `url <INSTANCE>` | Show access URL |
| `shell <INSTANCE> [CMD]` | Container shell |
| `token-enable/disable/show/regenerate <INSTANCE>` | Token auth |
| `uninstall <INSTANCE\|all>` | Remove instance(s) |

GPU types: `nvidia`, `amd`, `intel`, `auto` (default), `none`

## Workspace Mounting

Your home directory (`$HOME`) is mounted as `/workspace` inside the container. Files are owned by your user via UID mapping (`keep-id`). JupyterLab opens in `/workspace` by default, giving direct access to all your files.

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
