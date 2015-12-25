require 'octokit'
require 'chronic_duration'
require './pull_requests_stats'

repo = 'julioolvr/count-to-1000'
stats = PullRequestsStats.new(Octokit::Client.new)

stats.time_to_first_comment(repo).each do |pull, seconds|
  if seconds
    puts %(#{ChronicDuration.output(seconds)} until first comment for: "#{pull.title}" )
  else
    puts %(No comments yet for pull request: "#{pull.title}", )
  end
end
