@_default:
    just --list

# Build a development environment
devenv:
    uv sync --extra dev --refresh --upgrade

# Run tests and linting
test *args: devenv
    uv run tox {{args}}

# Format files
format: devenv
    uv run tox exec -e py39-lint -- ruff format

# Lint files
lint: devenv
    uv run tox -e py39-lint

# Wipe dev environment and build artifacts
clean:
    rm -rf build dist src/crashstats_tools.egg-info .tox .pytest_cache/
    rm -rf docs/_build/*
    find src tests/ -name __pycache__ | xargs rm -rf
    find src tests/ -name '*.pyc' | xargs rm -rf

# Update README with fresh cog output
docs: devenv
    uv run python -m cogapp -r README.rst

# Build files for relase
build: devenv
    rm -rf build/ dist/
    uv run python -m build
    uv run twine check dist/*
