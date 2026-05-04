# Zdouc Laboratory Master Student Onboarding Information

<img src="https://github.com/zdouc-lab/.github/raw/main/profile/zdouc_logo_v1.svg" style="width: 25vw"/>

*Nota bene: this is a living document and will change with time. Make sure to return regularly.*

## Table of contents

This document describes best practices in software engineering employed in the Zdouc Lab.
Members of the Zdouc Lab are expected to follow these guidelines when writing computer code.
This document is structured as follows:

- [Software engineering and clean code](#clean-code)
- [Languages](#languages)
- [Principles](#principles)
- [Checklist](#checklist)
- [Collaborative programming](#collaborative-programming)


## Clean Code

Writing code is not difficult - even machines (GenAI) are doing it reasonably well.
The actual challenge lies in writing code that is readable, structured, concise, and scales well with increasing complexity.
Code should be written in a way that it can be effortlessy picked up by any reasonably experienced programmer, due to its adherence to conventions and patterns.

Writing good code is like building a house: if the foundation is not crafted well, there is going to be a lot of technical debt to pay in the long run.

People have come up with concepts such as [Clean Code](https://en.wikipedia.org/wiki/Robert_C._Martin#Clean_Code) or [Sofware Craftmanship](https://en.wikipedia.org/wiki/Software_craftsmanship) that relates coding to practicing a craft, such as being a carpenter.
Code written following such principles should be well-written, maintainable, and clean - in short, something to be proud of.

Software created by the Zdouc Lab should follow such principles - not only due to professional pride, but also due to ease of maintenance.

### Languages

The programming language of choice in the Zdouc Lab is Python 3. 
Python is beginner-friendly, reasonably fast, and accommodating to a variety of tasks.
Most importantly, Python is very readable, facilitating maintenance.

This description focuses on Python as a language, although it can be generally applicable. 
Should you desire to use a different programming language for your project, discuss with Mitja first.


### Principles

Software engineering principles employed by the Zdouc Lab include but are not restricted to:

- Clean Code Principles
- TDD (Test-Driven Development)
- OOP (Object-Oriented Programming - where applicable)
- KISS (Keep it Super Simple)
- DRY (Don’t Repeat Yourself)
- SOLID Principles (where possible)
- Low cognitive complexity of code
- Concise documentation: why, not how
- Consistent logging
- Use design patterns (when applicable)

### Checklist

This checklist gives an overview of the elements that we expect from your coding project:

- Employ a project-appropriate directory structure and [the `uv` project and package manager](https://docs.astral.sh/uv/) to have reproducible builds
- Use version control (`git`) and continuous integration/continous deployment (CI/CD) where applicable
- Use the [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)
- Use the [`ruff` linter and formatter](https://docs.astral.sh/ruff/) to keep code style consistent
- Use [`pre-commit`](https://pre-commit.com/) to run quality control packages before every commit

### Collaborative programming

Distributed development (i.e. more than one person working on a project) can be challenging. 
By following a few principles and best practices can lead to a pleasant and frustration-free experience.

#### Git branching model

*Nota bene: this workflow assumes that a GitHub repository already exists.*

The use of branches and version control in general is an essential part of distributed development. 
It allows to separate ‘prodution’ code (the main branch, code that is tested and running) from 'development' code (feature branches, experimental code). 
Keep in mind that version control does not replace communication - make sure to talk early and often to prevent merge conflicts (two branches that change the same code in main). 
Below are the steps necessary to create and manage branches.

#### Working with Git

- While in the main branch, create a new local branch: `git checkout -b <your_branch_name>`. You will be now on the new local branch.
- Push your local branch to the remote: `git push origin <your_branch_name>`. On the GitHub page, your branch should now appear.
- Set the remote branch as the upstream branch of your local branch:  `git branch --set-upstream-to=origin/<your_branch_name>`
- Start working and adding commits.
- Once the feature is ready, create a pull request via the GitHub GUI.
- After the branch is merged into main, delete the dev branch.
- Locally, change into your local main branch: `git checkout main`
- Pull in the newest changes: `git pull`
- Delete your local development branch: `git branch -d <your_branch_name>`


#### Workflow

- Features are planned, discussed, and assigned beforehand
- Each feature has a separate branch
- Version control is no replacement for communication. Communicate early and often to prevent merge conflicts.
- Keep commits short. Commit early and often.
- Once a feature is ready, a draft pull request should be made for a first code review.
- A code review is performed, and if approved, the branch is mered and closed.
