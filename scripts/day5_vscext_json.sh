cd ~/data-analyst-portfolio
mkdir -p .vscode
cat > .vscode/extensions.json <<'JSON'
{
  "recommendations": [
    "ms-vscode-remote.remote-wsl",
    "ms-python.python",
    "ms-python.vscode-pylance",
    "ms-toolsai.jupyter",
    "mtxr.sqltools",
    "mtxr.sqltools-driver-pg",
    "bierner.markdown-mermaid",
    "ms-azuretools.vscode-docker"
  ]
}
JSON
