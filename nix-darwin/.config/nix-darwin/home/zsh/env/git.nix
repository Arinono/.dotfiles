{pkgs, ...}: {
  gsync = pkgs.writeShellApplication {
    name = "gsync";
    runtimeInputs = [pkgs.git];

    text = ''
      if [[ ! "$1" ]]; then
        echo "You must supply a branch"
        return 1
      fi

      branches=$(git branch --list "$1")
      if [[ ! "$branches" ]]; then
        echo "branch $1 does not exist"
        return 1
      fi

      set -e
      git checkout "$1"
      git pull upstream "$1"
      git push origin "$1"
    '';
  };

  git_current_branch = pkgs.writeShellApplication {
    name = "git_current_branch";
    runtimeInputs = [pkgs.git];

    text = ''
      ref=$(git symbolic-ref --quiet HEAD 2> /dev/null)
      ret=$?

      if [[ $ret != 0 ]]; then
        [[ $ret == 128 ]] && return
        ref=$(git rev-parse --short HEAD 2> /dev/null) || return
      fi

      echo "''${ref#refs/heads/}"
    '';
  };

  aliases = with pkgs; {
    gs = "${git}/bin/git status";
    gp = "${git}/bin/git pull --rebase";
    gpa = "${git}/bin/git pull --rebase --autostash";
    gl = "${git}/bin/git lol";
    gla = "${git}/bin/git lola";
    gwa = "${git}/bin/git worktree add";
    gwr = "${git}/bin/git worktree remove";
    gwrf = "${git}/bin/git worktree remove -f";
    gwl = "${git}/bin/git worktree list";
    glol = "${git}/bin/git log --graph --pretty=\"%Cred%h%Creset - %C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset\"";
    glola = "${git}/bin/git log --graph --pretty=\"%Cred%h%Creset - %C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset\" --all";
    ga = "${git}/bin/git add";
    gap = "${git}/bin/git apply";
    gapa = "${git}/bin/git add -p";
    gb = "${git}/bin/git branch";
    gbD = "${git}/bin/git branch --delete ---force";
    gbd = "${git}/bin/git branch --delete";
    gba = "${git}/bin/git branch --all";
    gbs = "${git}/bin/git bisect";
    gbsb = "${git}/bin/git bisect bad";
    gbsg = "${git}/bin/git bisect good";
    gbsr = "${git}/bin/git bisect reset";
    gbss = "${git}/bin/git bisect start";
    gcb = "${git}/bin/git checkout -b";
    gco = "${git}/bin/git checkout";
    gd = "${git}/bin/git diff";
    gds = "${git}/bin/git diff --staged";
    gf = "${git}/bin/git fetch";
    gfo = "${git}/bin/git fetch origin";
    ggsup = "${git}/bin/git branch --set-upstream-to=origin/$(git_current_branch)";
    gpsup = "${git}/bin/git push --set-upstream origin $(git_current_branch)";
    grb = "${git}/bin/git rebase";
    grba = "${git}/bin/git rebase --abort";
    grbc = "${git}/bin/git rebase --continue";
    grbi = "${git}/bin/git rebase --interactive";
    grbo = "${git}/bin/git rebase --onto";
    grbs = "${git}/bin/git rebase --skip";
    groh = "${git}/bin/git reset origin/$(git_current_branch) --hard";
    grs = "${git}/bin/git restore";
    gsta = "${git}/bin/git stash push";
    gstp = "${git}/bin/git stash pop";
    gwip = "${git}/bin/git git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message \"--wip-- [skip ci]\"";
    gunwip = "${git}/bin/git rev-list --max-count=1 --format=\"%s\" HEAD | grep -q \"\--wip--\" && git reset HEAD~1";
    gwch = "${git}/bin/git whatchanged -p --abbrev-commit --pretty=medium";
  };
}
