{...}: {
  # settings that aliases to programs.fish

  generateCompletions = true;
  shellAbbrs = {
    lg = "lazygit";
    gd = "git diff";
    ga = "git add .";
    gc = "git commit -am";
    gl = "git log";
    gs = "git status";
    gst = "git stash";
    gsp = "git stash pop";
    gp = "git push";
    gpl = "git pull";
    gsw = "git switch";
    gsm = "git switch main";
    gb = "git branch";
    gbd = "git branch -d";
    gco = "git checkout";
    gsh = "git show";
  };
  shellInitLast = ''
    # For jumping between prompts in foot terminal
        function mark_prompt_start --on-event fish_prompt
            echo -en "\e]133;A\e\\"
        end
  '';
}
