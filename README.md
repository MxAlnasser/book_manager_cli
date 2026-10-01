# Personal Book Manager

## Run it

```bash
cd book_manager_cli
chmod +x app.sh ui/*.sh workflows/*.sh books/*.sh recommendations/*.sh data/*.sh
./app.sh
```

Install [Gum](https://github.com/charmbracelet/gum) for the nicer menu. The app also works with Bash's built-in `select` menu when Gum is not installed.

## Codex recommendations

The recommendation workflow uses the local Codex CLI. Install and authenticate Codex so that this command works:

```bash
codex exec --skip-git-repo-check -m gpt-6-luna "say hi"
```

When you choose **Get Recommendations**, three Codex agents run at the same time. They read `data/books.csv` and use different prompts for history, interests, and discovery. Their results are combined, filtered for duplicates and books already in the library, and shown as a shortlist. Codex runs with a read-only sandbox and does not modify project files. If Codex is unavailable or returns no usable results, the app uses local fallback recommendations.

## Architecture

The app follows `UI -> workflows -> components -> data -> CSV`. `app.sh` starts the menu. UI scripts display information, workflow scripts coordinate actions, book and recommendation scripts do one small job, and `data/book_database.sh` is the only file that reads or writes `books.csv`.

Recommendations demonstrate the data flow required for this assignment: three independent Codex agents run in parallel with `&`, `$!`, and `wait`; their output is combined with `cat`, piped into `refine_recommendations.sh`, and displayed by the UI. Progress is shown while the agents work. If Codex is unavailable, each agent uses two local example recommendations.

## Personalization

This library is personalized around design, architecture, systems thinking, and technology. The recommendation agents reflect three ways I like to explore: learning from saved books, following my interests, and deliberately trying an unfamiliar subject.