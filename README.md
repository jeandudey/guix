# Making Rust Analyzer work with Flatpak VS Code:

```bash
flatpak --user override com.visualstudio.code \
        --env=PATH=/app/bin:/usr/bin:/run/current-system/profile/bin:/home/$USER/.guix-home/profile/bin:/home/$USER/.guix-profile/bin
```
