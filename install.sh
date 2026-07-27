#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

DRY_RUN=false
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME}"

# Parse flags
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--dry-run]"
            exit 1
            ;;
    esac
done

log_info() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

log_action() {
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY RUN]${NC} $1"
    else
        echo -e "${GREEN}→${NC} $1"
    fi
}

# Check if repo is at expected location
if [ "$REPO_DIR" != "$HOME_DIR/environment" ]; then
    log_warn "Repository is at $REPO_DIR, but bashrc/zshrc expect ~/environment/"
    log_warn "Symlinks will point to $REPO_DIR. Update bashrc/zshrc PATH if needed."
fi

# Create a backup if target already exists and is not a symlink to the right place
backup_or_skip() {
    local target="$1"
    local source="$2"
    
    if [ -e "$target" ] || [ -L "$target" ]; then
        # Check if it's already a symlink to the right place
        if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
            log_info "Already linked: $target → $source"
            return 1
        fi
        
        # Backup the existing file/link
        local backup="${target}.backup.$(date +%s)"
        if [ "$DRY_RUN" = true ]; then
            log_action "Would back up $target to $backup"
        else
            mv "$target" "$backup"
            log_action "Backed up existing file to $backup"
        fi
    fi
}

# Create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Skip if already linked correctly
    if ! backup_or_skip "$target" "$source"; then
        return 0
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log_action "Would symlink: $target → $source"
    else
        ln -s "$source" "$target"
        log_info "Symlinked: $target → $source"
    fi
}

# Check if command exists
check_command() {
    local cmd="$1"
    local optional="$2"
    
    if command -v "$cmd" &> /dev/null; then
        log_info "Found: $cmd"
    else
        if [ "$optional" = "optional" ]; then
            log_warn "Not found (optional): $cmd"
        else
            log_error "Not found (required): $cmd"
        fi
    fi
}

echo "========================================"
echo "Environment Install Script"
echo "========================================"
echo ""

# Check dependencies
echo "Checking dependencies..."
check_command "nvim"
check_command "tmux"
check_command "fzf"
check_command "rg"
check_command "goimports" "optional"
check_command "golint" "optional"
check_command "ctags" "optional"
echo ""

# Download git helper scripts
echo "Downloading git helper scripts..."
if [ ! -f "$REPO_DIR/scripts/git-completion.bash" ]; then
    if [ "$DRY_RUN" = true ]; then
        log_action "Would download git-completion.bash"
    else
        log_action "Downloading git-completion.bash"
        curl -fsSLo "$REPO_DIR/scripts/git-completion.bash" \
            "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash"
        log_info "Downloaded git-completion.bash"
    fi
else
    log_info "Already present: scripts/git-completion.bash"
fi

if [ ! -f "$REPO_DIR/scripts/git-prompt.sh" ]; then
    if [ "$DRY_RUN" = true ]; then
        log_action "Would download git-prompt.sh"
    else
        log_action "Downloading git-prompt.sh"
        curl -fsSLo "$REPO_DIR/scripts/git-prompt.sh" \
            "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh"
        log_info "Downloaded git-prompt.sh"
    fi
else
    log_info "Already present: scripts/git-prompt.sh"
fi
echo ""

# Make scripts executable
echo "Making scripts executable..."
if [ "$DRY_RUN" = true ]; then
    log_action "Would chmod +x scripts and bin"
else
    chmod +x "$REPO_DIR/scripts"/*.sh 2>/dev/null || true
    chmod +x "$REPO_DIR/bin"/* 2>/dev/null || true
    log_info "Made scripts and bin executable"
fi
echo ""

# Create symlinks for dotfiles
echo "Creating symlinks..."

create_symlink "$REPO_DIR/bashrc" "$HOME_DIR/.bashrc"
create_symlink "$REPO_DIR/zshrc" "$HOME_DIR/.zshrc"
create_symlink "$REPO_DIR/vimrc" "$HOME_DIR/.vimrc"
create_symlink "$REPO_DIR/tmux.conf" "$HOME_DIR/.tmux.conf"
create_symlink "$REPO_DIR/gitconfig" "$HOME_DIR/.gitconfig"

# Ghostty config lives in a nested dir that may not exist yet
GHOSTTY_DIR="$HOME_DIR/Library/Application Support/com.mitchellh.ghostty"
if [ "$DRY_RUN" = false ]; then
    mkdir -p "$GHOSTTY_DIR"
fi
create_symlink "$REPO_DIR/ghostty-config" "$GHOSTTY_DIR/config"

# Vim snippets - commented out as requested
# mkdir -p "$HOME_DIR/.vim/my-snippets"
# create_symlink "$REPO_DIR/vimsnippets/UltiSnips" "$HOME_DIR/.vim/my-snippets/UltiSnips"

echo ""

# Check for external dependencies
echo "Checking for external dependencies..."
if [ ! -d "$HOME_DIR/work/tmux-resurrect" ]; then
    log_warn "tmux-resurrect plugin not found at ~/work/tmux-resurrect"
    log_warn "  tmux.conf expects this plugin; clone it from https://github.com/tmux-plugins/tmux-resurrect"
fi

if [ ! -d "$HOME_DIR/.tmux/scripts" ]; then
    log_warn "tmux scripts directory not found at ~/.tmux/scripts"
    log_warn "  tmux.conf expects save/restore scripts there"
fi
echo ""

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}[DRY RUN COMPLETE]${NC}"
    echo "Re-run without --dry-run to apply changes."
else
    echo "========================================"
    echo "Installation complete!"
    echo "========================================"
    echo ""
    echo "Next steps:"
    echo "  1. Reload your shell: exec \$SHELL"
    echo "  2. Install tmux-resurrect if needed:"
    echo "     git clone https://github.com/tmux-plugins/tmux-resurrect ~/work/tmux-resurrect"
    echo "  3. Create ~/.tmux/scripts for tmux env save/restore"
fi
