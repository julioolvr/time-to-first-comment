# Time To First Comment

Know how much it took for PRs on a repo to get their first comment.

# Usage

```
gem install time_to_first_comment
```

## CLI

The gem comes bundled with a CLI to quickly get data for a repo:

```
$ time_to_first_comment --repo someuser/somerepo --from 2015-12-01 --to 2015-12-15
Some pull request: No comments yet.
Some other pull request: 17 hrs 21 mins 2 secs until first comment.
```

Available options:

```
$ time_to_first_comment
Usage: time_to_first_comment [options]
    -r, --repo          Repository to look for PRs on
        --from          PRs created since this date - YYYY-MM-DD
        --to            PRs created up to this date - YYYY-MM-DD
    -e, --endpoint      Custom API endpoint to connect to Github Enterprise
    -t, --token         Access Token to query Github as a specific user
```

## API

You can use the gem in your own code to use the data any way you want:

```
require 'time_to_first_comment'

# You have to pass an instance of Octokit::Client that the gem will use to query Github.
# This way, you can configure that instance any way you like.
stats = TimeToFirstComment::PullRequestsStats.new(Octokit::Client.new)

stats.time_to_first_comment('someuser/somerepo').each do |pull, seconds|
  # Here `pull` is an instance of Sawyer::Resource returned by Octokit::Client.
  # `seconds` is the number of seconds until that PR got its first comment, or nil if there were none yet.
end
```
