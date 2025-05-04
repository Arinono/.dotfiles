{
  pkgs,
  isDarwin,
  params,
  ...
}: let
  browser =
    if isDarwin
    then "arc"
    else "brave";
in
  with pkgs; {
    home.file = {
      ".gitconfig".text =
        /*
        toml
        */
        ''
          [user]
            name = ${params.fullname}
            email = ${params.email}
          [gpg]
            program = ${gnupg}/bin/gpg
          [web]
            browser = ${browser}
          [core]
            editor = ${neovim}/bin/nvim
            excludesFile = ~/.gitignore
            ignorecase = false
          [color]
            branch = auto
            diff = auto
            interactive = auto
            status = auto
          [credentials]
            helper = cache --timeout=300
          [difftool]
            prompt = false
          [diff]
            tool = nvimdiff
          [difftool "nvimdiff"]
            cmd = "${neovim}/bin/nvim -d \"$LOCAL\" \"$REMOTE\""
          [commit]
            gpgsign = false # true
          [pull]
            rebase = true
          [rebase]
            updateRefs = true
          [push]
            autoSetupRemote = true
          [url "ssh://git@github.com:arinono/"]
            insteadOf = "https://github.com/arinono"
          [url "ssh://git@github.com:withthegrid/"]
            insteadOf = "https://github.com/withthegrid"
          [url "git@github.com:arinono/"]
            insteadOf = "me:"
          [url "git@github.com:wtg/"]
            insteadOf = "wtg:"
          [rerere]
            enabled = true
          [init]
            defaultBranch = main
          [filter "lfs"]
            clean = ${git-lfs}/bin/git-lfs clean -- %f
            smudge = ${git-lfs}/bin/git-lfs smudge -- %f
            process = ${git-lfs}/bin/git-lfs filter-process
            required = true
          [filter "git-crypt"]
            smudge = ${git-crypt}/bin/git-crypt smudge
            clean = ${git-crypt}/bin/git-crypt clean
            required = true
          [diff "git-crypt"]
            textconv = ${git-crypt}/bin/git-crypt diff
          [alias]
            apa = add --patch
            st = status
            ci = commit
            cim = commit -m
            cam = commit --amend
            cams = commit --amend --no-verify
            came = commit --amend --no-edit
            cames = commit --amend --no-edit --no-verify
            sta = stash push
            staa = stash push --all
            stp = stash pop
            ba = branch -a
            bd = branch -d
            bD = branch -D
            co = checkout
            d = diff
            ds = diff --staged
            l = lol
            lol = log --graph --pretty="%Cred%h%Creset - %C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"
            lola = log --graph --pretty="%Cred%h%Creset - %C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all
            wa = worktree add
            wl = worktree list
            wr = worktree remove
            wrf = worktree remove -f
            next = stack next
            prev = stack previous
            reword = stack reword
            amend = stack amend
            sync = stack sync
            run = stack run
        '';

      ".gitignore".text = ''
        *.DS_Store
        *.LSOverride
        Thumbs.db
        .bundle
        .pnpm-debug.log
        /result
        /target
      '';
    };
  }
