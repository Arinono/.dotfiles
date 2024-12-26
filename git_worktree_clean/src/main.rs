use indicatif::ProgressBar;
use rayon::prelude::*;
use std::{io::Cursor, process::Command};

use anyhow::Result;
use clap::Parser;
use skim::prelude::*;

#[derive(Parser, Debug)]
struct Cli {
    #[clap(short, long)]
    force: bool,
}

fn main() -> Result<()> {
    let args = Cli::parse();

    let options = SkimOptionsBuilder::default()
        .height(Some("100%"))
        .multi(true)
        .preview(None)
        .build()?;

    let output = Command::new("git").arg("worktree").arg("list").output()?;

    let output_str = String::from_utf8_lossy(&output.stdout);
    let worktrees = output_str.lines().collect::<Vec<&str>>();

    let item_reader = SkimItemReader::default();
    let items = item_reader.of_bufread(Cursor::new(worktrees.join("\n")));

    let selected = Skim::run_with(&options, Some(items))
        .map(|out| {
            if out.is_abort {
                println!("ciao");
                std::process::exit(0);
            }
            out.selected_items
        })
        .expect("failed to  process")
        .iter()
        .map(|selected_item| {
            (**selected_item)
                .as_any()
                .downcast_ref::<String>()
                .unwrap()
                .to_owned()
        })
        .map(|item| item.to_owned())
        .collect::<Vec<String>>();

    let pb = ProgressBar::new(selected.len() as u64);
    selected.par_iter().for_each(|item| {
        let worktree = item.split_whitespace().collect::<Vec<&str>>();
        let worktree = worktree[0];

        let output = Command::new("git")
            .arg("worktree")
            .arg("remove")
            .arg(worktree)
            .arg(match args.force {
                true => "--force",
                false => "",
            })
            .output()
            .expect("failed to execute process");

        if let Ok(output_err) = String::from_utf8(output.stderr) {
            println!("{}", output_err);
        }

        pb.inc(1);
    });
    pb.finish_with_message("done");

    Ok(())
}
