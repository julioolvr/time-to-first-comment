require 'octokit'
require 'chronic_duration'
require 'slop'

module TimeToFirstComment
  class Cli
    def respond(arguments)
      opts = Slop.parse(arguments) do
        on :r, :repo=, 'Repository to look for PRs on'
        on :f, :from=, 'PRs created since this date - YYYY-MM-DD', argument: :optional
        on :t, :to=, 'PRs created up to this date - YYYY-MM-DD', argument: :optional
      end

      unless opts.map(&:value).compact.any?
        puts opts.help
        return
      end

      if opts.missing.include?('repo')
        puts 'Missing repository.'
        puts opts.help
        return
      end

      stats = TimeToFirstComment::PullRequestsStats.new(Octokit::Client.new)

      stats.time_to_first_comment(opts[:repo], from: opts[:from], to: opts[:to]).each do |pull, seconds|
        if seconds
          puts %(#{pull.title}: #{ChronicDuration.output(seconds)} until first comment.)
        else
          puts %(#{pull.title}: No comments yet.)
        end
      end
    end
  end
end
