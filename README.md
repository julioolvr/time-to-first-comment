# Time To First Comment

## TODO:
- [ ] Extract logic into an object that returns each PR with the number of seconds it took for the first comment to arrive. Then this can be used to generate all sorts of outputs. The object should receive an `Octokit::Client` instance already configured to avoid supporting a bunch of options to configure the connection to Github's API.
- [ ] Check filtering/sorting for comments in Github's API. If that's not possible maybe we'll have to fetch all pages to ensure we have the first comment of each type (issue and review).
- [ ] Date from/to filters.
- [ ] CLI.
