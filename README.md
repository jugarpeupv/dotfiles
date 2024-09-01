# Dotfiles

## Dependencies

- `stow`: Install instructions
    * Linux: https://github.com/aspiers/stow/blob/master/INSTALL.md
    * Macos: 
    ```sh
    brew install stow
    ```
- `nvim`: https://github.com/neovim/neovim/blob/master/INSTALL.md
- `skhd`: https://github.com/koekeishiya/skhd?tab=readme-ov-file#install
- `tmux`: https://github.com/tmux/tmux?tab=readme-ov-file#installation


## Usage

1- Clone the repository into `$HOME` directory
```sh
git clone https://github.com/jugarpeupv/dotfiles.git
```

2- Stow the contents to create the symlinks
```sh
cd dotfiles && stow */
```

If it fails, make sure to backup your old config, and rerun with
```sh
stow */ --adopt
```
