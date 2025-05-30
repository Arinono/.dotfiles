{...}: {
  programs.gh-dash = {
    enable = true;
    settings = {
      prSections = [
        {
          title = "Requested Reviews";
          filters = "is:open repo:withthegrid/platform review-requested:@me";
        }
        {
          title = "My PRs";
          filters = "is:open repo:withthegrid/platform author:@me";
        }
        {
          title = "Subscribed";
          filters = "is:open repo:withthegrid/platform -author:@me -author:app/dependabot";
        }
        {
          title = "Debrief";
          filters = "repo:withthegrid/platform author:@me";
          layout = {
            author.hidden = true;
            reviewStatus.hidden = true;
            ci.hidden = true;
            assignees.hidden = true;
            base.hidden = true;
          };
        }
      ];

      issuesSections = [
        {
          title = "Assigned";
          filters = "is:open assignee:@me";
        }
        {
          title = "Triage";
          filters = "is:open project:withthegrid/19";
          layout.assignee.hidden = false;
        }
        {
          title = "Created";
          filters = "is:open author:@me";
          layout.creator.hidden = true;
        }
      ];

      defaults = {
        layout = {
          pr.repo.hidden = true;
          issues = {
            state.hidden = true;
            repo.hidden = true;
            reactions.hidden = true;
          };
        };
        prsLimit = 20;
        issuesLimit = 20;
        preview = {
          open = false;
          width = 60;
        };
        refetchIntervalMinutes = 5;
      };

      repoPaths = {
        ":owner/:repo" = "~/workspace/:repo";
        default_path = "~/workspace";
        "withthegrid/platform" = "~/workspace/wtg/platform.git";
      };

      pager.diff = "more";
    };
  };
}
